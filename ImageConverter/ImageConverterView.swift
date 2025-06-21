import SwiftUI

struct ImageConverterView: View {
    @State private var sliderValue: Int = 800
    @State private var outputFormat = 0
    
    @State private var importing = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section for Output Size
            VStack(alignment: .leading, spacing: 4) {
                Text("Maximum Output Dimension")
                    .font(.headline)
                HStack {
                    TextField("50", value: $sliderValue, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 60)
                    Slider(value: Binding(
                        get: { Double(sliderValue) },
                        set: { sliderValue = Int($0) }
                    ), in: 0...4096)
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
                self.importing = true
            }) {
                HStack {
                    Image(systemName: "photo.on.rectangle")
                    Text("Select Images")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .fileImporter(
                isPresented: $importing,
                allowedContentTypes: [.image],
                allowsMultipleSelection: true
            ) { result in
                switch result {
                case .success(let files):
                    for file in files {
                        print(file.absoluteString)
                    }
                    importing = false
                case .failure(let error):
                    print(error.localizedDescription)
                    importing = false
                }
            }


        }
        .padding()
    }
}

#Preview {
    ImageConverterView()
}
