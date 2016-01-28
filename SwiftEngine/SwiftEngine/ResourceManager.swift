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
    
    var assets: [(name: String, asset: MDLAsset)]?
    
    func getAsset(name: String) -> (String, MDLAsset)? {
        for asset in assets! {
            if asset.name == name {
                return asset
            }
        }
        
        return nil
    }
    
    func loadAsset(name: String, path: String) -> Bool {
        let url = NSURL(fileURLWithPath: path)
        let asset = MDLAsset(URL: url)
        
        assets?.append((name, asset))
        return true
    }
    
    private init() {
        
    }
}

