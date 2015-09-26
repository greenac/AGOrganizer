//
//  AGErrors.swift
//  Organizer
//
//  Created by Andre Green on 9/22/15.
//  Copyright © 2015 Andre Green. All rights reserved.
//

import Foundation

enum AGError: ErrorType {
    case InvalidFilePath
    case FileFormatNotSupported
    case PathNotADirectory
    case FileHasNoFormat
    case InvalidFileParameter
    case IndexOutOfBounds
    case FailedToCreateFile
    case InvalidName
}