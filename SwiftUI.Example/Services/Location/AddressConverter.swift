//
//  AddressConverter.swift
//  SwiftUI.Example
//
//  Created by Alexander Pozakshin on 09.11.2025.
//

import CoreLocation
import Contacts

protocol IPlacemarkConverter {
    func address(from placemarks: [CLPlacemark]) -> String
}

struct PostalAddressConverter: IPlacemarkConverter {
    func address(from placemarks: [CLPlacemark]) -> String {
        guard let placemark = placemarks.first else {
            return ""
        }
        guard let postalAddress = placemark.postalAddress else {
            return ""
        }
        let formatter = CNPostalAddressFormatter()
        return formatter
            .string(from: postalAddress)
            .replacingOccurrences(of: "\n", with: ", ")
    }
}
