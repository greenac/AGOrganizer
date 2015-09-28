//
//  AGFile.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public class AGFile
{
    let originalBasePath:   String
    var newBasePath:        String?
    var cleanName:          String?
    let originalName:       String
    var newName:            String?
    let format:             String?
    let originalUrl:        NSURL?
    var newUrl:             NSURL?
    var index:              Int?
    let date:               NSDate
    let isDir:              Bool
    
    init(orginalName:String,
        newName:String?,
        originalBasePath:String,
        newBasePath:String?,
        format:String?,
        index:Int?,
        originalUrl:NSURL?,
        isDir:Bool
        )
    {
        // TODO -- Add error handling for orginalUrl and newUrl
        self.originalName = orginalName
        self.newName = newName
        self.originalBasePath = originalBasePath
        self.originalUrl = originalUrl
        self.newBasePath = newBasePath
        self.date = NSDate()
        self.format = format
        self.index = index
        self.isDir = isDir
        
        if self.newBasePath != nil && self.newName != nil {
            self.newUrl = NSURL(string: self.newName!, relativeToURL: NSURL(string: self.newBasePath!))
        }
    }
    
    public func lowerCaseOriginalName() -> String
    {
        return self.originalName.lowercaseString
    }
    
    public func lowerCaseOriginalPath() -> String?
    {
        if let path = self.fullOriginalPath() {
            return path.lowercaseString
        }
        
        return nil
    }
    
    public func fullOriginalPath() -> String?
    {
        return self.originalUrl?.absoluteString
    }
    
    public func fullNewPath() -> String?
    {
        return self.newUrl?.absoluteString
    }
    
    public func description() -> String
    {
        var message = ""
        if let originalPath = fullOriginalPath() {
            message += "orginal file path \(originalPath)"
        }
        
        if let newPath = self.fullNewPath() {
            message += " new file path: \(newPath)"
        }
        
        if self.cleanName != nil {
            message += " cleaned name: \(self.cleanName!)"
        }
        
        if self.index != nil {
            message += " index: \(self.index!)"
        }
        
        message += " directory: " + (isDir ? "Yes": "NO")
        
        return message
    }
}