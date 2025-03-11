import Foundation

struct AirPollutionResponse: Decodable, Equatable {
    var list: [AirPollutionData]
    
    struct AirPollutionData: Decodable, Equatable {
        var main: AirQualityIndex
        var components: PollutionComponents
    }
    
    struct AirQualityIndex: Decodable, Equatable {
        var aqi: Int
    }
    
    struct PollutionComponents: Decodable, Equatable {
        var co, no, no2, o3, so2, pm2_5, pm10, nh3: Double
    }
}
