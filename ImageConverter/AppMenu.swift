import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var appViewModel: AppViewModel

    // In AppMenu.swift

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            


            // --- Format & Quality Controls ---
            // We'll group the format picker and its dependent quality slider together.
            VStack(alignment: .leading, spacing: 8) {
                
                
                Picker("Output Format:", selection: $appViewModel.outputFormat) {
                    Text("JPEG").tag(0)
                    Text("PNG").tag(1)
                }
                .pickerStyle(.menu)

                // --- NEW: JPEG Quality Controls, mirroring the dimension controls ---
                VStack(alignment: .leading, spacing: 4) {
                    Text("JPEG Quality:")
                        .foregroundColor(appViewModel.outputFormat != 0 ? .secondary.opacity(0.5) : .primary) // Also fade the text when disabled
                    
                    HStack {
                        // This TextField is bound to the quality, displayed as a percentage (0-100).
                        // We use a custom Binding to convert the Double (0.0-1.0) to an Int for the text field.
                        TextField("", value: Binding(
                            get: { Int(appViewModel.jpegQuality * 100) },
                            set: { appViewModel.jpegQuality = Double($0) / 100.0 }
                        ), format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        
                        Slider(value: $appViewModel.jpegQuality, in: 0.1...1.0)
                    }
                }
                // THE KEY CHANGE: This entire block is disabled if the selected format is NOT JPEG (tag 0).
                .disabled(appViewModel.outputFormat != 0)
            }
            .disabled(appViewModel.status == .processing)
            
            Divider()
            
            
            // --- Dimension Controls ---
            VStack(alignment: .leading, spacing: 4) {
                Text("Maximum Output Dimension:")
                HStack {
                    TextField("", value: $appViewModel.outputSize, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Slider(value: Binding(
                        get: { Double(appViewModel.outputSize) },
                        set: { appViewModel.outputSize = Int($0) }
                    ), in: 16...4096)
                }
            }
            .disabled(appViewModel.status == .processing)



            Divider()

            // --- Status Footer ---
            StatusFooterView(status: appViewModel.status) {
                appViewModel.status = .idle
            }
        }
        .font(.system(size: 13))
        .padding(12)
        .frame(width: 330)
        // A subtle animation for the enabled/disabled state change of the quality slider
        .animation(.easeInOut(duration: 0.15), value: appViewModel.outputFormat)
    }
}
