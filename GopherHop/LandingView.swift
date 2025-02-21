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
                    globeTapped: vm.globeTapped
                )
                
                if vm.isSettingsVisible {
                    SettingsView(isVisible: $vm.isSettingsVisible)
                }
                
                if vm.isBookmarksVisible {
                    BookmarksView(isBookmarksVisible: $vm.isBookmarksVisible)
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
