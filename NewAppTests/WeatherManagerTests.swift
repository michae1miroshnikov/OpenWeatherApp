import XCTest
@testable import NewApp // Replace with your app's module name

class WeatherManagerTests: XCTestCase {
    var weatherManager: WeatherManager!
    var mockURLSession: URLSessionMock!

    override func setUp() {
        super.setUp()
        mockURLSession = URLSessionMock()
        weatherManager = WeatherManager(session: mockURLSession)
    }

    override func tearDown() {
        weatherManager = nil
        mockURLSession = nil
        super.tearDown()
    }

    // MARK: - Test Current Weather

    func testGetCurrentWeatherSuccess() async {
        // Mock JSON response
        let json = """
        {
            "coord": {"lon": -0.1257, "lat": 51.5085},
            "weather": [{"id": 800, "main": "Clear", "description": "clear sky", "icon": "01d"}],
            "main": {"temp": 15.0, "feels_like": 14.0, "temp_min": 13.0, "temp_max": 17.0, "pressure": 1012, "humidity": 60},
            "name": "London",
            "wind": {"speed": 5.0, "deg": 180}
        }
        """
        mockURLSession.mockData = json.data(using: .utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            let weather = try await weatherManager.getCurrentWeather(latitude: 51.5085, longitude: -0.1257)
            XCTAssertEqual(weather.name, "London")
            XCTAssertEqual(weather.main.temp, 15.0)
        } catch {
            XCTFail("Failed to fetch weather: \(error)")
        }
    }

    func testGetCurrentWeatherFailure() async {
        // Mock an error
        mockURLSession.mockError = URLError(.badServerResponse)

        do {
            _ = try await weatherManager.getCurrentWeather(latitude: 51.5085, longitude: -0.1257)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    func testGetCurrentWeatherInvalidJSON() async {
        // Mock invalid JSON
        mockURLSession.mockData = "Invalid JSON".data(using: .utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            _ = try await weatherManager.getCurrentWeather(latitude: 51.5085, longitude: -0.1257)
            XCTFail("Expected to throw a decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    // MARK: - Test Air Pollution

    func testGetAirPollutionSuccess() async {
        // Mock JSON response
        let json = """
        {
            "list": [{
                "main": {"aqi": 2},
                "components": {
                    "co": 201.94053649902344,
                    "no": 0.01877197064459324,
                    "no2": 0.7711350917816162,
                    "o3": 68.66455078125,
                    "so2": 0.6407499313354492,
                    "pm2_5": 0.5,
                    "pm10": 0.540438711643219,
                    "nh3": 0.12369127571582794
                }
            }]
        }
        """
        mockURLSession.mockData = json.data(using: .utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            let airPollution = try await weatherManager.getAirPollution(latitude: 51.5085, longitude: -0.1257)
            XCTAssertEqual(airPollution.list[0].main.aqi, 2)
            XCTAssertEqual(airPollution.list[0].components.co, 201.94053649902344)
        } catch {
            XCTFail("Failed to fetch air pollution: \(error)")
        }
    }

    func testGetAirPollutionFailure() async {
        // Mock an error
        mockURLSession.mockError = URLError(.badServerResponse)

        do {
            _ = try await weatherManager.getAirPollution(latitude: 51.5085, longitude: -0.1257)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - Test 5-Day Forecast

    func testGetFiveDayForecastSuccess() async {
        // Mock JSON response
        let json = """
        {
            "list": [{
                "dt": 1638316800,
                "main": {
                    "temp": 15.0,
                    "feels_like": 14.0,
                    "temp_min": 13.0,
                    "temp_max": 17.0,
                    "pressure": 1012,
                    "humidity": 60
                },
                "weather": [{
                    "id": 800,
                    "main": "Clear",
                    "description": "clear sky",
                    "icon": "01d"
                }]
            }]
        }
        """
        mockURLSession.mockData = json.data(using: .utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            let forecast = try await weatherManager.getFiveDayForecast(latitude: 51.5085, longitude: -0.1257)
            XCTAssertEqual(forecast.list[0].main.temp, 15.0)
            XCTAssertEqual(forecast.list[0].weather[0].main, "Clear")
        } catch {
            XCTFail("Failed to fetch forecast: \(error)")
        }
    }

    func testGetFiveDayForecastFailure() async {
        // Mock an error
        mockURLSession.mockError = URLError(.badServerResponse)

        do {
            _ = try await weatherManager.getFiveDayForecast(latitude: 51.5085, longitude: -0.1257)
            XCTFail("Expected to throw an error")
        } catch {
            XCTAssertNotNil(error)
        }
    }

    // MARK: - Test Edge Cases

    func testInvalidURL() async {
        // Mock an invalid URL
        mockURLSession.mockError = URLError(.badURL)

        do {
            _ = try await weatherManager.getCurrentWeather(latitude: 51.5085, longitude: -0.1257)
            XCTFail("Expected to throw a bad URL error")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badURL)
        }
    }

    func testEmptyResponse() async {
        // Mock empty response
        mockURLSession.mockData = Data()
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        do {
            _ = try await weatherManager.getCurrentWeather(latitude: 51.5085, longitude: -0.1257)
            XCTFail("Expected to throw a decoding error")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
}
