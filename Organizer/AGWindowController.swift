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

    }
    
    override var windowNibName:String? {
        return "AGWindowController"
    }
    
    func tests() {
        let fileManager = NSFileManager.defaultManager()
        let path = "/Users/agreen/Desktop/t1/capri_cavanni"
        var isDir:ObjCBool = false
        if fileManager.fileExistsAtPath(path, isDirectory: &isDir) {
            if isDir {
                do {
                    let fileFormatter:AGFileFormatter = AGFileFormatter()
                    let files:[String] = try fileManager.contentsOfDirectoryAtPath(path)
                    for file in files {
                        print("reading in file: \(file)")
                        let parameters = fileFormatter.getFileParamters(file)
                        let aFile:AGFile = AGFile(parameters: parameters)
                        print(aFile.description())
                    }
                } catch _{
                    print("error reading file")
                }
            } else {
                print("\(path) is not a directory")
            }
        } else {
            print("there is no file at \(path)")
        }
    }
}
