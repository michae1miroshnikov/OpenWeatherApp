import SwiftUI

struct WeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var searchText: String = ""
    @State private var showAirPollution = false
    @State private var showForecast = false
    @State private var showWeatherMap = false
    @State private var showRecentSearches = false

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                // Search Bar and Recent Searches Button
                HStack {
                    // Recent Searches Button (Left Side)
                    Button(action: {
                        showRecentSearches = true
                    }) {
                        Image(systemName: "clock.fill") // Change icon here
                            .font(.system(size: 20))
                            .padding(10)
                            .background(Color.blue.opacity(0.8))
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }

                    // Search Bar
                    SearchBar(text: $searchText, onSearch: {
                        if !searchText.isEmpty {
                            viewModel.searchCity(cityName: searchText)
                        }
                    })
                }
                .padding(.horizontal)

                if let weather = viewModel.weather {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(weather.name)
                                .bold()
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                                .fontWeight(.light)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        // Buttons for Air Pollution, 5-Day Forecast, and Weather Map (Right Side)
                        HStack(spacing: 16) {
                            // Air Pollution Button
                            Button(action: {
                                showAirPollution = true
                                if let location = viewModel.location {
                                    viewModel.fetchAirPollution(latitude: location.latitude, longitude: location.longitude)
                                }
                            }) {
                                Image(systemName: "smoke.fill")
                                    .font(.system(size: 20))
                                    .padding(10)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }

                            // 5-Day Forecast Button
                            Button(action: {
                                showForecast = true
                                if let location = viewModel.location {
                                    viewModel.fetchFiveDayForecast(latitude: location.latitude, longitude: location.longitude)
                                }
                            }) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20))
                                    .padding(10)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }

                            // Weather Map Button
                            Button(action: {
                                showWeatherMap = true
                            }) {
                                Image(systemName: "map")
                                    .font(.system(size: 20))
                                    .padding(10)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                    
                    VStack {
                        HStack {
                            VStack(spacing: 20) {
                                Image(systemName: "cloud")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                                
                                Text("\(weather.weather[0].main)")
                                    .foregroundColor(.white)
                            }
                            .frame(width: 150, alignment: .leading)
                            
                            Spacer()
                            
                            Text(weather.main.feels_like.roundDouble() + "°")
                                .font(.system(size: 100))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                        }
                       
                        Spacer()
                            .frame(height: 80)
                       
                        AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 350)
                                .padding()
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                } else {
                    ProgressView()
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if let weather = viewModel.weather {
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weather now")
                            .bold()
                            .padding(.bottom)
                            .foregroundColor(.white)
                        
                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.temp_min.roundDouble() + ("°")))
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.temp_max.roundDouble() + "°"))
                        }
                        
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + " m/s"))
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showAirPollution) {
            AirPollutionView(viewModel: viewModel)
        }
        .sheet(isPresented: $showForecast) {
            ForecastView(viewModel: viewModel)
        }
        .sheet(isPresented: $showWeatherMap) {
            WeatherMapView(viewModel: viewModel)
        }
        .sheet(isPresented: $showRecentSearches) {
            RecentSearchesView(viewModel: viewModel)
        }
    }
}
