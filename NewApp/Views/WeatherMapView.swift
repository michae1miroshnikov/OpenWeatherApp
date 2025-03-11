import SwiftUI
import MapKit

struct WeatherMapView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.3676, longitude: 4.9041),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )
    @State private var showShareSheet = false
    @State private var shareText = ""
    
    var body: some View {
        VStack {
            Text("Map")
                .font(.largeTitle)
                .bold()
                .padding()
            
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: viewModel.location.map { [WeatherLocation(coordinate: $0)] } ?? []) { location in
                MapMarker(coordinate: location.coordinate, tint: .blue)
            }
            .edgesIgnoringSafeArea(.all)
            
            Button("Share Location and Weather") {
                prepareShareText()
                showShareSheet = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .onAppear {
            updateLocation()
        }
        .sheet(isPresented: $showShareSheet) {
            if !shareText.isEmpty {
                ActivityView(activityItems: [shareText])
            } else {
                Text("We trying to get your location").padding()
                Text("Wait few seconds,please....").padding()
            }
        }
    }
    
    private func updateLocation() {
        if let location = viewModel.location {
            region.center = location
        }
    }
    
    private func prepareShareText() {
        if let location = viewModel.location, let weather = viewModel.weather {
            shareText = """
            🌍 Location: \(location.latitude), \(location.longitude)
            ☁️ Weather: \(weather.weather[0].description)
            🌡️ Temp: \(weather.main.temp.roundDouble())°C
            💧 Humidity: \(weather.main.humidity.roundDouble())%
            💨 Wind: \(weather.wind.speed.roundDouble()) m/s
            """
        } else {
            shareText = "Location and weather data unavailable."
        }
    }
}

struct WeatherLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
