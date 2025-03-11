import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var searchText = ""

    var body: some View {
        VStack {
            SearchBar(text: $searchText) {
                if !searchText.isEmpty { viewModel.searchCity(cityName: searchText) }
            }
            .padding()
            VStack(spacing: 20) {
                Text("Welcome to the Weather App").font(.title).bold()
                Text("Share your location or search for a city to get the weather.")
            }
            .multilineTextAlignment(.center)
            .padding()
            LocationButton(.shareCurrentLocation) {
                viewModel.requestLocation()
            }
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            .tint(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
