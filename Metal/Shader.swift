//
//  Shader.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/20/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Metal

class ShaderAttribute {
    
    init(aName: String, aBindingPoint: Int) {
        name = aName
        bindingPoint = aBindingPoint
    }
    
    var name = ""
    var bindingPoint = 0
}

class Shader {
    var title = ""
    
    var attributes = [ShaderAttribute]()
    
    var vertexFunction = ""
    var fragmentFunction = ""
    
    class func fromJson(pathToJson: String) -> Shader? {
        
        let url = NSURL(fileURLWithPath: pathToJson)
        var json: [String: AnyObject]!
        if let stream = NSInputStream(URL: url){
            do {
                stream.open()
                json = try NSJSONSerialization.JSONObjectWithStream(stream, options: NSJSONReadingOptions()) as? [String: AnyObject]
            } catch {
                print(error)
            }
        }
        
        let shader = Shader()
        
        if let name = json["name"] as? String {
            shader.title = name
        }
        
        if let fragmentFunction = json["fragmentFunction"] as? [String: AnyObject] {
            if let functionName = fragmentFunction["name"] as? String {
                shader.fragmentFunction = functionName
            }
            
            if let attributes = fragmentFunction["attributes"] as? [String] {
                var bindingPoint = 0
                for attribute in attributes {
                    shader.attributes.append(ShaderAttribute(aName: attribute, aBindingPoint: bindingPoint))
                    bindingPoint++
                }
            }
        }
        
        return shader
    }
}