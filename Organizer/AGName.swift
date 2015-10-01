//
//  AGName.swift
//  Organizer
//
//  Created by Andre Green on 9/25/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

public enum AGNameParams: String
{
    case FirstName = "FirstName"
    case LastName = "LastName"
}

public struct AGName
{
    let rawName:String
    let firstName:String?
    let lastName:String?
    
    init(dirName:String) throws
    {
        self.rawName = dirName
        let names = try parseNames(dirName)
        self.firstName = names[AGNameParams.FirstName]!
        self.lastName = names[AGNameParams.LastName]!
    }
    
    public func fullName() -> String?
    {
        var name = ""
        if self.firstName == nil {
            return nil
        } else {
            name += self.firstName!
        }
        
        if self.lastName != nil {
            name += " " + self.lastName!
        }
        
        return name
    }
    
    public func fullNameWithUnderscore() -> String?
    {
        if let fullName = self.fullName() {
            let parts = fullName.componentsSeparatedByString(" ")
            if parts.count == 1 {
                return parts[0]
            }
            
            return parts[0] + "_" + parts[1]
        }
        
        return nil
    }
    
    public func containedIn(input:String, checkFirstOnly:Bool) -> Bool
    {
        if self.firstName == nil {
            return false
        }
        
        let lowercaseInput = input.lowercaseString
        
        let hasFirstName = lowercaseInput.rangeOfString(self.firstName!) != nil
        if checkFirstOnly || self.lastName == nil {
            return hasFirstName
        } else if hasFirstName == false {
            return false
        }
        
        return lowercaseInput.rangeOfString(self.lastName!) != nil
    }
}

private func parseNames(rawName:String) throws -> [AGNameParams: String?]
{
    let parts = rawName.componentsSeparatedByString("_")
    if parts.count == 0 {
        throw AGError.InvalidName
    }
    
    let firstName = parts[0]
    let lastName:String? = parts.count > 1 ? parts[1] : nil
    let names = [
        AGNameParams.FirstName: firstName,
        AGNameParams.LastName: lastName
    ]
    
    return names
}