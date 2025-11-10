//
//  MKMapView+SwiftUI.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 10.11.2025.
//

import MapKit
import SwiftUI

extension MKMapView {
    
    func center(to location: CLLocation, animated: Bool) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: .init(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        setRegion(region, animated: animated)
    }
    
}

struct MKMapViewWrapper: UIViewRepresentable {
    
    var location: CLLocation
    
    var onLocationChange: ((CLLocation) -> Void)?
    
    final class Coordinator: NSObject {
        var parent: MKMapViewWrapper
        
        init(parent: MKMapViewWrapper) {
            self.parent = parent
        }
    }

    func makeUIView(context: Context) -> MKMapView {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.addAnnotation(annotation)
        mapView.center(to: location, animated: true)
        return mapView
    }
        
    func updateUIView(_ mapView: MKMapView, context: Context) {}
        
    func makeCoordinator() -> Coordinator {
            return Coordinator(parent: self)
    }

}

extension MKMapViewWrapper.Coordinator: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "weather.forecast.annotation.view"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        } else {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.isDraggable = true
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 didChange newState: MKAnnotationView.DragState,
                 fromOldState oldState: MKAnnotationView.DragState)
    {
        guard newState == .ending, let coordinate = view.annotation?.coordinate else { return }
        let newLocation: CLLocation = .init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        parent.location = newLocation
        parent.onLocationChange?(newLocation)
    }

}
