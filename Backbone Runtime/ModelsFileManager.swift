//
//  ModelsFileManager.swift
//  Backbone Runtime
//
//  Created by Anton Kovalenko on 27.07.2022.
//

import Foundation
import CoreML

struct MLModelInfo {
    let name: String
    let url: URL
}


final class ModelsFileManager {
    
    var documentsDirectory: URL {
        get {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
    }
    
    func saveModel(at url: URL?, with name: String) {
        let pathToMLModels = documentsDirectory.appendingPathComponent("MLModels")
        
        guard let fileURL = url else { return }
        do {
            let compiledUrl = try! MLModel.compileModel(at: fileURL)
            let savedURL = pathToMLModels.appendingPathComponent(compiledUrl.lastPathComponent)
            try FileManager.default.moveItem(at: compiledUrl, to: savedURL)
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print ("file error: \(error)")
        }
    }
    
    
    func getAllModels() -> [MLModelInfo] {
        let pathToMLModels = documentsDirectory.appendingPathComponent("MLModels")
        do {
            let directoryContents = try FileManager
                .default
                .contentsOfDirectory(at: pathToMLModels, includingPropertiesForKeys: nil)
                .filter { $0.lastPathComponent.contains(".mlmodelc") }
            print(directoryContents)
            return directoryContents.map { MLModelInfo(name: $0.fileName, url: $0) }
        } catch {
           return []
        }
    }
    
    init() {
        let modelsFolder = documentsDirectory.appendingPathComponent("MLModels")
        if !FileManager.default.fileExists(atPath: modelsFolder.path) {
            do {
                try FileManager.default.createDirectory(
                    atPath: modelsFolder.path,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension URL {
    var fileName: String {
        return lastPathComponent.replacingOccurrences(of: ".mlmodel", with: "")
    }
}
