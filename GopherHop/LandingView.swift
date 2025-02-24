import SwiftUI
import SwiftData

struct LandingView: View {
    @ObservedObject private var vm: LandingViewModel
    
    #warning("Change vm from optional")
    init(viewModel: LandingViewModel? = nil) {
        self.vm = viewModel ?? LandingViewModel()
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if !vm.cache.isEmpty {
                    GopherView(gopher: $vm.cache.last!)
                        .withGopherBackGestureBottomView(offset: $vm.offset, proxy: reader)
                }
                ZStack {
                    Color(UIColor.systemBackground)
                        .ignoresSafeArea()
                    GopherView(gopher: $vm.current, lineTapped: vm.lineTapped)
                        .frame(width: reader.size.width, height: reader.size.height)
                        .simultaneousGesture(SpatialTapGesture().onEnded { vm.screenTapped(at: $0.location) })
                }
                .withGopherBackGestureTopView(offset: $vm.offset, proxy: reader, goBack: vm.goBack, isOn: $vm.navigationEnabled)
                .simultaneousGesture(DragGesture().onChanged { vm.scrollViewMovedUp(0 > $0.translation.height) })
                
                GopherHelperView(
                    helperPosition: $vm.gopherPosition,
                    settingsTapped: vm.settingsTapped,
                    reloadTapped: vm.reload,
                    homeTapped: vm.homepage,
                    bookmarkTapped: vm.bookmarkTapped,
                    globeTapped: vm.globeTapped
                )
                
                if vm.isSettingsVisible {
                    SettingsView(isSettingsVisible: $vm.isSettingsVisible)
                }
                
                if vm.isBookmarksVisible {
                    BookmarksView(
                        currentSite: vm.currentAddress,
                        isBookmarksVisible: $vm.isBookmarksVisible,
                        bookmarkTapped: vm.lineTapped,
                        modelStorage: vm.storage
                    )
                }
                
                if vm.isAddressBarVisible {
                    AddressBarView(
                        address: vm.addressBarText,
                        isAddressBarVisible: $vm.isAddressBarVisible,
                        okTapped: vm.lineTapped
                    )
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
    LandingView()
}
