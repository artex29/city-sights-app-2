//
//  ContentModel.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/23/22.
//

import Foundation
import CoreLocation

class ContentModel: NSObject, ObservableObject, CLLocationManagerDelegate  {
    
    var locationManager = CLLocationManager()
    @Published var authorizationState = CLAuthorizationStatus.notDetermined
    @Published var restaurants = [Business]()
    @Published var sights = [Business]()
    
    override init() {
        
        // Init method of NSObject
        super.init()
        
        // Set ContentModel as the delegate of the location manager
        
        locationManager.delegate = self
        
        // Request permision from the user
        locationManager.requestWhenInUseAuthorization()
 
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // Update the authorizationState property
        authorizationState = locationManager.authorizationStatus
        
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
            // we have permission
            
            // Start geo locating the user after we get permission
            
            locationManager.startUpdatingLocation()
            
        }
        else if locationManager.authorizationStatus == .denied {
            // We don't have permission
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Gives us the location of the user
        
        let userLocation = locations.first
        
        if userLocation != nil{
            
            // We have a location
            // Stop requesting the location after we get it once
            locationManager.stopUpdatingLocation()
            
            // If we have the coordinates of the user, send into Yelp API
            
            getBusinesses(category: Constants.sightsKey, location: userLocation!)
            getBusinesses(category: Constants.restaurantsKey, location: userLocation!)
        }

    }
    
    // MARK: - Yelp API Methods
    
    func getBusinesses(category: String, location: CLLocation) {
        
        // Esta es la forma que se uso anteriormente en otros proyectos pero usaremos una nueva
        
//        let urlString = "https://api.yelp.com/v3/businesses/search?latitude=\(location.coordinate.latitude)&longitude=\(location.coordinate.longitude)&categories=\(category)&limit=6"
//
//        let url = URL(string: urlString)
        
        // Create URL
        var urlComponents = URLComponents(string: Constants.apiUrl)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.coordinate.latitude)),
            URLQueryItem(name: "longitude", value: String(location.coordinate.longitude)),
            URLQueryItem(name: "categories", value: category),
            URLQueryItem(name: "limit", value: "6")
        
        ]
        
        let url = urlComponents?.url
        
        if let url = url {
            
            // Create URL request
            var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10.0)
            
            
            request.httpMethod = "GET" // el tipo de request lo determina el deuno de la api. En este caso se usa "GET" lo cual determina que se esta requiriendo traer la data a nuestra aplicacion
            
            // las instrucciones de como hacer el request para la autorizacion necesaria para yelp podemos encontrarlas en este link: https://www.yelp.com/developers/documentation/v3/authentication
            request.addValue("Bearer \(Constants.apikey)", forHTTPHeaderField: "Authorization")
            
            // Get URL Session
            let session = URLSession.shared
            
            // Create Data Task
            let dataTask = session.dataTask(with: request) { data, response , error in
                // Check that there isn't an error
                if error == nil {
                    
                    // Parse Json
                    do {
                    let decoder = JSONDecoder()
                        let result = try decoder.decode(BusinessSearch.self, from: data!)
                        
                        // Sort Businesses
                        var businesses = result.businesses
                        businesses.sort { b1, b2 in
                            return b1.distance ?? 0 < b2.distance ?? 0
                        }
                        
                        // Call the get image function of the business
                        
                        for b in result.businesses {
                            b.getImageData()
                        }
                        DispatchQueue.main.async {
                            // Assign result to the appropiate properties

                            switch category {
                            case Constants.sightsKey:
                                self.sights = businesses
                            case Constants.restaurantsKey:
                                self.restaurants = businesses
                            default:
                                break
                            }
                        }
                        
                    }
                    catch {
                        
                        print(error)
                    }
                }
                
            }
            
            // Start the data task
            dataTask.resume()
        }
  
    }
}
