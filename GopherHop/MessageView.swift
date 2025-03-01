import SwiftUI

struct MessageView: View {
    let title: String
    let message: String
    let okTapped: (() -> Void)?
    let dismissTapped: (() -> Void)?
    
    private let size = 300.0
    private let radius = 10.0
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    var body: some View {
        VStack {
            Text(title)
                .gopherFont(size: .large)
                .foregroundStyle(Color.gopherText(for: motive))
                .frame(width: size - radius, height: size / 10)
                .padding(EdgeInsets(top: radius, leading: 0, bottom: 0, trailing: 0))
            Text(message)
                .gopherFont(size: .large)
                .foregroundStyle(Color.gopherText(for: motive))
                .lineLimit(3)
                .frame(width: size - radius, height: size / 5)
                
            HStack {
                Button {
                    okTapped?()
                    dismissTapped?()
                } label: {
                    Text("Ok")
                        .gopherFont(size: .large)
                        .frame(width: size / 2 - radius, height: size / 5)
                        .background(Color.gopherHole(for: motive))
                        .foregroundStyle(Color.gopherBackground(for: motive))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: radius, height: radius)))
                }
                Button {
                    dismissTapped?()
                } label: {
                    Text("Cancel")
                        .gopherFont(size: .large)
                        .frame(width: size / 2 - radius, height: size / 5)
                        .background(Color.gopherUnsupported(for: motive))
                        .foregroundStyle(Color.gopherBackground(for: motive))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: radius, height: radius)))
                }
            }
            .padding(EdgeInsets(top: 0, leading: radius, bottom: radius, trailing: radius))
        }
        .background(Color.gopherBackground(for: motive))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: radius, height: radius)))
        .overlay(RoundedRectangle(cornerRadius: radius).stroke(Color.gopherText(for: motive), lineWidth: 1))
    }
}

#Preview {
    MessageView(title: "External Link", message: "Link opens in your http web browser, proceed?", okTapped: nil, dismissTapped: nil)
}
