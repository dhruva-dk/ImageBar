//
//  ImageConversionError.swift
//  ImageBar
//
//  Created by Dhruva Kumar on 6/21/25.
//

import Foundation

enum ImageConversionError: Error, LocalizedError {
    case invalidImageFile(String)
    case resizeFailed(String)
    case dataRepresentationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidImageFile(let filename):
            return "Could not read the file '\(filename)'. It may be corrupt or an unsupported format."
        case .resizeFailed(let filename):
            return "An internal error occurred while resizing '\(filename)'."
        case .dataRepresentationFailed(let filename):
            return "An internal error occurred while converting '\(filename)' to the target format."
        }
    }
}
