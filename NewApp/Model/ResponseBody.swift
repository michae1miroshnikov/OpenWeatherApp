import Foundation

struct ResponseBody: Codable, Equatable {
    var coord: Coordinates
    var weather: [Weather]
    var main: Main
    var name: String
    var wind: Wind

    struct Coordinates: Codable, Equatable {
        var lon, lat: Double
    }

    struct Weather: Codable, Equatable {
        var id: Double
        var main, description, icon: String
    }

    struct Main: Codable, Equatable {
        var temp, feels_like, temp_min, temp_max, pressure, humidity: Double
    }
    
    struct Wind: Codable, Equatable {
        var speed, deg: Double
    }
}
