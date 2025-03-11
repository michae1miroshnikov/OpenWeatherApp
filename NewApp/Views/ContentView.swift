import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()

    var body: some View {
        VStack {
            if let location = viewModel.location {
                if let weather = viewModel.weather {
                    WeatherView(viewModel: viewModel)
                } else {
                    LoadingView()
                }
            } else {
                if viewModel.isLoading {
                    LoadingView()
                } else {
                    WelcomeView(viewModel: viewModel)
                }
            }
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}
