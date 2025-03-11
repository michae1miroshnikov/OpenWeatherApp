import SwiftUI

struct ForecastView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            if let forecast = viewModel.forecast {
                List(forecast.list, id: \.dt) { item in
                    VStack(alignment: .leading) {
                        Text("Date: \(Date(timeIntervalSince1970: TimeInterval(item.dt)).formatted(.dateTime.month().day().hour().minute()))")
                        Text("Temp: \(item.main.temp.roundDouble())°")
                        Text("Weather: \(item.weather[0].description)")
                    }
                    .foregroundColor(.white)
                    .listRowBackground(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                }
            } else {
                ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
        }
        .padding()
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}
