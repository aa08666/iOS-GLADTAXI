//
//  MapSearchViewController.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 LIN,BO-CHENG on 2019/4/16.
//  Copyright © 2019 柏呈. LIN,BO-CHENG All rights reserved.
//

import UIKit
import GoogleMaps


class MapSearchViewController: UIViewController {
    
    @IBOutlet weak var mapCenterPinImage: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
    
    private let  locationManager = CLLocationManager()
    var lmanger = LManger()
    private let searchRadius: Double = 1000
    
    var currentLocation: CLLocation?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//      locationManager.delegate = self
        lmanger.config(vc: self)
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
    }
    
    
    
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = GMSGeocoder()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            self.addressLabel.unlock()
            
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            self.addressLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            
            self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,
                                                bottom: labelHeight, right: 0)
            
            UIView.animate(withDuration: 0.25) {
                self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
}

class LManger: CLLocationManager {
    weak var vc: MapSearchViewController!
    func config(vc: MapSearchViewController) {
        self.delegate = self
        self.vc = vc
    }
}

//extension MapSearchViewController: CLLocationManagerDelegate {
extension LManger: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        startUpdatingLocation()
        vc.mapView.isMyLocationEnabled = true
        vc.mapView.settings.myLocationButton = true
//        locationManager.startUpdatingLocation()
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        vc.mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        self.stopUpdatingLocation()
//        locationManager.stopUpdatingLocation()
        
    }
}


extension MapSearchViewController: GMSMapViewDelegate {
    
    // This method is called each time the map stops moving and settles in a new position, where you then make a call to reverse geocode the new position and update the addressLabel‘s text.
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        reverseGeocodeCoordinate(position.target)
    }
    
    // This method is called every time the map starts to move. It receives a Bool that tells you if the movement originated from a user gesture, such as scrolling the map, or if the movement originated from code. You call the lock() on the addressLabel to give it a loading animation.
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
        
        if (gesture) {
            mapCenterPinImage.fadeIn(0.25)
            mapView.selectedMarker = nil
        }
    }
    
}

