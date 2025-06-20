import SwiftUI

struct ContentView: View {
    @State private var sliderValue: Int = 50

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Output Size")
            HStack {
                TextField("50", value: $sliderValue, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
                Slider(value: Binding(
                    get: { Double(sliderValue) },
                    set: { sliderValue = Int($0) }
                ), in: 0...100)
            }
            Divider()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
