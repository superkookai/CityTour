//
//  PlacesError.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import Foundation

enum PlacesError: Error {
    case invalidURL
    case invalidResponse
    case badRequestError
    case serverError
}
