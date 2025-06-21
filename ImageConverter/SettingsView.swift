//
//  SettingsView.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/20/25.
//

// SettingsView.swift

import SwiftUI

struct SettingsView: View {
    // Connect to the shared store
    @EnvironmentObject var settings: SettingsStore

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
        .frame(width: 400)
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsStore())
}
