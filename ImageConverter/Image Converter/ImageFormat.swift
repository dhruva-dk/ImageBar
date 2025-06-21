
import Foundation

enum ImageFormat {
    case jpeg(quality: Double)
    case png
    
    var fileExtension: String {
        switch self {
        case .jpeg: "jpg"
        case .png: "png"
        }
    }
}
