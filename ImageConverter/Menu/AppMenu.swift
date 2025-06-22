import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var appViewModel: AppViewModel

    // In AppMenu.swift

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            

                Picker("Output Format:", selection: $appViewModel.outputFormat) {
                    Text("JPEG").tag(0)
                    Text("PNG").tag(1)
                    Text("HEIC").tag(2)
                    Text("TIFF").tag(3)
                }
                .pickerStyle(.menu)
                .disabled(appViewModel.status == .processing) // Disable during processing

                
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Quality (JPEG & HEIC Only):")
                    
                    HStack {

                        TextField("", value: Binding(
                            get: { Int(appViewModel.quality * 100) },
                            set: { appViewModel.quality = Double($0) / 100.0 }
                        ), format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                        
                        Slider(value: $appViewModel.quality, in: 0.1...1.0)
                    }
                }
                .disabled((appViewModel.outputFormat != 0 && appViewModel.outputFormat != 2) || appViewModel.status == .processing) // Disable if not JPEG or HEIC or if processing


            

            
            
            // --- Dimension Controls ---
            VStack(alignment: .leading, spacing: 8) {
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



 

            // --- Status Footer ---
            StatusFooterView(status: appViewModel.status) {
                appViewModel.status = .idle
            }
            
            // --- Quit Button at the bottom right ---
            HStack {
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q", modifiers: [.command]) // Optional: Cmd+Q
            }
        }
        .font(.system(size: 13))
        .padding(12)
        .frame(width: 330)
        // A subtle animation for the enabled/disabled state change of the quality slider
        .animation(.easeInOut(duration: 0.15), value: appViewModel.outputFormat)
    }
}
