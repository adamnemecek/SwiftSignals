//
//  ResourceManager.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 1/25/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import ModelIO

class ResourceManager {
    
    
    static let sharedInstance = ResourceManager()
    
    var assets: [(path: String, asset: Mesh)]?
    
    func getAsset(path: String) -> (String, Mesh)? {
        for asset in assets! {
            if asset.path == path {
                return asset
            }
        }
        
        return nil
    }
    
    func loadAsset(path: String, context: MetalContext) -> Bool {
        let asset = Mesh(filePath: path, context: context)
        assets?.append((path, asset))
        return true
    }
    
    private init() {
        
    }
}