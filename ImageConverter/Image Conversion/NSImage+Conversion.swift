
import AppKit

extension NSImage {
    func resized(toPixels newPixelSize: NSSize) throws -> NSImage {
        guard let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(newPixelSize.width),
            pixelsHigh: Int(newPixelSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: .deviceRGB,
            bytesPerRow: 0,
            bitsPerPixel: 0
        ) else {
            throw ImageConversionError.resizeFailed(self.name() ?? "unknown")
        }
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
        
        self.draw(in: NSRect(origin: .zero, size: newPixelSize))
        
        NSGraphicsContext.restoreGraphicsState()
        
        let newImage = NSImage(size: newPixelSize)
        newImage.addRepresentation(rep)
        return newImage
    }
    
    func data(for format: ImageFormat) throws -> Data {
        guard let tiffRepresentation = self.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            let imageName = self.name() ?? "unknown file"
            throw ImageConversionError.dataRepresentationFailed(imageName)
        }
        
        let properties: [NSBitmapImageRep.PropertyKey : Any]
        let imageType: NSBitmapImageRep.FileType
        
        switch format {
        case .jpeg(let quality):
            imageType = .jpeg
            properties = [.compressionFactor: quality]
        case .png:
            imageType = .png
            properties = [:]
        }
        
        guard let outputData = bitmapImage.representation(using: imageType, properties: properties) else {
            let imageName = self.name() ?? "unknown file"
            throw ImageConversionError.dataRepresentationFailed(imageName)
        }
        
        return outputData
    }
}
