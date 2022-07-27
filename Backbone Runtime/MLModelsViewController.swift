//
//  MLModelsViewController.swift
//  Backbone Runtime
//
//  Created by Anton Kovalenko on 27.07.2022.
//

import UIKit

class MLModelsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var modelsList: [MLModelInfo] = []
    
    let fileManager = ModelsFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadAvaliableModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            if let coordinator = transitionCoordinator {
                coordinator.animate(alongsideTransition: { context in
                    self.tableView.deselectRow(at: selectedIndexPath, animated: true)
                }) { context in
                    if context.isCancelled {
                        self.tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: .none)
                    }
                }
            } else {
                self.tableView.deselectRow(at: selectedIndexPath, animated: animated)
            }
        }
    }
}

extension MLModelsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard
            .instantiateViewController(withIdentifier: "SelectImageViewController") as? SelectImageViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MLModelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MLModelCell", for: indexPath) as? MLModelCell else {
            return UITableViewCell()
        }
        cell.configure(mlModelName: modelsList[indexPath.row].name)
        return cell
    }
}


private extension MLModelsViewController {
    func setupUI() {
        navigationItem.title = "Доступные модели"
        let rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        rightBarButtonItem.target = self
        rightBarButtonItem.action = #selector(addButtonTapped)
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "MLModelCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "MLModelCell")
    }
    
    func loadAvaliableModels() {
        modelsList = fileManager.getAllModels()
        tableView.reloadData()
    }
    
    @objc func addButtonTapped() {
        let ac = UIAlertController(title: "Введите URL для скачивания модели", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Скачать", style: .default) { [unowned ac, weak fileManager, weak tableView] _ in
            guard let text = ac.textFields![0].text, let url = URL(string: text) else {
                return
            }
            print(url)
            
            let downloadTask = URLSession.shared.downloadTask(with: url) {
                urlOrNil, responseOrNil, errorOrNil in
                fileManager?.saveModel(at: urlOrNil, with: url.lastPathComponent)
                DispatchQueue.main.async {
                    tableView?.reloadData()
                }
            }
            downloadTask.resume()
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
}
