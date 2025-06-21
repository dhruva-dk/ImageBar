//
//  AppDelegate.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/21/25.
//


import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func configure(statusItem: NSStatusItem?, with controller: AppController) {
        guard let button = statusItem?.button else { return }
        
        let dragView = DraggableView(frame: button.bounds)
        button.addSubview(dragView)
        dragView.controller = controller
        
        dragView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dragView.topAnchor.constraint(equalTo: button.topAnchor),
            dragView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            dragView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
            dragView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])
    }
}

class DraggableView: NSView {
    var controller: AppController?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        registerForDraggedTypes([.fileURL])
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let pasteboard = sender.draggingPasteboard
        
        if let urls = pasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [URL] {
            controller?.droppedFilesSubject.send(urls)
            return true
        }
        return false
    }
}