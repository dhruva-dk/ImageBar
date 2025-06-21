import SwiftUI

struct ImageConverterView: View {

    @State private var importing = false

    var body: some View {
        
        //File picker button
        // Section for File Selection
        Button( "Select Images") {
            self.importing = true
        }
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
        
        
        Button("Settings") {
            
        }
        Divider()
        Button("Quit") {
            NSApplication.shared.terminate(nil)
        }
        
        
    }
}

#Preview {
    ImageConverterView()
}
