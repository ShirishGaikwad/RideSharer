//
//  ViewController.swift
//  RideSharer
//
//  Created by shirish gayakawad on 07/03/24.
//

import UIKit
import MapKit
import CoreLocation

class RideHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapView: MKMapView!
    
    let rideHistory: [(String, Double)] = [("Ride 1", 20.0), ("Ride 2", 25.0), ("Ride 3", 18.0)] // Example ride history data
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Set up location manager
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
                // Set up map view
                mapView.showsUserLocation = true
                mapView.delegate = self
        // Register cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "rideCell")
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rideHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideCell", for: indexPath)
        let ride = rideHistory[indexPath.row]
        cell.textLabel?.text = ride.0
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ride = rideHistory[indexPath.row]
        let priceAlert = UIAlertController(title: "Price", message: "Price for \(ride.0) ride: $\(ride.1)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        priceAlert.addAction(okAction)
        
        present(priceAlert, animated: true, completion: nil)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // MARK: - CLLocationManagerDelegate
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let location = locations.last else { return }
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Location manager failed with error: \(error.localizedDescription)")
            // You can handle the error here, such as displaying an alert to the user
        }
        
        // MARK: - Handle Authorization Status Changes
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            case .denied, .restricted:
                print("Location access denied")
                // Show an alert informing the user that location access is denied
                showAlert(title: "Location Access Denied", message: "Please allow access to your location in Settings.")
            default:
                break
            }
        }
        
        // MARK: - Helper Methods
        
        func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

//    extension ViewController: MKMapViewDelegate {
//        // Optionally, you can implement map view delegate methods here
//    }
