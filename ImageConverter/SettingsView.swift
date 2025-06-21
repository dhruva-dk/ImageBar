import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: AppViewModel

    var body: some View {
        Form {
            LabeledContent("Max Dimensions:") {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("", value: $settings.outputSize, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 70)

                    Slider(value: Binding(
                        get: { Double(settings.outputSize) },
                        set: { settings.outputSize = Int($0) }
                    ), in: 100...4096)
                }
            }

            Picker("Output Format:", selection: $settings.outputFormat) {
                Text("JPEG").tag(0)
                Text("PNG").tag(1)
            }
            .pickerStyle(.menu)
        }
        .padding()
        .frame(width: 400, height: 150)
    }
}
