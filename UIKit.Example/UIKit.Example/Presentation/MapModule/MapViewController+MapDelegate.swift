//
//  MapViewController+MapDelegate.swift
//  WeatherForecast.UIKitExample
//
//  Created by Alexander Pozakshin on 27.10.2025.
//

import UIKit
import MapKit

extension MKMapView {
    
    func center(to location: CLLocation, animated: Bool) {
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: .init(latitudeDelta: 2.0, longitudeDelta: 2.0)
        )
        setRegion(region, animated: animated)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
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
        viewModel.setNewLocation(.init(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}
