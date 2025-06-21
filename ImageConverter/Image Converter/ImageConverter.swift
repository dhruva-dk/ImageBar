// ImageConverter.swift
import Foundation
import AppKit

struct ImageConverter {
    static func convert(
        file: URL,
        maxDimension: Int,
        format: ImageFormat
    ) throws -> Data {
        
        let filename = file.lastPathComponent
        
        guard let nsImage = NSImage(contentsOf: file) else {
            throw ImageConversionError.invalidImageFile(filename)
        }
        
        guard let imageRep = nsImage.representations.first as? NSBitmapImageRep else {
            throw ImageConversionError.invalidImageFile(filename)
        }
        let originalPixelSize = NSSize(width: imageRep.pixelsWide, height: imageRep.pixelsHigh)
        
        let newPixelSize = calculateNewSize(for: originalPixelSize, maxDimension: maxDimension)
        
        let resizedImage = try nsImage.resized(toPixels: newPixelSize)
        
        let outputData = try resizedImage.data(for: format)
        
        return outputData
    }
    
    private static func calculateNewSize(for originalSize: NSSize, maxDimension: Int) -> NSSize {
        let max = CGFloat(maxDimension)
        if originalSize.width <= max && originalSize.height <= max {
            return originalSize
        }
        
        if originalSize.width > originalSize.height {
            let newWidth = max
            let newHeight = (originalSize.height / originalSize.width) * newWidth
            return NSSize(width: newWidth, height: newHeight)
        } else {
            let newHeight = max
            let newWidth = (originalSize.width / originalSize.height) * newHeight
            return NSSize(width: newWidth, height: newHeight)
        }
    }
}
