import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) { // Slightly increased spacing
            
            // --- Main Controls ---
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

            Picker("Output Format:", selection: $appViewModel.outputFormat) {
                Text("JPEG").tag(0)
                Text("PNG").tag(1)
            }
            .pickerStyle(.menu)
            .disabled(appViewModel.status == .processing)


            // --- Status Footer ---
            // The entire if/else if chain is replaced by this one clean, composed view.
            StatusFooterView(status: appViewModel.status) {
                // This closure defines what happens when the dismiss action is triggered.
                appViewModel.status = .idle
            }
        }
        .font(.system(size: 13))
        .padding(12)
        .frame(width: 320)
    }
}
