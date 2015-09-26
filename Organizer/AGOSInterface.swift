//
//  AGOSInterface.swift
//  Organizer
//
//  Created by Andre Green on 9/23/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public struct AGOSInterface {
    private let fileManager:NSFileManager
    
    init() {
        self.fileManager = NSFileManager.defaultManager()
    }
    
    public func isDirectory(path:String) throws -> Bool {
        var isDir:ObjCBool = false
        if self.fileManager.fileExistsAtPath(path, isDirectory: &isDir) {
            return isDir.boolValue
        }
        
        throw AGError.InvalidFilePath
    }
    
    public func filesForDirectory(dirPath:String) throws -> [String] {
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
}