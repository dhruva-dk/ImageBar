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
        Form {
            LabeledContent("Max Dimensions:") {
                VStack(alignment: .leading, spacing: 4) {
                    TextField("", value: $sliderValue, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 70)

                    Slider(value: Binding(
                        get: { Double(sliderValue) },
                        set: { sliderValue = Int($0) }
                    ), in: 0...4096)
                }
            }

            Picker("Output Format:", selection: $outputFormat) {
                Text("JPEG").tag(0)
                Text("PNG").tag(1)
            }
            .pickerStyle(.menu)
        }
        .padding()
        .frame(width: 400)
    }
}

#Preview {
    SettingsView()
}
