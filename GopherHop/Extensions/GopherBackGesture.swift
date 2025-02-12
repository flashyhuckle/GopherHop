import SwiftUI

struct GopherBackGestureTopView: ViewModifier {
    @Binding var offset: CGFloat
    let proxy: GeometryProxy
    let goBack: (() -> Void)
    @Binding var isOn: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
            Color.clear
                .contentShape(Rectangle())
                .frame(width: 30, height: proxy.size.height)
                .position(x: 15, y: proxy.size.height/2)
        }
        .offset(x: offset)
        .gesture(
            !isOn ? DragGesture().onChanged{_ in }.onEnded{_ in } :
                DragGesture()
                .onChanged { gesture in
                    if gesture.startLocation.x < 50 {
                        offset = gesture.translation.width
                    }
                }
                .onEnded { _ in
                    if abs(Int(offset)) > Int(proxy.size.width / 3) {
                        withAnimation {
                            offset = proxy.size.width
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            offset = 0
                            goBack()
                        }
                    } else {
                        withAnimation {
                            offset = 0
                        }
                    }
                }
        )
    }
}

struct GopherBackGestureBottomView: ViewModifier {
    @Binding var offset: CGFloat
    let proxy: GeometryProxy
    func body(content: Content) -> some View {
        content
            .allowsTightening(false)
            .offset(x: (offset - proxy.size.width)/2)
    }
}

extension View {
    func withGopherBackGestureTopView(
        offset: Binding<CGFloat>,
        proxy: GeometryProxy,
        goBack: @escaping (() -> Void),
        isOn: Binding<Bool> = Binding.constant(true)
    ) -> some View {
        modifier(GopherBackGestureTopView(offset: offset, proxy: proxy, goBack: goBack, isOn: isOn))
    }
    
    func withGopherBackGestureBottomView(
        offset: Binding<CGFloat>,
        proxy: GeometryProxy
    ) -> some View {
        modifier(GopherBackGestureBottomView(offset: offset, proxy: proxy))
    }
}
