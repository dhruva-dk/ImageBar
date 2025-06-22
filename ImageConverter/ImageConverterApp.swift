import SwiftUI
import MenuBarExtraAccess


@main
struct ImageConverterApp: App {
    @StateObject private var appViewModel = AppViewModel()
    @State var isMenuPresented: Bool = false
    

    var body: some Scene {
        MenuBarExtra("Image Converter", systemImage: "photo.on.rectangle") {
            AppMenu()
                .environmentObject(appViewModel)

        }
        .menuBarExtraStyle(.window)
        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in // <-- the magic ✨
             // access status item or store it in a @State var
            // MARK: - This is where the magic happens
                        


                        if let button = statusItem.button {
                            let dragView = DraggableView(frame: button.bounds, viewModel: appViewModel)
                            button.addSubview(dragView)
                            
                            // Use Auto Layout to make our DraggableView cover the entire button.
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

