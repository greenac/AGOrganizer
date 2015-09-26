//
//  AGNames.swift
//  Organizer
//
//  Created by Andre Green on 9/25/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public class AGNames {
    let sourceDirs:[String]
    var names:[AGName]
    let namesToExclude: Set<String> = [".DS_Store"]
    init(sourceDirectories: [String]) {
        self.sourceDirs = sourceDirectories
        self.names = [AGName]()
    }
    
    public func getNames() throws {
        let osInterface = AGOSInterface()
        var names = Set<String>()
        for dir in self.sourceDirs {
            let dirNames = try osInterface.filesForDirectory(dir)
            for dirName in dirNames where !self.namesToExclude.contains(dirName) {
                do {
                    let name = try AGName(dirName: dirName)
                    if let fullName = name.fullName() where !names.contains(fullName) {
                        names.insert(fullName)
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
    
    public func readableNames() -> [String] {
        var names = [String]()
        for name in self.names {
            if let fullName = name.fullName() {
                names.append(fullName)
            }
        }
        
        return names
    }
}