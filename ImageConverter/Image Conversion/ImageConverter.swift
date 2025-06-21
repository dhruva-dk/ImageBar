// ImageConverter.swift

import Foundation
import ImageIO // <-- Use the Image I/O framework
import AppKit // For NSImage, though it's used less

struct ImageConverter {
    static func convert(
        file: URL,
        maxDimension: Int,
        format: ImageFormat
    ) throws -> Data {
        
        // 1. Create an Image Source from the file URL.
        // This is memory-efficient as it doesn't load the whole image yet.
        guard let imageSource = CGImageSourceCreateWithURL(file as CFURL, nil) else {
            throw ImageConversionError.invalidImageFile(file.lastPathComponent)
        }
        
        // 2. Define the resizing options in a dictionary.
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ]
        
        // 3. Create a resized thumbnail. Image I/O handles the resizing internally and efficiently.
        guard let resizedImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            throw ImageConversionError.resizeFailed(file.lastPathComponent)
        }
        
        // 4. Prepare to write the output data.
        let outputData = NSMutableData()
        guard let imageDestination = CGImageDestinationCreateWithData(outputData, format.uti, 1, nil) else {
            throw ImageConversionError.dataRepresentationFailed(file.lastPathComponent)
        }
        
        // 5. Add the resized image to the destination, providing format-specific properties.
        CGImageDestinationAddImage(imageDestination, resizedImage, format.properties as CFDictionary)
        
        // 6. Finalize the conversion and write the data.
        guard CGImageDestinationFinalize(imageDestination) else {
            throw ImageConversionError.dataRepresentationFailed(file.lastPathComponent)
        }
        
        return outputData as Data
    }
}

// You can now delete your NSImage+Extensions.swift file as this
// new implementation no longer uses those methods.
