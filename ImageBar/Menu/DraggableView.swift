//
//  DraggableView.swift
//  ImageBar
//
//  Created by Dhruva Kumar on 6/21/25.
//

import SwiftUI

// from https://github.com/localsend/localsend/issues/1615
class DraggableView: NSView {
    
    private let appViewModel: AppViewModel
    
    init(frame frameRect: NSRect, viewModel: AppViewModel) {
        self.appViewModel = viewModel
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL, NSPasteboard.PasteboardType.URL, NSPasteboard.PasteboardType.string])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    // https://developer.apple.com/documentation/appkit/nsdraggingdestination
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            appViewModel.process(files: urls)
            return true
        }
        return false
    }
}
