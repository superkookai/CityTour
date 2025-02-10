//
//  PlacesView.swift
//  CityTour
//
//  Created by Weerawut Chaiyasomboon on 10/2/2568 BE.
//

import SwiftUI

struct PlacesView: View {
    @StateObject private var vm = PlacesViewModel()
    @State private var selectedPlace: Place?
    
    private var HorizontalList: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(Keyword.allCases) { keyword in
                    Button {
                        vm.selectedKeyword = keyword
                    } label: {
                        Text(keyword.title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(vm.selectedKeyword == keyword ? Color.gray : .black)
                            .padding(.horizontal,10)
                    }
                    .scaleEffect(vm.selectedKeyword == keyword ? 0.85 : 1.0)
                }
            }
            .frame(height: 50)
        }
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                HorizontalList
                
                List(vm.places, selection: $selectedPlace) { place in
                    NavigationLink(value: place) {
                        PlaceRowView(place: place)
                    }
                }
                .listStyle(.plain)
                .navigationDestination(item: $selectedPlace) { place in
                    PlaceDetailView(place: place)
                }
                .navigationTitle("City Tour")
            }
            
            if vm.isLoading {
                Color.black.opacity(0.2).ignoresSafeArea()
                
                ProgressView()
                    .imageScale(.large)
                    .foregroundStyle(.white)
            }
        }
        .onChange(of: vm.selectedKeyword) {
            Task {
                guard let currentLocation = vm.currentLocation else { return }
                await vm.fetchPlaces(location: currentLocation)
            }
        }
        .alert(vm.alertTitle, isPresented: $vm.hasError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.alertMessage)
        }

        
    }
    
    private func PlaceRowView(place: Place) -> some View {
         HStack {
            AsyncImage(url: place.photoURL) { image in
                image
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
            }
            
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.system(size: 15, weight: .semibold))
                Text(place.address)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("\(Int(place.rating))")
                    .font(.system(size: 14))
            }
        }
    }
    
    private func PlaceDetailView(place: Place) -> some View {
        VStack {
            AsyncImage(url: place.photoURL) { image in
                image
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(.circle)
            } placeholder: {
                ProgressView()
            }
            
            HStack {
                Text(place.name)
                    .font(.system(size: 30, weight: .bold))
                
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("\(Int(place.rating))")
                    .font(.system(size: 14))
            }
            
            Text(place.address)
                .font(.system(size: 20))
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PlacesView()
}

