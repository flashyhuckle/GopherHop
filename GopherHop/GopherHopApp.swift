import SwiftUI
import SwiftData

@main
struct GopherHopApp: App {
    var body: some Scene {
        WindowGroup {
            LandingView(viewModel: LandingViewModel())
        }
    }
}
