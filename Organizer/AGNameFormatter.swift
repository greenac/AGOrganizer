//
//  NameFormatter.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public struct AGNameFormatter {
    let fileName:String
    let charsToReplace:Set<String> = ["-", " ", "|", "(", ")", "^", ".", "<", ">", "@", "#", ",", "&"]
    
    init(fileName:String) {
        self.fileName = fileName.lowercaseString
    }
    
    public func makeClean() throws -> String {
        var parts = self.fileName.componentsSeparatedByString(".")
        if parts.count <= 1 {
            throw AGError.FileFormatNotSupported
        }
        
        let ext:String = parts.popLast()!
        let fileName = parts.joinWithSeparator("")
        let fileChars:[Character] = Array(fileName.characters)
        var newFileName = ""
        for char in fileChars {
            if self.charsToReplace.contains(String(char)) {
                newFileName += "_"
            } else {
                newFileName += String(char)
            }
        }
        
        return newFileName + "." + ext
    }
    
    
}
