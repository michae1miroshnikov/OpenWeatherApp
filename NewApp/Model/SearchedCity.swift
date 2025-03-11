//
//  SearchedCity.swift
//  NewApp
//
//  Created by Michael Miroshnikov on 11/03/2025.
//

import Foundation

struct SearchedCity: Identifiable, Codable {
    let id = UUID()
    let name: String
    let weather: ResponseBody
    let timestamp: Date
}
