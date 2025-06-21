import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Main controls, always visible
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
            .font(.system(size: 13))
            .disabled(appViewModel.status == .processing)

            Divider()

            // Status indicator at bottom, always present
            if case .processing = appViewModel.status {
                HStack(spacing: 8) {
                    ProgressView().scaleEffect(0.5)
                    Text("Processing...")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else if case .failure(let message) = appViewModel.status {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text(message)
                        .foregroundColor(.red)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Button(action: {
                        appViewModel.status = .idle
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                    .help("Dismiss error")
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.red.opacity(0.07))
                )
            } else if case .idle = appViewModel.status {
                HStack(spacing: 8) {
                    Text("Drag images into the menu bar icon to convert.")
                        .foregroundColor(.secondary)
                }
            }
        }
        .font(.system(size: 13))
        .padding(15)
    }
}
