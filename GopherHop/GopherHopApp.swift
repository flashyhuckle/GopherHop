import SwiftUI
import SwiftData

@main
struct GopherHopApp: App {
    @StateObject private var viewModel = LandingViewModel()
    var body: some Scene {
        WindowGroup {
            LandingView(vm: viewModel)
        }
    }
}
