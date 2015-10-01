//
//  AGStringExtension.swift
//  Organizer
//
//  Created by Andre Green on 9/23/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

extension String {
    func hasCharacterAtIndex(character:Character, index:Int) throws -> Bool
    {
        let characters = Array(self.characters)
        if characters.count == 0 {
            return false;
        }
        
        if index >= characters.count {
            throw AGError.IndexOutOfBounds
        }
        
        return characters[index] == character
    }
}