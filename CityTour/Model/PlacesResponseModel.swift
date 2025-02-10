//
//  PlacesResponseModel.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import Foundation

struct PlacesResponseModel: Decodable {
    let results: [PlaceDetailResponseModel]
}

struct PlaceDetailResponseModel: Decodable {
    let placeId: String
    let name: String
    let rating: Double
    let vicinity: String
    let photos: [PhotoInfo]?
    
    enum CodingKeys: String, CodingKey {
        case placeId = "place_id"
        case name
        case rating
        case vicinity
        case photos
    }
}

struct PhotoInfo: Decodable {
    let photoReference: String
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
