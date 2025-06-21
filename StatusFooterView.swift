import SwiftUI

struct StatusFooterView: View {
    let status: Status
    let onDismiss: () -> Void
    
    var body: some View {
        // Use a ZStack to create the placard background behind the content.
        ZStack(alignment: .leading) { // Set alignment to .leading for the ZStack itself
            
            // 1. THE PLACARD BACKGROUND: A subtle shape that gives the area presence.
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.primary.opacity(0.05))
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)

            // The content to display
            HStack {
                // 2. THE CONTENT SWITCH: We now ensure every case provides left-aligned content.
                switch status {
                case .idle:
                    // We add a subtle icon for better visual balance.
                    Image(systemName: "arrow.right.doc.on.clipboard")
                    Text("Drag images to the menu bar icon to convert.")
                        
                    
                    
                case .processing:
                    ProgressView().scaleEffect(0.5)
                    Text("Processing...")
                    
                    
                case .failure(let message):
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red) // Color the icon specifically
                    
                    Text(message)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    
                    Spacer() // Push content to the left
                    
                    Button(action: onDismiss) { // The action is defined directly
                        Image(systemName: "xmark")
                            .padding(4)
                            // Note: The background is applied to the Image inside the button's label
                            .background(Color.secondary.opacity(0.2), in: Circle())
                    }
                    .buttonStyle(.plain) // Use .plain to remove most of the default button chrome
                    .contentShape(Circle()) // Define the hit area
                    
                    
                
                    // In StatusFooterView.swift -> switch status { ... }

                    case .success(let message, let outputURL):
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            
                            
                            // Pushes the buttons to the right
                            
                            Button(action: {
                                NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: outputURL.path)
                            }) {
                                Text(message + " Click to show.")
                                    .underline()
                            }
                            .buttonStyle(.plain)


                            
                            Spacer()
      
                            Button(action: onDismiss) { // The action is defined directly
                                Image(systemName: "xmark")
                                    .padding(4)
                                    // Note: The background is applied to the Image inside the button's label
                                    .background(Color.secondary.opacity(0.2), in: Circle())
                            }
                            .buttonStyle(.plain) // Use .plain to remove most of the default button chrome
                            .contentShape(Circle()) // Define the hit area
                        }
                }
                
                
                

            }
            .padding(.horizontal, 10)
        }
        .font(.footnote) // Use .footnote instead of .caption for better readability
        .foregroundColor(.secondary)
        .frame(height: 38) // Give it a slightly taller, more stable height
        .animation(.easeInOut(duration: 0.2), value: status)
    }
}

