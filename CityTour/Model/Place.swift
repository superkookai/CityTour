//
//  Place.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import Foundation

struct Place: Identifiable, Hashable {
    let id: String
    let name: String
    let photoURL: URL
    let rating: Double
    let address: String
    
    init?(place: PlaceDetailResponseModel) {
        self.id = place.placeId
        self.name = place.name
        self.rating = place.rating
        self.address = place.vicinity
        
        guard let googlePlacesKey = APIKeys.getPlacesAPIKey(),
              let photoReference = place.photos?.first?.photoReference,
              let photoURL = URL(string:"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photo_reference=\(photoReference)&key=\(googlePlacesKey)")
        else { return nil }
        self.photoURL = photoURL
    }
}
