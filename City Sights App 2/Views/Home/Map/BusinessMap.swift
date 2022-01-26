//
//  BusinessMap.swift
//  City Sights App 2
//
//  Created by ANGEL RAMIREZ on 1/25/22.
//

import SwiftUI
import MapKit

struct BusinessMap: UIViewRepresentable {
    
    @EnvironmentObject var model:ContentModel
    
    var locations:[MKPointAnnotation] {
        
        var annotations = [MKPointAnnotation]()
        
        // Create a set of annotations from our list of businesses
        
        for business in model.restaurants + model.sights{
            
            // If the business has a latitue and longitude, create an MKPointAnnotation
            
            if let lat = business.coordinates?.latitude, let long = business.coordinates?.longitude {
                
                // Create a new annotation
                let a = MKPointAnnotation()
                a.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                a.title = business.name ?? ""
                
                annotations.append(a)
                
            }
           
        }
        return annotations
    }
    
    func makeUIView(context: Context) ->  MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Make the user show up on the map
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        
       
        
        return mapView
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        // Remove all the annotations
        uiView.removeAnnotations(uiView.annotations)
        
        // Add the ones based on the business
        uiView.showAnnotations(self.locations, animated: true)
        
    }
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        
        uiView.removeAnnotations(uiView.annotations)
    }
    
    // MARK: Coordinator Class
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // if the annotation is the user blue dot, return nil
            if annotation is MKUserLocation {
                return nil
            }
            
            // Check if there's a reausable annotation view first
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.annotationReuseId)
            
            if annotationView == nil {
                
                // Create a new one
                 annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: Constants.annotationReuseId)
                
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
            }
            else {
                // we got a reusable one
                
                annotationView?.annotation = annotation
            }

            
            // return it
            return annotationView
        }

        
    }
}
