//
//  AGWindowController.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Cocoa

class AGWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        self.test3()
    }
    
    override var windowNibName:String? {
        return "AGWindowController"
    }
    
    func test1() {
        let basePath = "/Users/agreen/Desktop/t1"
        let newBasePath = "/Users/agreen/Desktop/t2"
        let fileFormatter = AGFileFormatter()
        let osInterface = AGOSInterface()
        do {
            let dirs = try osInterface.filesForDirectory(basePath)
            for dir in dirs {
                if let orginalDirPath = fileFormatter.urlString([basePath, dir]),
                let newDirPath = fileFormatter.urlString([newBasePath, dir]){
                    let files = try osInterface.filesForDirectory(orginalDirPath)
                    for file in files {
                        let file = try fileFormatter.createFile(
                            file,
                            originalBasePath: orginalDirPath,
                            newBasePath: newDirPath
                        )
                        print("created file: \(file!.description())")
                    }
                } else {
                    throw AGError.InvalidFilePath
                }
            }
        } catch AGError.FileHasNoFormat {
            print("Error: file has no format")
        } catch AGError.FileFormatNotSupported {
            print("Error: file format not supported")
        } catch AGError.InvalidFileParameter {
            print("Error: invalid file parameter")
        } catch AGError.InvalidFilePath {
            print("Error: invalid file path")
        } catch {
            print("Error: unknown error occured")
        }
    }
    
    func test2() {
        let basePath = "/Users/agreen/Desktop/t1/capri_cavanni"
        let newBasePath = "/Users/agreen/Desktop/t2/capri_cavanni"
        let fileFormatter = AGFileFormatter()
        let osInterface = AGOSInterface()
        do {
            let files = try osInterface.filesForDirectory(basePath)
            for file in files {
                let file = try fileFormatter.createFile(
                    file,
                    originalBasePath: basePath,
                    newBasePath: newBasePath
                )
                print("created file: \(file!.description())")
            }
        } catch AGError.FileHasNoFormat {
            print("Error: file has no format")
        } catch AGError.FileFormatNotSupported {
            print("Error: file format not supported")
        } catch AGError.InvalidFileParameter {
            print("Error: invalid file parameter")
        } catch AGError.InvalidFilePath {
            print("Error: invalid file path")
        } catch {
            print("Error: unknown error occured")
        }
    }
    
    func test3() {
        let sourceDirs = [
            "/Volumes/Charlie/.p",
            "/Volumes/Charlie/.p/finished",
            "/Volumes/Echo/.p",
            "/Volumes/Echo/.p/finished"
        ]
        let target = "/Users/agreen/.stage/finished"
        let unknown = AGUnknownFiles(sourceDirs: sourceDirs, targetDirectory: target)
        do {
            try unknown.getUnknownFiles()
        } catch {
            print("Error: getting files")
        }
        
    }
}
