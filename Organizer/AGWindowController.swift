//
//  AGWindowController.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Cocoa

class AGWindowController: NSWindowController
{
    @IBOutlet weak var tableView: NSTableView!
    
    var unknownDataSourceAndDelegate:AGUnknownDataSourceAndDelegate?
    
    override var windowNibName:String? {
        return "AGWindowController"
    }
    
    
    override init(window: NSWindow?)
    {
        super.init(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func windowDidLoad()
    {
        super.windowDidLoad()
        if let files = self.test3() {
            self.unknownDataSourceAndDelegate = AGUnknownDataSourceAndDelegate(tableView: self.tableView, files: files)
            self.tableView.reloadData()
        }
        
        self.test4()
    }

    func test1()
    {
        let basePath = "/Users/agreen/Desktop/t1"
        let newBasePath = "/Users/agreen/Desktop/t2"
        let fileFormatter = AGFileFormatter()
        let osInterface = AGOSInterface()
        do {
            let dirs = try osInterface.filesForDirectory(basePath)
            for dir in dirs {
                if let orginalDirPath = osInterface.urlStringFromParts([basePath, dir]),
                let newDirPath = osInterface.urlStringFromParts([newBasePath, dir]) {
                    let files = try osInterface.filesForDirectory(orginalDirPath)
                    for (index, file) in files.enumerate() {
                        let file = fileFormatter.createFile(
                            file,
                            originalBasePath: orginalDirPath,
                            newBasePath: newDirPath,
                            index: index
                        )
                        print("created file: \(file.description())")
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
    
    func test2()
    {
        let basePath = "/Users/agreen/Desktop/t1/capri_cavanni"
        let newBasePath = "/Users/agreen/Desktop/t2/capri_cavanni"
        let fileFormatter = AGFileFormatter()
        let osInterface = AGOSInterface()
        do {
            let files = try osInterface.filesForDirectory(basePath)
            for (index, file) in files.enumerate() {
                let file = fileFormatter.createFile(
                    file,
                    originalBasePath: basePath,
                    newBasePath: newBasePath,
                    index: index
                )
                print("created file: \(file.description())")
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
    
    func test3() -> [AGFile]?
    {
//        let sourceDirs = [
//            "/Volumes/Charlie/.p",
//            "/Volumes/Charlie/.p/finished",
//            "/Volumes/Echo/.p",
//            "/Volumes/Echo/.p/finished",
//            "/Users/agreen/.stage/finished/organized"
//        ]
        
        
        let target = "/Users/agreen/.stage"
        let unknown = AGUnknownFiles(sourceDirs: nil, targetDirectory: target)
        do {
            let unknownFiles = try unknown.getUnknownFiles()
            for unknownFile in unknownFiles {
                print("File: \(unknownFile.originalName)")
            }
            unknown.saveNames()
            return unknownFiles
        } catch {
            print("Error: getting files")
        }
        
        return nil
    }
    
    func test4() {
        let fileOrganizer = AGFileOrganizer(
            moveToBasePath: "/Users/agreen/Desktop/t1",
            moveFromBasePath: "/Users/agreen/.stage/finished",
            sourceDirs: nil
        )
        do {
            try fileOrganizer.organize()
            for file in fileOrganizer.agFiles {
                print("\(file.description())")
            }
        } catch {
            print("Error: in file organizer's organize method")
        }
    }
}
