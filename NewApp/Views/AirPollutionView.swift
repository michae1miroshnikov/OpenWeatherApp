import SwiftUI

struct AirPollutionView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Air Quality")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
                .padding(.top)

            if let airPollution = viewModel.airPollution {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Health Impact")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(getHealthImpactDescription(aqi: airPollution.list[0].main.aqi))
                        .font(.body)
                        .foregroundColor(.white)
                }

                Divider()
                    .background(Color.white)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Main Pollutant")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text(getMainPollutantDescription(components: airPollution.list[0].components))
                        .font(.body)
                        .foregroundColor(.white)
                }

                Divider()
                    .background(Color.white)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Pollutant Data")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    
                    Group {
                        Text("NO₂: Nitrogen Dioxide - \(airPollution.list[0].components.no2) µg/m³")
                        Text("SO₂: Sulfur Dioxide - \(airPollution.list[0].components.so2) µg/m³")
                        Text("NO: Nitrogen Monoxide - \(airPollution.list[0].components.no) µg/m³")
                        Text("O₃: Ozone - \(airPollution.list[0].components.o3) µg/m³")
                        Text("PM₁₀: Particulate Matter < 10 µm - \(airPollution.list[0].components.pm10) µg/m³")
                        Text("PM₂.₅: Particulate Matter < 2.5 µm - \(airPollution.list[0].components.pm2_5) µg/m³")
                        Text("CO: Carbon Monoxide - \(airPollution.list[0].components.co) µg/m³")
                        Text("NH₃: Ammonia - \(airPollution.list[0].components.nh3) µg/m³")
                    }
                    .font(.body)
                    .foregroundColor(.white)
                }
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }

            Spacer()

            Text("Air quality data provided by OpenWeather")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
                .padding(.bottom)
        }
        .padding()
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }

    // Helper function to get health impact description based on AQI
    private func getHealthImpactDescription(aqi: Int) -> String {
        switch aqi {
        case 1:
            return "Good air quality. No health impacts expected."
        case 2:
            return "Moderate air quality. Unusually sensitive individuals should consider reducing prolonged outdoor exertion."
        case 3:
            return "Unhealthy for sensitive groups. People with respiratory or heart conditions should reduce outdoor exertion."
        case 4:
            return "Unhealthy air quality. Everyone may begin to experience health effects; sensitive groups should avoid outdoor exertion."
        case 5:
            return "Very unhealthy air quality. Health warnings of emergency conditions. The entire population is likely to be affected."
        default:
            return "Air quality data is unavailable."
        }
    }

    // Helper function to get the main pollutant description
    private func getMainPollutantDescription(components: AirPollutionResponse.PollutionComponents) -> String {
        let pollutants = [
            "NO₂": components.no2,
            "SO₂": components.so2,
            "NO": components.no,
            "O₃": components.o3,
            "PM₁₀": components.pm10,
            "PM₂.₅": components.pm2_5,
            "CO": components.co,
            "NH₃": components.nh3
        ]

        if let mainPollutant = pollutants.max(by: { $0.value < $1.value }) {
            return "\(mainPollutant.key): \(mainPollutant.value) µg/m³"
        } else {
            return "No pollutant data available."
        }
    }
}
