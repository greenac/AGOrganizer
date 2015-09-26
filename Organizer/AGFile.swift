//
//  AGFile.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public class AGFile {
    let originalBasePath:String
    var newBasePath:String
    var cleanName:String?
    let originalName:String
    var newName:String
    let format:String
    let originalUrl:NSURL
    var newUrl:NSURL
    let date:NSDate
    
    init(orginalName:String, newName:String, originalBasePath:String, newBasePath:String, format:String) {
        // TODO -- Add error handling for orginalUrl and newUrl
        self.originalName = orginalName
        self.newName = newName
        self.originalBasePath = originalBasePath
        self.newBasePath = newBasePath
        self.originalUrl = NSURL(string: self.originalName, relativeToURL: NSURL(string: self.originalBasePath))!
        self.newUrl = NSURL(string: self.newName, relativeToURL: NSURL(string: self.newBasePath))!
        self.date = NSDate()
        self.format = format
    }
    
    convenience init(parameters: [AGFileFormatterParam:String]) {
        let orginalName = parameters[AGFileFormatterParam.OriginalName]!
        let newName = parameters[AGFileFormatterParam.NewName]!
        let originalBasePath = parameters[AGFileFormatterParam.OriginalBasePath]!
        let newBasePath = parameters[AGFileFormatterParam.NewBasePath]!
        let format = parameters[AGFileFormatterParam.Format]!
        self.init(
            orginalName: orginalName,
            newName: newName,
            originalBasePath: originalBasePath,
            newBasePath: newBasePath,
            format: format
        )
    }
    
    public func lowerCaseOriginalName() -> String {
        return self.originalName.lowercaseString
    }
    
    public func fullOriginalPath() -> String {
        return self.originalUrl.absoluteString
    }
    
    public func fullNewPath() -> String {
        return self.newUrl.absoluteString
    }
    
    public func description() -> String {
        return "orginal file path: \(self.fullOriginalPath()) new file path: \(self.fullNewPath())"
    }
}