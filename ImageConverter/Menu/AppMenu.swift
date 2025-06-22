//
//  AppMenu.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/21/25.
//

import SwiftUI

struct AppMenu: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Output Format:", selection: $appViewModel.outputFormat) {
                Text("JPEG").tag(0)
                Text("PNG").tag(1)
                Text("HEIC").tag(2)
                Text("TIFF").tag(3)
            }
            .pickerStyle(.menu)
            .disabled(appViewModel.status == .processing)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Quality (JPEG & HEIC Only):")
                HStack {
                    TextField("", value: Binding(
                        get: { Int(appViewModel.quality * 100) },
                        set: { appViewModel.quality = Double($0) / 100.0 }
                    ), format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 60)
                    
                    Slider(value: $appViewModel.quality, in: 0.1...1.0)
                }
            }
            .disabled((appViewModel.outputFormat != 0 && appViewModel.outputFormat != 2) || appViewModel.status == .processing)

            VStack(alignment: .leading, spacing: 8) {
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

            StatusFooterView(status: appViewModel.status) {
                appViewModel.status = .idle
            }
            
            HStack {
                Spacer()
                Button("Quit") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut("q", modifiers: [.command])
            }
        }
        .font(.system(size: 13))
        .padding(12)
        .frame(width: 330)
        .animation(.easeInOut(duration: 0.15), value: appViewModel.outputFormat)
    }
}
