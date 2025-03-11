//
//  RecentSearchesView.swift
//  NewApp
//
//  Created by Michael Miroshnikov on 11/03/2025.
//
import SwiftUI

struct RecentSearchesView: View {
    @ObservedObject var viewModel: WeatherViewModel

    var body: some View {
        VStack {
            Text("Recent Searches")
                .font(.largeTitle)
                .bold()
                .padding()
            
            List(viewModel.searchedCities) { city in
                VStack(alignment: .leading) {
                    Text(city.name)
                        .font(.title2)
                        .bold()
                    Text("\(city.weather.main.temp.roundDouble())°")
                        .font(.body)
                    Text("Searched at: \(city.timestamp.formatted(.dateTime.hour().minute()))")
                        .font(.caption)
                }
                .padding()
            }
        }
        .padding()
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}
