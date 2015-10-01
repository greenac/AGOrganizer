//
//  AGFileOrganizer.swift
//  Organizer
//
//  Created by Andre Green on 9/29/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public class AGFileOrganizer
{
    let moveToBasePath:String
    let moveFromBasePath:String
    let namesToExculde:Set<String> = [".DS_Store", "finished"]
    let names:AGNames
    var agFiles:[AGFile]
    let fileFormatter = AGFileFormatter()
    let osInterface = AGOSInterface()
    
    init(moveToBasePath:String, moveFromBasePath:String, sourceDirs:[String]?)
    {
        self.moveToBasePath = moveToBasePath
        self.moveFromBasePath = moveFromBasePath
        self.names = AGNames(sourceDirectories: sourceDirs)
        self.agFiles = [AGFile]()
    }

    public func organize() throws
    {
        do {
            try self.names.getNames()
            try self.getFilesForPaths("", fromBasePath: self.moveFromBasePath)
        } catch {
            print("Error: failed to orgainze files with from base path: \(self.moveFromBasePath)" +
                "and to base path: \(self.moveToBasePath)")
        }
    }
    
    private func getFilesForPaths(fileName: String, fromBasePath: String) throws
    {
        if self.namesToExculde.contains(fileName) {
            return
        }
        
        guard let fromPath:String = self.osInterface.urlStringFromParts([fromBasePath, fileName]) else {
            throw AGError.InvalidFilePath
        }
        
        if try self.osInterface.isDirectory(fromPath) {
            let files:[String] = try self.osInterface.filesForDirectory(fromPath)
            for file in files {
                try self.getFilesForPaths(file, fromBasePath: fromPath)
            }
        } else {
            if let parentDir = self.parentDirForFile(fileName),
                let toPath = self.osInterface.urlStringFromParts([self.moveToBasePath, parentDir]) {
                    let agFile:AGFile = self.fileFormatter.createFile(
                        fileName,
                        originalBasePath: fromPath,
                        newBasePath: toPath,
                        index: nil
                    )
                    
                    if agFile.isMovie() {
                        self.agFiles.append(agFile)
                    }
            }
        }
    }
    
    private func parentDirForFile(fileName:String) -> String? {
        var dirName:String?
        do {
            dirName = try self.names.nameForFile(fileName)
        } catch AGError.NoNameForFile {
            print("Error: no directory name for file: \(dirName)")
        } catch {
            print("Error: no directory name for file: \(dirName)")
        }
        
        return dirName
    }
}