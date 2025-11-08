//
//  AddressConverter.swift
//  Weather Forecast
//
//  Created by Alexander Pozakshin on 26.10.2025.
//

import CoreLocation
import Contacts

protocol IPlacemarkConverter {
    func address(from placemarks: [CLPlacemark]) -> String
}

class PostalAddressConverter: IPlacemarkConverter {
    func address(from placemarks: [CLPlacemark]) -> String {
        guard let placemark = placemarks.first else {
            return ""
        }
        guard let postalAddress = placemark.postalAddress else {
            return ""
        }
        let formatter = CNPostalAddressFormatter()
        return formatter.string(from: postalAddress)
    }
}
