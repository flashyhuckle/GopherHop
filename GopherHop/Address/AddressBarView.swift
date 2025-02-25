import SwiftUI

struct AddressBarView: View {
    @State var address: String
    let okTapped: ((GopherLine) -> Void)?
    let dismissTapped: (() -> Void)?
    @FocusState var focused
    
    @AppStorage("Motive") private var motive: SettingsColorMotive?
    
    init(address: String? = nil, okTapped: ((GopherLine) -> Void)? = nil, dismissTapped: (() -> Void)? = nil) {
        self.address = address ?? ""
        self.okTapped = okTapped
        self.dismissTapped = dismissTapped
    }
    
    var body: some View {
        VStack {
            TextField("gopher address", text: $address)
                .onSubmit {
                    okTapped?(address.getGopherLineForRequest())
                    dismissTapped?()
                    focused = false
                }
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundStyle(Color.gopherText(for: motive))
                .lineLimit(3)
                .frame(width: 290, height: 150)
                .keyboardType(.URL)
                .submitLabel(.go)
                .focused($focused)
                .onAppear { focused = true }
                
            HStack {
                Button {
                    okTapped?(address.getGopherLineForRequest())
                    dismissTapped?()
                    focused = false
                } label: {
                    Text("Ok")
                        .frame(width: 150, height: 75)
                        .background(Color.gopherHole(for: motive))
                        .foregroundStyle(.white)
                }
                Button {
                    dismissTapped?()
                    focused = false
                } label: {
                    Text("Cancel")
                        .frame(width: 150, height: 75)
                        .background(Color.gopherUnsupported(for: motive))
                        .foregroundStyle(.white)
                }
            }
        }
        .background(Color.gopherBackground(for: motive))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gopherText(for: motive), lineWidth: 2))
    }
}

#Preview {
    @Previewable @State var address = "gopher.black:70//asdasdasdas/das/da/sd/a"
    AddressBarView(address: address, okTapped: nil, dismissTapped: nil)
}
