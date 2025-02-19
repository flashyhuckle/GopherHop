import SwiftUI
import SwiftData

struct LandingView<ViewModel>: View where ViewModel:LandingViewModelType {
    @ObservedObject var vm: ViewModel
    
//    init(viewModel: LandingViewModelType? = nil) {
//        self.vm = viewModel ?? LandingViewModel()
//    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                if !vm.cache.isEmpty {
                    GopherView(gopher: $vm.cache.last!)
                        .withGopherBackGestureBottomView(offset: $vm.gopherViewOffset, proxy: reader)
                }
                ZStack {
                    Color(UIColor.systemBackground)
                        .ignoresSafeArea()
                    GopherView(gopher: $vm.current, lineTapped: vm.lineTapped)
                        .frame(width: reader.size.width, height: reader.size.height)
                        .simultaneousGesture(SpatialTapGesture().onEnded { vm.screenTapped(at: $0.location) })
                }
                .withGopherBackGestureTopView(offset: $vm.gopherViewOffset, proxy: reader, goBack: vm.goBack, isOn: $vm.cacheNavigationEnabled)
                .simultaneousGesture(DragGesture().onChanged { vm.scrollViewMovedUp(0 > $0.translation.height) })
                
                
                
                GopherHelperView(
                    helperPosition: $vm.gopherPosition,
                    settingsTapped: vm.settingsTapped,
                    reloadTapped: vm.reload,
                    homeTapped: vm.homepage,
                    globeTapped: {}
                )
                
                if vm.isSettingsVisible {
                    SettingsView(isVisible: $vm.isSettingsVisible)
                        .ignoresSafeArea()
                        .frame(width: reader.size.width, height: reader.size.height)
                        
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
    @Previewable @StateObject var vm = LandingViewModel()
    LandingView(vm: vm)
}
