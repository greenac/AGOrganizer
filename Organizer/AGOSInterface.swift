//
//  AGOSInterface.swift
//  Organizer
//
//  Created by Andre Green on 9/23/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public struct AGOSInterface
{
    private let fileManager:NSFileManager
    private let namesFile = "names.json"
    
    init()
    {
        self.fileManager = NSFileManager.defaultManager()
        
    }
    
    public func isDirectory(path:String) throws -> Bool
    {
        var isDir:ObjCBool = false
        if self.fileManager.fileExistsAtPath(path, isDirectory: &isDir) {
            return isDir.boolValue
        }
        
        throw AGError.InvalidFilePath
    }
    
    public func filesForDirectory(dirPath:String) throws -> [String]
    {
        do {
            if try self.isDirectory(dirPath) {
                let files = try self.fileManager.contentsOfDirectoryAtPath(dirPath)
                return files
            } else {
                throw AGError.PathNotADirectory
            }
        } catch AGError.InvalidFilePath {
            throw AGError.InvalidFilePath
        } catch AGError.PathNotADirectory {
            throw AGError.PathNotADirectory
        }
    }
    
    public func urlStringFromParts(parts:[String]) -> String?
    {
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
            }
        } catch AGError.IndexOutOfBounds {
            print("Index is out of range")
        } catch {
            print("unknown error occured")
        }
        
        return urlString
    }
    
    public func urlFromParts(parts:[String]) -> NSURL?
    {
        if let urlString = self.urlStringFromParts(parts) {
            if let url = NSURL(string: urlString) {
                return url
            }
        }
        
        return nil
    }
    
    public func saveNamesToFile(namesArray:[String]) throws
    {
        let jsonData = try NSJSONSerialization.dataWithJSONObject(namesArray, options: NSJSONWritingOptions.PrettyPrinted)
        guard let path = self.namesFilePath() else {
            throw AGError.InvalidFilePath
        }
        
        self.fileManager.createFileAtPath(path, contents: jsonData, attributes: nil)
    }
    
    public func getNamesFromFile() -> [String]?
    {
        if let filePath = self.namesFilePath() {
            do {
                let jsonData = try NSData(contentsOfFile:filePath, options: NSDataReadingOptions.DataReadingMapped)
                if let namesJson:[String] = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as? [String] {
                    return namesJson
                }
            } catch {
                print("Error: failed to read names from file")
            }
        }
        
        return nil
    }
    
    private func namesFilePath() -> String?
    {
        return self.urlStringFromParts([self.documentDirPath(), self.namesFile])
    }
    
    private func documentDirPath() -> String {
        let documentDirs = NSSearchPathForDirectoriesInDomains(
            NSSearchPathDirectory.ApplicationSupportDirectory,
            NSSearchPathDomainMask.UserDomainMask,
            true
        )
        
        return documentDirs.first!
    }
    
}