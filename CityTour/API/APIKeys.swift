//
//  APIKeys.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import Foundation

struct APIKeys {
    
    static func getPlacesAPIKey() -> String? {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict["placesAPIKey"] as? String
        }
        return nil
    }
}
