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
        QueryTextView(placeholder: GopherConstants.AddressBar.placeholder, queryText: $address, okButtonText: GopherConstants.AddressBar.okButtonText, okTapped: queryOkTapped, dismissTapped: dismissTapped)
    }
    
    func queryOkTapped() {
        okTapped?(address.getGopherLineForRequest())
    }
}
