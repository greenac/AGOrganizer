//
//  NameFormatter.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public struct AGNameFormatter
{
    let fileName:String
    let charsToReplace:Set<String> = ["-", " ", "|", "(", ")", "^", ".", "<", ">", "@", "#", ",", "&", "[", "]"]
    let replacementChar:Character = "_"
    let isDir: Bool
    
    init(fileName:String, isDir:Bool)
    {
        self.fileName = fileName.lowercaseString
        self.isDir = isDir
    }
    
    public func makeClean() -> String?
    {
        var ext:String
        var fileName:String
        if self.isDir {
            ext = ""
            fileName = self.fileName
        } else {
            var parts = self.fileName.componentsSeparatedByString(".")
            if parts.count <= 1 {
                return nil
            }
            ext = parts.popLast()!
            fileName = parts.joinWithSeparator("")
        }
        
        let fileChars:[Character] = Array(fileName.characters)
        var newFileNameArray = [String]()
        for (index, char) in fileChars.enumerate() {
            if self.charsToReplace.contains(String(char)) {
                if index != 0 && index != fileChars.count - 1 && newFileNameArray.count > 0 {
                    let previousChar = Character(newFileNameArray.last!)
                    if previousChar != self.replacementChar {
                        newFileNameArray.append(String(self.replacementChar))
                    }
                }
            } else if char == self.replacementChar {
                if index != 0 {
                    let previousChar = fileChars[index - 1]
                    if previousChar != self.replacementChar {
                        newFileNameArray.append(String(char))
                    }
                }
            } else {
                newFileNameArray.append(String(char))
            }
        }
        
        let newName = newFileNameArray.joinWithSeparator("")
        return isDir ? newName : newName + "." + ext
    }
}
