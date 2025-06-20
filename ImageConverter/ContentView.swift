import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Int = 50
    @State private var outputFormat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section for Output Size
            VStack(alignment: .leading, spacing: 4) {
                Text("Output Size")
                    .font(.headline)
                HStack {
                    TextField("50", value: $sliderValue, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Slider(value: Binding(
                        get: { Double(sliderValue) },
                        set: { sliderValue = Int($0) }
                    ), in: 0...100)
                }
            }

            Divider()

            // Section for Output Format
            VStack(alignment: .leading, spacing: 4) {
                Text("Output Format")
                    .font(.headline)
                Picker("", selection: $outputFormat) {
                    Text("JPG").tag(0)
                    Text("PNG").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Divider()

            // Section for File Selection
            Button(action: {
                // File selection functionality will be added here
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Select Images")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)


        }
        .padding()
        .frame(width: 280) // A typical width for menu bar extras
    }
}

#Preview {
    ContentView()
}
