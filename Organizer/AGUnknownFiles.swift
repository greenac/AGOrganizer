//
//  AGUnknownFiles.swift
//  Organizer
//
//  Created by Andre Green on 9/25/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public struct AGUnknownFiles {
    let sourceDirs:[String]
    let names:AGNames
    let targetDir: String
    
    init(sourceDirs:[String], targetDirectory:String) {
        self.sourceDirs = sourceDirs
        self.targetDir = targetDirectory
        self.names = AGNames(sourceDirectories: sourceDirs)
    }
    
    private func setup() -> Bool {
        var success = false
        do {
            try self.names.getNames()
            success = true
        }  catch AGError.InvalidFilePath {
            print("Error: could not get names one of the directoryies in: \(self.sourceDirs)")
        } catch {
            print("Error: failed with unknown error getting names from: \(self.sourceDirs)")
        }
        
        return success
    }
    
    public func getUnknownFiles() throws -> [String]? {
        let osInterface = AGOSInterface()
        var files:[String]?
    
        if try osInterface.isDirectory(self.targetDir) {
            files = try? osInterface.filesForDirectory(self.targetDir)
        }
    
        if files != nil {
            let unknownFiles = try self.filesNotInNames(files!)
            return unknownFiles
        }
        
        return nil
    }

    private func filesNotInNames(files:[String]) throws -> [String] {
        try self.names.getNames()
        var unknownFiles = [String]()
        for file in files {
            let lowercaseFile = file.lowercaseString
            var isUnknownFile = true
            for name in self.names.names {
                if (lowercaseFile.rangeOfString(name.firstName!) != nil &&
                    name.lastName != nil &&
                    lowercaseFile.rangeOfString(name.lastName!) != nil) {
                        isUnknownFile = false
                        break
                }
            }
            
            if isUnknownFile {
                unknownFiles.append(file)
            }
        }
        
        return unknownFiles
    }
}