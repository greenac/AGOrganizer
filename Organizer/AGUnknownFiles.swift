//
//  AGUnknownFiles.swift
//  Organizer
//
//  Created by Andre Green on 9/25/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public struct AGUnknownFiles
{
    let names:AGNames
    let sourceDirs:[String]?
    let targetDir: String
    let filesToIgnore:Set<String> = [
        ".DS_Store",
        "torrents_finished",
        "torrents_in_progress",
        "finished",
        "organized"
    ]
    
    init(sourceDirs:[String]?, targetDirectory:String)
    {
        self.sourceDirs = sourceDirs
        self.targetDir = targetDirectory
        self.names = AGNames(sourceDirectories: sourceDirs)
    }
    
    private func setup() -> Bool
    {
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
    
    public func getUnknownFiles() throws -> [AGFile]
    {
        let osInterface = AGOSInterface()
        var files:[String]?
        var agFiles = [AGFile]()
        
        if try osInterface.isDirectory(self.targetDir) {
            let fileFormatter = AGFileFormatter()
            files = try? osInterface.filesForDirectory(self.targetDir)
            for (index, file) in files!.enumerate() where !self.filesToIgnore.contains(file) {
                let agFile = fileFormatter.createFile(
                    file,
                    originalBasePath: self.targetDir,
                    newBasePath: nil,
                    index: index
                )
                agFiles.append(agFile)
            }
        }
    
        let unknownFiles = try self.filesNotInNames(agFiles)
        return unknownFiles
    }

    private func filesNotInNames(files:[AGFile]) throws -> [AGFile]
    {
        try self.names.getNames()
        var unknownFiles = [AGFile]()
        for file in files {
            var isUnknownFile = true
            let fileName = file.lowerCaseOriginalName()
            for name in self.names.names {
                if (fileName.rangeOfString(name.firstName!) != nil &&
                    name.lastName != nil &&
                    fileName.rangeOfString(name.lastName!) != nil) {
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
    
    public func saveNames()
    {
        self.names.saveNames()
    }
}