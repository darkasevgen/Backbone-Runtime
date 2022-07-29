//
//  ViewController.swift
//  Backbone Runtime
//
//  Created by  Евгений Каськов on 20.01.2022.
//

import UIKit
import CoreML
import Vision
import Accelerate

final class SelectImageViewController: UIViewController {
    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var progressLabelBackgroundView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var progressLabel: UILabel!
    
    var modelInfo: MLModelInfo?
    var imagePickerController: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController = .init()
        imagePickerController?.sourceType = .photoLibrary
        imagePickerController?.delegate = self

        setupUI()
    }
    
    @IBAction func didTapProcessImage(_ sender: Any) {
        guard let image = selectedImageView.image else { return }
        
        let countRuns: Int = 100
        
        activityIndicator.startAnimating()
        restoreProgressBar()
        
        DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
            guard let modelInfo = self.modelInfo else { return }

            let pathToLabels = Bundle.main.path(forResource: "imagenet_classes", ofType: "txt")
            let labels = self.downloadClasses(path: pathToLabels!)
            

            var probs5k = try! MLMultiArray([1]), indices5k = try! MLMultiArray([1]), timeInSec = CFAbsoluteTimeGetCurrent()
            
            let model = try! MLModel(contentsOf: modelInfo.url, configuration: MLModelConfiguration())
            
            var cumsumTime = [] as [Double]
            
            for currentCountRun in 0...countRuns - 1 {
                (_, _, timeInSec) = self.inferenceOneModel(model: model, image: image)
                cumsumTime.append(Double(timeInSec))
                
                DispatchQueue.main.async {
                    self.progressLabel.text = "\(currentCountRun + 1)/\(countRuns)"
                    self.progressBar.setProgress(Float(currentCountRun + 1)/Float(countRuns), animated: false)
                }
            }
            
            (probs5k, indices5k, _) = self.inferenceOneModel(model: model, image: image)
            
            var info = """
            Min time:\n\(String(describing: cumsumTime.min()!))
            Max time:\n\(String(describing: cumsumTime.max()!))
            Average time:\n\(String(describing: cumsumTime.average))\n
            """
            
            for i in 0...indices5k.count - 1 {
                let index = Int(indices5k[i].int32Value)
                info += "\n\(labels[index]): \(probs5k[i].floatValue)"
            }
            
            print(info)
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.restoreProgressBar()
                let alert = UIAlertController(title: modelInfo.name, message: info, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func downloadClasses(path: String) -> [String] {
        let file = try! String(contentsOfFile: path)
        let labels: [String] = file.components(separatedBy: "\n")
        
        return labels
    }
    
    func inferenceOneModel(model: MLModel, image: UIImage) -> (MLMultiArray, MLMultiArray, CFAbsoluteTime) {
        let desc = model.modelDescription.inputDescriptionsByName["image"]
        let w = desc!.imageConstraint!.pixelsWide
        let h = desc!.imageConstraint!.pixelsHigh
        let inputImage = image.pixelBuffer(width: w, height: h)
        
        let inputs: [String: Any] = [ "image": MLFeatureValue(pixelBuffer: inputImage!) ]
        
        let provider = try? MLDictionaryFeatureProvider(dictionary: inputs)
        
        let start = CFAbsoluteTimeGetCurrent()
        let result = try? model.prediction(from: provider!)
        let inferenceTime = CFAbsoluteTimeGetCurrent() - start
        
        let probsTop5k = result!.featureValue(for: "probs")?.multiArrayValue
        let indicesTop5k = result!.featureValue(for: "indices")?.multiArrayValue
        
        return (probsTop5k!, indicesTop5k!, inferenceTime)
        
    }
}


extension SelectImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.selectedImageView.image = image
    }
}

private extension SelectImageViewController {
    func setupUI() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        
        tap.numberOfTapsRequired = 1
        selectedImageView.isUserInteractionEnabled = true
        selectedImageView.addGestureRecognizer(tap)
        
        selectedImageView.image = UIImage(systemName: "photo")
        selectedImageView.contentMode = .scaleAspectFit
    }
    
    func restoreProgressBar() {
        progressLabel.text = ""
        progressBar.setProgress(0, animated: false)
    }
    
    @objc func didTapImage() {
        guard let picker = imagePickerController else { return }
        present(picker, animated: true)
    }
}
