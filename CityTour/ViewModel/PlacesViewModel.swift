//
//  PlacesViewModel.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import Foundation
import CoreLocation

//1. CoreLocation Manager
//2. Ask user for permission
//3. CoreLocation delegate

@MainActor
class PlacesViewModel: NSObject, ObservableObject {
    
    private let apiClient = APIClient()
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    @Published var selectedKeyword: Keyword = .cafe
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var hasError: Bool = false
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchPlaces(location: CLLocation) async {
        isLoading = true
        print("DEBUG: latitude \(location.coordinate.latitude), longitude \(location.coordinate.longitude)")
        let result = await apiClient.getPlaces(forKeyword: self.selectedKeyword.apiName, location: location)
        isLoading = false
        switch result {
        case .success(let placesResponseModel):
            self.places = placesResponseModel.results.compactMap({Place(place: $0)}) //compactMap rule out nil
        case .failure(let error):
            hasError = true
            switch error {
            case .invalidURL, .invalidResponse, .badRequestError:
                alertTitle = "Something gone wrong"
                alertMessage = "We apologies please try again later"
            case .serverError:
                alertTitle = "Something gone wrong"
                alertMessage = "Please check your Internet connection or please try again later"
            }
        }
    }
}

extension PlacesViewModel: CLLocationManagerDelegate {
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            Task { @MainActor in
                hasError = true
                alertTitle = "Location Services Disabled"
                alertMessage = "Please enable location services in your device settings."
            }
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            Task { @MainActor in
                hasError = true
                alertTitle = "Location Services Disabled"
                alertMessage = "Please enable location services in your device settings."
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        Task { @MainActor in
            self.currentLocation = location
            await fetchPlaces(location: location)
        }
    }
}
