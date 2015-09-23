//
//  File.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public enum AGFileFormatterParams:String {
    case Name = "name"
    case Path = "path"
    case Format = "format"
}

public struct AGFileFormatter {
    private let formats: Set<String> = [
        "mp4",
        "wmv",
        "avi",
        "mpg",
        "mpeg",
        "mov",
        "asf",
        "mkv",
        "flv",
        "m4v",
        "rmvb"
    ]
    
    public func getFileParamters(filePath:String) -> [String:String?]{
        let name:String? = self.getName(filePath)
        let format:String? = self.getExtenstion(name)
        let params = [
            AGFileFormatterParams.Name.rawValue: name,
            AGFileFormatterParams.Format.rawValue: format,
            AGFileFormatterParams.Path.rawValue: filePath
        ]
        
        return params
    }
    
    private func getName(fullPath:String) -> String? {
        let parts:[String] = fullPath.componentsSeparatedByString("/")
        if let name:String = parts.last {
            return name
        }
        return nil
    }
    
    private func getExtenstion(name:String?) -> String? {
        if name != nil {
            let parts:[String] = name!.componentsSeparatedByString(".")
            if parts.count > 1  {
                if let format:String = parts.last {
                    if self.formats.contains(format) {
                        return format
                    }
                }
            }
        }
        
        return nil
    }
}
