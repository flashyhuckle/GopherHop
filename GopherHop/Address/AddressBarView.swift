import SwiftUI

struct AddressBarView: View {
    @State var address: String
    let okTapped: ((GopherLine) -> Void)?
    let dismissTapped: (() -> Void)?
    
    @FocusState var focused
    
    init(address: String? = nil, okTapped: ((GopherLine) -> Void)? = nil, dismissTapped: (() -> Void)? = nil) {
        self.address = address ?? ""
        self.okTapped = okTapped
        self.dismissTapped = dismissTapped
    }
    
    var body: some View {
        VStack {
            TextField("gopher address", text: $address, axis: .vertical)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundStyle(Color(UIColor.gopherColor(.text)))
                .lineLimit(3)
                .frame(width: 200, height: 150)
                .keyboardType(.URL)
                .submitLabel(.go)
                .focused($focused)
                .onAppear { focused = true }
            HStack {
                Button {
                    okTapped?(address.getGopherLineForRequest())
                    dismissTapped?()
                } label: {
                    Text("Ok")
                        .frame(width: 150, height: 75)
                        .background(Color(UIColor.gopherColor(.documentHole)))
                        .foregroundStyle(.white)
                }
                Button {
                    dismissTapped?()
                } label: {
                    Text("Cancel")
                        .frame(width: 150, height: 75)
                        .background(Color(UIColor.gopherColor(.unsupportedHole)))
                        .foregroundStyle(.white)
                }
            }
        }
        .background(Color(UIColor.gopherColor(.background)))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(UIColor.gopherColor(.text)), lineWidth: 2))
    }
}

#Preview {
    @Previewable @State var address = "gopher.black:70//asdasdasdas/das/da/sd/a"
    AddressBarView(address: address, okTapped: nil, dismissTapped: nil)
}
