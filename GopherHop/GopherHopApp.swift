import SwiftUI
import SwiftData

@main
struct GopherHopApp: App {
//    @ObservedObject private var appSettings = AppSettings.shared
    
    var body: some Scene {
        WindowGroup {
            LandingView(viewModel: LandingViewModel())
//                .environment(\.motive, appSettings.motive)
        }
    }
}
