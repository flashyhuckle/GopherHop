import Foundation

struct GopherConstants {
    struct Settings {
        static let motive = "Motive"
        static let helper = "Helper"
    }
    
    struct HelperImage {
        static let handUp = "gopher"
        static let handDown = "gopherD"
    }
    
    struct HelperIcons {
        static let gear = "gear"
        static let reload = "arrow.clockwise"
        static let home = "house"
        static let bookmark = "bookmark"
        static let globe = "globe"
    }
    
    struct Font {
        static let classic = "SFMono-Regular"
    }
    
    struct AddressBar {
        static let placeholder = "gopher address"
        static let okButtonText = "Go"
    }
    
    struct SearchView {
        static let placeholder = "search"
        static let okButtonText = "Search"
    }
    
    struct BookmarksView {
        static let addCurrent = "Add current to bookmarks"
        static let home = "house"
    }
    
    struct SettingsView {
        static let motiveSectionHeader = "PICK A MOTIVE"
        static let helperSectionHeader = "HELPER POSITION"
        
        struct MotivePreviewTitles {
            static let information = "Information"
            static let gopher = "Gopher"
            static let document = "Document"
            static let image = "Image/gif"
            static let unsupported = "No support"
        }
    }
    
    struct GopherView {
        static let unsupported = "unsupported gopher hole"
        static let wrong = "something went wrong"
        struct LineView {
            static let directory = "[>]"
            static let text = "[=]"
            static let image = "[img]"
            static let gif = "[gif]"
            static let search = "[⌕]"
            static let html = "[⚭]"
        }
    }
    
    struct Buttons {
        static let dismiss = "Dismiss"
        static let cancel = "Cancel"
    }
}
