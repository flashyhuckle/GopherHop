import SwiftUI

struct AddressBarView: View {
    @State var address: String
    @Binding var isAddressBarVisible: Bool
    let okTapped: ((GopherLine) -> Void)?
    
    var body: some View {
        VStack {
            TextField("gopher address", text: $address, axis: .vertical)
                .multilineTextAlignment(.center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .foregroundStyle(.primary)
                .lineLimit(3)
                .frame(width: 200, height: 150)
            HStack {
                Button {
                    okTapped?(address.getGopherLineForRequest())
                    isAddressBarVisible = false
                } label: {
                    Text("Ok")
                        .frame(width: 150, height: 75)
                        .background(.orange)
                        .foregroundStyle(.white)
                }
                Button {
                    isAddressBarVisible = false
                } label: {
                    Text("Cancel")
                        .frame(width: 150, height: 75)
                        .background(Color(UIColor.systemBackground))
                        .foregroundStyle(.primary)
                }
                
            }
        }
        .background(Color(UIColor.systemBackground))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.primary, lineWidth: 2)
            )
        
#warning("keyboard on")
        
    }
}

#Preview {
    @Previewable @State var address = "gopher.black:70//asdasdasdas/das/da/sd/a"
    @Previewable @State var isVisible = true
    AddressBarView(address: address, isAddressBarVisible: $isVisible, okTapped: nil)
}
