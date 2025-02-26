import SwiftUI
import SwiftData

struct LandingView: View {
    @StateObject private var vm: LandingViewModel
    
    init(viewModel: LandingViewModel) {
        _vm = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if !vm.cache.isEmpty {
                    GopherView(gopher: vm.cache.last!)
                        .withGopherBackGestureBottomView(offset: $vm.offset, proxy: reader)
                }
                GopherView(gopher: vm.current, lineTapped: vm.lineTapped)
                    .withGopherBackGestureTopView(offset: $vm.offset, proxy: reader, goBack: vm.goBack, isOn: $vm.navigationEnabled)
                    .simultaneousGesture(SpatialTapGesture().onEnded { vm.screenTapped(at: $0.location) })
                    .simultaneousGesture(DragGesture().onChanged { vm.scrollViewMovedUp(0 > $0.translation.height) })
                
                GopherHelperView(
                    helperPosition: $vm.gopherPosition,
                    settingsTapped: vm.settingsTapped,
                    reloadTapped: vm.reload,
                    homeTapped: vm.homepage,
                    bookmarkTapped: vm.bookmarkTapped,
                    globeTapped: vm.globeTapped
                )
                
                switch vm.visibleOverlayView {
                case .settings:
                    SettingsView(dismissTapped: vm.dismissTapped)
                case .bookmarks:
                    BookmarksView(
                        currentSite: vm.currentAddress,
                        bookmarkTapped: vm.lineTapped,
                        dismissTapped: vm.dismissTapped,
                        modelStorage: vm.storage
                    )
                case .address:
                    AddressBarView(
                        address: vm.currentAddress?.fullAddress,
                        okTapped: vm.lineTapped,
                        dismissTapped: vm.dismissTapped
                    )
                case .search:
                    SearchView(okTapped: vm.searchTapped, dismissTapped: vm.dismissTapped)
                case .none:
                    EmptyView()
                }
            }
        }
        .refreshable {
            vm.reload()
        }
        
        .onAppear {
            vm.homepage()
        }
    }
}

#Preview {
    LandingView(viewModel: LandingViewModel())
}
