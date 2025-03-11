import Foundation
import CoreLocation

class WeatherManager {
    private let apiKey = "081e325c98bc52a63112f5b81399def3" // Replace with your API key
    private let session: any URLSessionProtocol

    // Inject URLSessionProtocol (defaults to URLSession.shared)
    init(session: any URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchData<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, response) = try await session.data(from: url)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(T.self, from: data)
    }

    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        return try await fetchData(from: urlString)
    }

    func getAirPollution(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> AirPollutionResponse {
        let urlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
        return try await fetchData(from: urlString)
    }

    func getFiveDayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ForecastResponse {
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        return try await fetchData(from: urlString)
    }
}
