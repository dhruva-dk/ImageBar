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
            "Menu Bar Example",
            systemImage: "photo.on.rectangle"
        ) {
            ContentView()
                .overlay(alignment: .topTrailing) {
                    Button(
                        "Quit",
                        systemImage: "xmark.circle.fill"
                    ) {
                        NSApp.terminate(nil)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.plain)
                    .padding(6)
                }
                .frame(width: 300, height: 180)
        }
            .menuBarExtraStyle(.window)
        }
}
