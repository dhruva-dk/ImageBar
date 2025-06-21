//
//  SettingsView.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/20/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var sliderValue: Int = 1200
    @State private var outputFormat = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section for Output Size
            VStack(alignment: .leading, spacing: 4) {
                Text("Maximum Output Dimension")
                    .font(.headline)
                HStack {
                    TextField("50", value: $sliderValue, format: .number)
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
            }

            Divider()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
