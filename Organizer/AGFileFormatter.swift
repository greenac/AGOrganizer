//
//  File.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public enum AGFileFormatterParam:String {
    case OriginalName = "OriginalName"
    case OriginalBasePath = "OriginalPath"
    case Format = "format"
    case NewBasePath = "NewBasePath"
    case NewName = "NewName"
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
    
    public func createFile(fileName:String, originalBasePath:String, newBasePath:String) throws -> AGFile? {
        let params:[AGFileFormatterParam:String] = try self.getFileParamters(
            fileName,
            originalBasePath: originalBasePath,
            newBasePath: newBasePath
        )
        
        let file:AGFile = AGFile(
            orginalName: params[AGFileFormatterParam.OriginalName]!,
            newName: params[AGFileFormatterParam.NewName]!,
            originalBasePath: params[AGFileFormatterParam.OriginalBasePath]!,
            newBasePath: params[AGFileFormatterParam.NewBasePath]!,
            format: params[AGFileFormatterParam.Format]!
        )
        
        return file
    }
    
    private func getFileParamters(fileName:String, originalBasePath:String, newBasePath:String) throws -> [AGFileFormatterParam:String] {
        let nameFormatter = AGNameFormatter(fileName: fileName)
        let newName = try nameFormatter.makeClean()
        
        if let format:String? = try self.getExtenstion(fileName) {
            let params = [
                AGFileFormatterParam.OriginalName: fileName,
                AGFileFormatterParam.OriginalBasePath: originalBasePath,
                AGFileFormatterParam.NewBasePath: newBasePath,
                AGFileFormatterParam.NewName: newName,
                AGFileFormatterParam.Format: format!
            ]
            
            return params
        }
        
        throw AGError.FileHasNoFormat
    }
    
    private func getName(fullPath:String) -> String? {
        let parts:[String] = fullPath.componentsSeparatedByString("/")
        if let name:String = parts.last {
            return name
        }
        
        return nil
    }
    
    private func getExtenstion(name:String) throws -> String {
        let parts:[String] = name.componentsSeparatedByString(".")
        if parts.count > 1  {
            let format:String = parts.last!
            if self.formats.contains(format) {
                return format
            }
        }
        
        throw AGError.FileFormatNotSupported
    }
    
    public func urlString(parts:[String]) -> String? {
        if parts.count == 0 {
            return nil
        }
        
        var urlString = ""
        do {
            for (index, part) in parts.enumerate() {
                let lastChar = part.characters.count - 1
                let hasChar = try part.hasCharacterAtIndex("/", index: lastChar)
                urlString += part
                if index != parts.count - 1 && !hasChar {
                    urlString += "/"
                }
                
                print("url after adding \(part) is \(urlString)")
            }
        } catch AGError.IndexOutOfBounds {
            print("Index is out of range")
        } catch {
            print("unknown error occured")
        }
        
        return urlString
    }
}
