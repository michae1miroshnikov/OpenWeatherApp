import Foundation

struct ForecastResponse: Decodable, Equatable {
    var list: [ForecastData]
    
    struct ForecastData: Decodable, Equatable {
        var dt: Int
        var main: Main
        var weather: [Weather]
    }
    
    struct Main: Decodable, Equatable {
        var temp, feels_like, temp_min, temp_max, pressure, humidity: Double
    }
    
    struct Weather: Decodable, Equatable {
        var id: Double
        var main, description, icon: String
    }
}
