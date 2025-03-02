import SwiftUI

struct QueryTextView: View {
    let placeholder: String
    @Binding var queryText: String
    let okButtonText: String
    let okTapped: (() -> Void)?
    let dismissTapped: (() -> Void)?
    @FocusState var focused
    
    private let size = 300.0
    private let radius = 10.0
    
    @AppStorage(SettingsConstants.motive) private var motive: SettingsColorMotive?
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $queryText)
                .onSubmit {
                    okTapped?()
                    dismissTapped?()
                    focused = false
                }
                .gopherFont(size: .large)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundStyle(Color.gopherText(for: motive))
                .lineLimit(3)
                .frame(width: size - radius, height: size / 5)
                .keyboardType(.URL)
                .submitLabel(.go)
                .focused($focused)
                .onAppear { focused = true }
                
            HStack {
                Button {
                    okTapped?()
                    dismissTapped?()
                    focused = false
                } label: {
                    Text(okButtonText)
                        .gopherFont(size: .large)
                        .frame(width: size / 2 - radius, height: size / 5)
                        .background(Color.gopherHole(for: motive))
                        .foregroundStyle(Color.gopherBackground(for: motive))
                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: radius, height: radius)))
                }
                Button {
                    dismissTapped?()
                    focused = false
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
    @Previewable @State var address = "gopher.black:70//asdasdasdas/das/da/sd/a"
    QueryTextView(placeholder: "type something", queryText: $address, okButtonText: "Ok", okTapped: nil, dismissTapped: nil)
}
