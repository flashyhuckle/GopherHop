import SwiftUI
//import SwiftData

struct LandingView: View {
    @ObservedObject private var vm: LandingViewModel
    
    init(viewModel: LandingViewModel) {
        self.vm = viewModel
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
                    .simultaneousGesture(DragGesture().onEnded {
                        if abs($0.translation.width) < abs($0.translation.height) {
                            vm.scrollViewMovedUp(0 > $0.translation.height)
                        }
                    })
                    .allowsHitTesting(vm.visibleOverlayView == .none)
#if os(macOS)
    .sheet(isPresented: $vm.sheetVisible) {
        Group {
            switch vm.visibleOverlayView {
            case .settings:
                SettingsView(dismissTapped: vm.dismissTapped)
                    .frame(width: 400, height: 600)
            case .bookmarks:
                BookmarksView(
                    currentSite: vm.currentAddress,
                    bookmarkTapped: vm.lineTapped,
                    dismissTapped: vm.dismissTapped,
                    modelStorage: vm.storage)
                .frame(width: 400, height: 600)
            case .address:
                AddressBarView(
                    address: vm.currentAddress?.fullAddress,
                    okTapped: vm.lineTapped,
                    dismissTapped: vm.dismissTapped)
            case .search:
                SearchView(okTapped: vm.searchTapped, dismissTapped: vm.dismissTapped)
            case .message(let title, let message):
                MessageView(title: title, message: message, okTapped: vm.messageOkTapped, dismissTapped: vm.dismissTapped)
            case .none:
                EmptyView()
            }
        }
        
    }
                #endif
                
                GopherHelperView(
                    helperPosition: $vm.gopherPosition,
                    isLoading: $vm.isLoading,
                    settingsTapped: vm.settingsTapped,
                    reloadTapped: vm.reload,
                    homeTapped: vm.homepage,
                    bookmarkTapped: vm.bookmarkTapped,
                    globeTapped: vm.globeTapped
                )
                #if os(iOS)
                
                switch vm.visibleOverlayView {
                case .settings:
                    SettingsView(dismissTapped: vm.dismissTapped)
                case .bookmarks:
                    BookmarksView(
                        currentSite: vm.currentAddress,
                        bookmarkTapped: vm.lineTapped,
                        dismissTapped: vm.dismissTapped,
                        modelStorage: vm.storage)
                case .address:
                    AddressBarView(
                        address: vm.currentAddress?.fullAddress,
                        okTapped: vm.lineTapped,
                        dismissTapped: vm.dismissTapped)
                case .search:
                    SearchView(okTapped: vm.searchTapped, dismissTapped: vm.dismissTapped)
                case .message(let title, let message):
                    MessageView(title: title, message: message, okTapped: vm.messageOkTapped, dismissTapped: vm.dismissTapped)
                case .none:
                    EmptyView()
                    
                }
                #endif
            }
        }
        .animation(.linear(duration: 0.2), value: vm.visibleOverlayView)
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
