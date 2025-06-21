//
//  ImageConverterApp.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/20/25.
//

import SwiftUI

@main
struct ImageConverterApp: App {
    
    
    
    var body: some Scene {
        MenuBarExtra(
            "Image Converter",
            systemImage: "photo.on.rectangle"
        ) {
            
            ImageConverterView()
                
            

        }
    }
}
