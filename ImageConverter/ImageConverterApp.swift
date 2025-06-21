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
                .introspectMenuBarExtraWindow { window in // <-- the magic ✨

                }

        }

        .menuBarExtraAccess(isPresented: $isMenuPresented) { statusItem in // <-- the magic ✨
             // access status item or store it in a @State var
            // MARK: - This is where the magic happens
                        


                        if let button = statusItem.button {
                            let dragView = DraggableView(frame: button.bounds)
                            button.addSubview(dragView)
                            
                            // Use Auto Layout to make our DraggableView cover the entire button.
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

// from https://github.com/localsend/localsend/issues/1615
class DraggableView: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL, NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.string])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            for url in urls {
                print(url.path)
            }
            return true
        }
        
        if let strings = pasteboard.readObjects(forClasses: [NSString.self], options: nil) as? [String] {
            for string in strings {
                print(string)
            }
            return true
        }
        
        return false
    }
}
