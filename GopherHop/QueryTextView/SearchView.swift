import SwiftUI

struct SearchView: View {
    @State var searchQuery: String
    let okTapped: ((String) -> Void)?
    let dismissTapped: (() -> Void)?
    @FocusState var focused
    
    init(searchQuery: String? = nil, okTapped: ((String) -> Void)? = nil, dismissTapped: (() -> Void)? = nil) {
        self.searchQuery = searchQuery ?? ""
        self.okTapped = okTapped
        self.dismissTapped = dismissTapped
    }
    
    var body: some View {
        QueryTextView(placeholder: "search", queryText: $searchQuery, okTapped: queryOkTapped, dismissTapped: dismissTapped)
    }
    
    func queryOkTapped() {
        okTapped?(searchQuery)
    }
}
