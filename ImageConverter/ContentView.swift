//
//  ContentView.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/20/25.
//

import SwiftUI

struct ContentView: View {
    @State private var textInput: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Add your text below:")
                .foregroundStyle(.secondary)
            TextEditor(text: $textInput)
                .padding(.vertical, 4)
                .scrollContentBackground(.hidden)
                .background(.thinMaterial)
            Button(
                "Copy uppercased result",
                systemImage: "square.on.square"
            ) {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(
                    textInput.uppercased(),
                    forType: .string
                )
            }
            .buttonStyle(.plain)
            .foregroundStyle(.blue)
            .bold()
        }
        .padding()
        .onDrop(of: ["public.heic", "public.jpeg", "public.png"], isTargeted: nil) { providers in
            // Accept the drop, but do nothing with the files yet
            return true
        }
    }
}

#Preview {
    ContentView()
}
