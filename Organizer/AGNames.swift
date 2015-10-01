//
//  AGNames.swift
//  Organizer
//
//  Created by Andre Green on 9/25/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public class AGNames
{
    let sourceDirs:[String]?
    var names:[AGName]
    var namesSet:Set<String>
    let namesToExclude: Set<String> = [".DS_Store"]
    init(sourceDirectories: [String]?) {
        self.sourceDirs = sourceDirectories
        self.names = []
        self.namesSet = []
    }
    
    public func getNames() throws
    {
        let osInterface = AGOSInterface()
        self.names.removeAll()
        self.namesSet.removeAll()
        
        if self.sourceDirs == nil {
            if let jsonNames = osInterface.getNamesFromFile() {
                for dirName in jsonNames {
                    do {
                        let name = try AGName(dirName: dirName)
                        if let fullName = name.fullName() where !self.namesSet.contains(fullName) {
                            self.namesSet.insert(fullName)
                            self.names.append(name)
                        }
                    } catch AGError.InvalidName {
                        print("Error: invalid name \(dirName)")
                    } catch {
                        print("Error: unknown error while making name from dir: \(dirName)")
                    }
                }
            }
        } else {
            for dir in self.sourceDirs! {
                let dirNames = try osInterface.filesForDirectory(dir)
                for dirName in dirNames where !self.namesToExclude.contains(dirName) {
                    do {
                        let name = try AGName(dirName: dirName)
                        if let fullName = name.fullName() where !self.namesSet.contains(fullName) {
                            self.namesSet.insert(fullName)
                            self.names.append(name)
                        }
                    } catch AGError.InvalidName {
                        print("Error: invalid name \(dirName)")
                    } catch {
                        print("Error: unknown error while making name from dir: \(dirName)")
                    }
                }
            }
        }
    }
    
    public func readableNames() -> [String]
    {
        var names = [String]()
        for name in self.names {
            if let fullName = name.fullName() {
                names.append(fullName)
            }
        }
        
        return names
    }
    
    public func saveNames()
    {
        var namesToSave = [String]()
        for name in self.names {
            if let fullName = name.fullNameWithUnderscore() {
                namesToSave.append(fullName)
            }
        }
        
        namesToSave.sortInPlace()
        
        let osInterface = AGOSInterface()
        do {
            try osInterface.saveNamesToFile(namesToSave)
        } catch {
            print("Error: could not save names to disk")
        }
    }
    
    public func nameForFile(fileName:String) throws -> String
    {
        var dirName:String?
        for name in self.names {
            if let underscoredName = name.fullNameWithUnderscore() where
                !self.namesToExclude.contains(underscoredName) &&
                    name.containedIn(fileName, checkFirstOnly: false) {
                dirName = underscoredName
                break
            }
        }
        
        if dirName == nil {
            throw AGError.NoNameForFile
        }
        
        return dirName!
    }
}