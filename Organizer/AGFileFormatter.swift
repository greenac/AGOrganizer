//
//  File.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public enum AGFileFormatterParam:String
{
    case OriginalName = "OriginalName"
    case OriginalBasePath = "OriginalPath"
    case Format = "format"
    case NewBasePath = "NewBasePath"
    case NewName = "NewName"
    case Index = "Index"
}

public struct AGFileFormatter
{
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
    
    public func createFile(fileName:String, originalBasePath:String, newBasePath:String?, index:Int?) -> AGFile
    {
        let osInterface = AGOSInterface()
        let originalUrl = osInterface.urlFromParts([originalBasePath, fileName])
        let isDir:Bool
        
        do {
            isDir = originalUrl == nil ? false : try osInterface.isDirectory(originalUrl!.absoluteString)
        } catch {
            isDir = false
        }
        
        let nameFormatter = AGNameFormatter(fileName: fileName, isDir: isDir)
        let newName = nameFormatter.makeClean()
        let format = self.getExtenstion(fileName)
    
        return AGFile(
            orginalName: fileName,
            newName: newName,
            originalBasePath: originalBasePath,
            newBasePath: newBasePath,
            format: format,
            index: index,
            originalUrl: originalUrl,
            isDir: isDir
        )
    }
    
    private func getName(fullPath:String) -> String?
    {
        let parts:[String] = fullPath.componentsSeparatedByString("/")
        if let name:String = parts.last {
            return name
        }
        
        return nil
    }
    
    private func getExtenstion(name:String) -> String?
    {
        let parts:[String] = name.componentsSeparatedByString(".")
        if parts.count > 1  {
            let format:String = parts.last!
            if self.formats.contains(format) {
                return format
            }
        }
        
        return nil
    }
}
