import SwiftUI

struct AppMenu: View {
    @Environment(\.openSettings) private var openSettings
    
    // The view now depends on the AppViewModel.
    @EnvironmentObject var appViewModel: AppViewModel

    // This state is purely for the view's fileImporter presentation. It's fine to keep it here.
    @State private var isImporting = false
    
    // We create a computed binding to determine if the alert should be shown.
    // This is a clean way to bridge the ViewModel's optional error string to the alert's isPresented boolean.
    private var isShowingErrorAlert: Binding<Bool> {
        Binding(
            get: { appViewModel.errorMessage != nil },
            set: { _ in
                // When the alert is dismissed, we clear the error message in the ViewModel.
                appViewModel.errorMessage = nil
            }
        )
    }
    
    var body: some View {
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
            // 1. We add the disabled modifier here. It will disable both the
            //    TextField and the Slider since they are inside this VStack.
            .disabled(appViewModel.isProcessing)

            Divider()

            Picker("Output Format:", selection: $appViewModel.outputFormat) {
                Text("JPEG").tag(0)
                Text("PNG").tag(1)
            }
            .pickerStyle(.menu)
            // 2. We also disable the picker.
            .disabled(appViewModel.isProcessing)
            
        }
        .padding(10)
        .alert(
            "An Error Occurred",
            isPresented: isShowingErrorAlert, // Use our computed binding
            actions: { Button("OK") {} },
            message: {
                // The message text comes directly from the ViewModel.
                Text(appViewModel.errorMessage ?? "An unknown error occurred.")
            }
        )
    }
}
