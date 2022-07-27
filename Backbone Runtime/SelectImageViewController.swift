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


private extension URL {
    var modelName: String {
        return lastPathComponent.replacingOccurrences(of: ".mlmodelc", with: "")
    }
}

extension Array where Element: BinaryFloatingPoint {
    var average: Double {
        if self.isEmpty {
            return 0.0
        } else {
            let sum = self.reduce(0, +)
            return Double(sum) / Double(self.count)
        }
    }
    
}

extension UIImage {
    
    public func pixelBuffer(width: Int, height: Int) -> CVPixelBuffer? {
        return pixelBuffer(width: width, height: height,
                           pixelFormatType: kCVPixelFormatType_32ARGB,
                           colorSpace: CGColorSpaceCreateDeviceRGB(),
                           alphaInfo: .noneSkipFirst)
    }
    
    // UIImage -> RGB
    func pixelBuffer(width: Int, height: Int, pixelFormatType: OSType,
                     colorSpace: CGColorSpace, alphaInfo: CGImageAlphaInfo) -> CVPixelBuffer? {
        var maybePixelBuffer: CVPixelBuffer?
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
             kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue]
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         width,
                                         height,
                                         pixelFormatType,
                                         attrs as CFDictionary,
                                         &maybePixelBuffer)
        
        guard status == kCVReturnSuccess, let pixelBuffer = maybePixelBuffer else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
        
        guard let context = CGContext(data: pixelData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                                      space: colorSpace,
                                      bitmapInfo: alphaInfo.rawValue)
        else {
            return nil
        }
        
        UIGraphicsPushContext(context)
        context.translateBy(x: 0, y: CGFloat(height))
        context.scaleBy(x: 1, y: -1)
        self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}

class SelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var modelInfo: MLModelInfo?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select Image"
        label.numberOfLines = 0
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        
        tap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func didTapImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top,
            width: view.frame.size.width-40,
            height: view.frame.size.width-40)
        label.frame = CGRect(
            x: 20,
            y: view.safeAreaInsets.top+(view.frame.size.width-40)+10,
            width: view.frame.size.width-40,
            height: 100
        )
    }
    
    func processingName(name: String) -> String {
        let resultName = name.replacingOccurrences(of: "_", with: " ").replacingOccurrences(of: ".mlmodel", with: "")
        return resultName
    }
    
    func downloadClasses(path: String) -> [String] {
        let file = try! String(contentsOfFile: path)
        let labels: [String] = file.components(separatedBy: "\n")
        
        return labels
    }
    
    func inferenceOneModel(modelURL: URL, image: UIImage) -> (MLMultiArray, MLMultiArray, CFAbsoluteTime) {
        let compiledUrl = try! MLModel.compileModel(at: modelURL)
        let model = try! MLModel(contentsOf: compiledUrl, configuration: MLModelConfiguration())
        
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
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let modelInfo = modelInfo else { return }
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        let pathToLabels = Bundle.main.path(forResource: "imagenet_classes", ofType: "txt")
        let labels = downloadClasses(path: pathToLabels!)
        
        let countRuns: Int = 100
        
        var probs5k = try! MLMultiArray([1]), indices5k = try! MLMultiArray([1]), timeInSec = CFAbsoluteTimeGetCurrent()
        
        imageView.image = image
        
        var cumsumTime = [] as [Double]
        
        for _ in 0...countRuns - 1 {
            (_, _, timeInSec) = inferenceOneModel(modelURL: modelInfo.url, image: image)
            cumsumTime.append(Double(timeInSec))
        }
        
        (probs5k, indices5k, _) = inferenceOneModel(modelURL: modelInfo.url, image: image)
        
        var info: String = "Min time:\n\(String(describing: cumsumTime.min()!))\nMax time:\n\(String(describing: cumsumTime.max()!))\nAverage time:\n\(String(describing: cumsumTime.average))\n"
        
        for i in 0...indices5k.count - 1 {
            let index = Int(indices5k[i].int32Value)
            info += "\n\(labels[index]): \(probs5k[i].floatValue)"
        }
        
        print(info)
        
        let alert = UIAlertController(title: modelInfo.name, message: info, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
}
