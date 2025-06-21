import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var appViewModel: AppViewModel
    
    // The 'isShowingErrorAlert' computed property is now removed as it's no longer needed.
    
    var body: some View {
        // The view remains a simple VStack for now.
        VStack(alignment: .leading, spacing: 10) {
            
            // Section for Output Size
            VStack(alignment: .leading, spacing: 4) {
                Text("Maximum Output Dimension")
                HStack {
                    TextField("50", value: $appViewModel.outputSize, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Slider(value: Binding(
                        get: { Double(appViewModel.outputSize) },
                        set: { appViewModel.outputSize = Int($0) }
                    ), in: 100...4096)
                }
            }
            // 1. The controls are disabled based on the new status enum.
            .disabled(appViewModel.status == .processing)

            Divider()

            Picker("Output Format:", selection: $appViewModel.outputFormat) {
                Text("JPEG").tag(0)
                Text("PNG").tag(1)
            }
            .pickerStyle(.menu)
            // 2. This disabled modifier is also updated.
            .disabled(appViewModel.status == .processing)
            
            // 3. A ProgressView is shown when the status is 'processing'.
            if appViewModel.status == .processing {
                
                Divider()
                
                HStack(spacing: 8) {
                    ProgressView().scaleEffect(0.7)
                    Text("Processing...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding(.top, 4)
            }
        }
        .padding(15)

    }
}
