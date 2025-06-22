//
//  StatusFooterView.swift
//  ImageBar
//
//  Created by Dhruva Kumar on 6/21/25.
//

import SwiftUI

struct StatusFooterView: View {
    let status: Status
    let onDismiss: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.primary.opacity(0.05))
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            HStack {
                switch status {
                case .idle:
                    Image(systemName: "arrow.right.doc.on.clipboard")
                    Text("Drag images to the menu bar icon to convert.")
                case .processing:
                    ProgressView().scaleEffect(0.5)
                    Text("Processing...")
                case .failure(let message):
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(message)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    Spacer()
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .padding(4)
                            .background(Color.secondary.opacity(0.2), in: Circle())
                    }
                    .buttonStyle(.plain)
                    .contentShape(Circle())
                case .success(let message, let outputURL):
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Button(action: {
                            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: outputURL.path)
                        }) {
                            Text(message + " Click to show.")
                                .underline()
                        }
                        .buttonStyle(.plain)
                        Spacer()
                        Button(action: onDismiss) {
                            Image(systemName: "xmark")
                                .padding(4)
                                .background(Color.secondary.opacity(0.2), in: Circle())
                        }
                        .buttonStyle(.plain)
                        .contentShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 10)
        }
        .font(.footnote)
        .foregroundColor(.secondary)
        .frame(height: 44)
        .animation(.easeInOut(duration: 0.15), value: status)
    }
}
