import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search city", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}
