import Foundation
import CoreLocation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var location: CLLocationCoordinate2D?
    @Published var weather: ResponseBody?
    @Published var airPollution: AirPollutionResponse?
    @Published var forecast: ForecastResponse?
    @Published var isLoading = false
    @Published var error: String?
    @Published var searchedCities: [SearchedCity] = []
    
    private let locationManager = LocationManager()
    private let weatherManager = WeatherManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        locationManager.$location
            .receive(on: RunLoop.main)
            .sink { [weak self] newLocation in
                guard let self = self, let newLocation = newLocation else { return }
                self.location = newLocation
                self.fetchWeather(latitude: newLocation.latitude, longitude: newLocation.longitude)
            }
            .store(in: &cancellables)
    }
    
    func requestLocation() {
        isLoading = true
        error = nil
        locationManager.requestLocation()
    }
    
    func searchCity(cityName: String) {
        isLoading = true
        error = nil
        CLGeocoder().geocodeAddressString(cityName) { [weak self] placemarks, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
                    self.isLoading = false
                    return
                }
                if let location = placemarks?.first?.location?.coordinate {
                    self.location = location
                    self.fetchWeather(latitude: location.latitude, longitude: location.longitude)
                } else {
                    self.error = "City not found"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let weather = try await weatherManager.getCurrentWeather(latitude: latitude, longitude: longitude)
                DispatchQueue.main.async {
                    self.weather = weather
                    self.isLoading = false
                    self.addSearchedCity(name: weather.name, weather: weather)
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Failed to fetch weather data: \(error.localizedDescription)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func addSearchedCity(name: String, weather: ResponseBody) {
        let newCity = SearchedCity(name: name, weather: weather, timestamp: Date())
        searchedCities.insert(newCity, at: 0)
        if searchedCities.count > 5 {
            searchedCities.removeLast()
        }
    }
    
    func fetchAirPollution(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let airPollution = try await weatherManager.getAirPollution(latitude: latitude, longitude: longitude)
                DispatchQueue.main.async {
                    self.airPollution = airPollution
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Failed to fetch air pollution data: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func fetchFiveDayForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let forecast = try await weatherManager.getFiveDayForecast(latitude: latitude, longitude: longitude)
                DispatchQueue.main.async {
                    self.forecast = forecast
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = "Failed to fetch 5-day forecast: \(error.localizedDescription)"
                }
            }
        }
    }
}
