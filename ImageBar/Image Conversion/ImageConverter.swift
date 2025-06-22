//
//  ImageBar.swift
//  ImageBar
//
//  Created by Dhruva Kumar on 6/21/25.
//

import Foundation
import ImageIO

struct ImageBar {
    static func convert(
        file: URL,
        maxDimension: Int,
        format: ImageFormat
    ) throws -> Data {
        
        guard let imageSource = CGImageSourceCreateWithURL(file as CFURL, nil) else {
            throw ImageConversionError.invalidImageFile(file.lastPathComponent)
        }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ]

        guard let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            throw ImageConversionError.resizeFailed(file.lastPathComponent)
        }

        let outputData = NSMutableData()
        guard let imageDestination = CGImageDestinationCreateWithData(outputData, format.uti, 1, nil) else {
            throw ImageConversionError.dataRepresentationFailed(file.lastPathComponent)
        }

        CGImageDestinationAddImage(imageDestination, resizedImage, format.properties as CFDictionary)

        guard CGImageDestinationFinalize(imageDestination) else {
            throw ImageConversionError.dataRepresentationFailed(file.lastPathComponent)
        }
        
        return outputData as Data
    }
}
