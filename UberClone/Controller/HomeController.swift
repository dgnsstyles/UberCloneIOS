//
//  HomeController.swift
//  UberClone
//
//  Created by David Goren on 17-09-23.
//
import Firebase
import FirebaseAuth
import MapKit
import UIKit

class HomeController: UIViewController, CLLocationManagerDelegate {
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        enableLocationsServices()
    }
    
    func configureUI(){
        view.addSubview(mapView)
        
    }
    func configureMapView() {
        mapView.frame = view.frame
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                if #available(iOS 13.0, *) {
                    nav.isModalInPresentation = true
                }
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        } else {
            configureUI()
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error al deslogearse")
        }
    }
    
}

extension HomeController {
    
    func enableLocationsServices() {
        locationManager?.delegate = self
        switch CLLocationManager.authorizationStatus() {
            
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Auth ")
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        @unknown default:
            break
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager?.requestAlwaysAuthorization()
        }
    }
}
