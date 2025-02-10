//
//  APIClient.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import Foundation
import CoreLocation

//CLLocation >> latitude, longitude

class APIClient {
    private let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    private let googlePlacesKey = APIKeys.getPlacesAPIKey()
    
    typealias PlacesResult = Result<PlacesResponseModel, PlacesError>
    
    func getPlaces(forKeyword keyword: String, location: CLLocation) async -> PlacesResult {
        guard let url = createURL(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, keyword: keyword) else {
            print("Error: Cannot create URL")
            return .failure(.invalidURL)
        }
        do {
            let (data,response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else {
                print("Error no response back: \(String(describing: response))")
                return .failure(.invalidResponse)
            }
            
            let responseType = responseType(statusCode: response.statusCode)
            
            switch responseType {
            case .informational, .redirection, .serverError, .unknown:
                print("DEBUG: Server Error")
                return .failure(.serverError)
            case  .clientError:
                print("DEBUG: Response Error")
                return .failure(.badRequestError)
            case .success:
                let decodedJSON = try JSONDecoder().decode(PlacesResponseModel.self, from: data)
                return .success(decodedJSON)
            }
            
        } catch {
            print("DEBUG: Error fetching data: \(error.localizedDescription)")
            return .failure(.badRequestError)
        }
    }
    
    private func responseType(statusCode: Int) -> ResponseType {
        switch statusCode {
        case 100...199:
            print("DEBUG: Informational Response")
            return .informational
        case 200...299:
            print("DEBUG: OK")
            return .success
        case 300...399:
            print("DEBUG: Redirection")
            return .redirection
        case 400...499:
            print("DEBUG: Bad Request")
            return .clientError
        case 500...599:
            print("DEBUG: Server Error")
            return .serverError
        default:
            print("DEBUG: Unknown Response")
            return .unknown
        }
    }
    
    private func createURL(latitude: Double, longitude: Double, keyword: String) -> URL?{
        var urlComponents = URLComponents(string: baseURL)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "location", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "rankby", value: "distance"),
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "key", value: googlePlacesKey)
        ]
        urlComponents?.queryItems = queryItems
        return urlComponents?.url
    }
}


//guard let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] else {
//    print("Error: Cannot get JSON data")
//    return
//}
//print(json)
