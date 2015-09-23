//
//  AGFile.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public class AGFile {
    let fullPath:String
    var fileName:String?
    
    var format:String?
    
    init(path:String, fileName:String?, format:String?) {
        self.fullPath = path
        self.format = format
        self.fileName = fileName
    }
    
    convenience init(parameters: [String:String?]) {
        let path = parameters[AGFileFormatterParams.Path.rawValue]!
        let name = parameters[AGFileFormatterParams.Name.rawValue]!
        let format = parameters[AGFileFormatterParams.Format.rawValue]!
        self.init(path:path!, fileName:name, format:format)
    }
    
    public func lowerCaseName() -> String? {
        if self.fileName == nil {
            return self.fileName
        }
        
        return self.fileName!.lowercaseString
    }
    
    public func description() -> String {
        let name = self.fileName == nil ? "No name" : self.fileName!
        let format = self.format == nil ? "No format" : self.format!
        return "name: \(name) format: \(format) path: \(self.fullPath)"
    }
}