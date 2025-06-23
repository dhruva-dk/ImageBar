//
//  ImageBarApp.swift
//  ImageBar
//
//  Created by Dhruva Kumar on 6/21/25.
//

import SwiftUI
import MenuBarExtraAccess

@main
struct ImageBarApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @State var isMenuPresented: Bool = false

    var body: some Scene {
        MenuBarExtra("Image Converter", systemImage: "photo.on.rectangle.angled") {
            AppMenu()
                .environmentObject(appViewModel)
        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in
            if let button = statusItem.button {
                let dragView = DraggableView(frame: button.bounds, viewModel: appViewModel)
                button.addSubview(dragView)
                // from https://github.com/localsend/localsend/issues/1615
                // See DraggableView.swift
                dragView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    dragView.topAnchor.constraint(equalTo: button.topAnchor),
                    dragView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                    dragView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                    dragView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
                ])
            }
        }
    }
}
