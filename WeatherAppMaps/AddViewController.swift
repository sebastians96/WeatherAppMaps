//
//  AddViewController.swift
//  WeatherAppAdvanced
//
//  Created by Iza on 28.10.2018.
//  Copyright © 2018 Sebastian S. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AddForecast {
    func addNew(latitude: String, longtitude: String, name: String)
}

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    let dispatchGroup = DispatchGroup()
    var delegate: AddForecast!
    var nameLocations = [NameLocation]()
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var latitude = ""
    var longtitude = ""
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    var geocoder = CLGeocoder()
    var cityName = ""
    
    @IBAction func search(_ sender: UIButton) {
        dispatchGroup.enter()
        NameFetcher.fetchName(city: self.city.text!) { [weak self] (data:[NameLocation]) in
            self?.nameLocations = data
            self?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            manager = CLLocationManager()
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestAlwaysAuthorization()
            manager.requestWhenInUseAuthorization()
        }
        manager.requestLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return nameLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
        let object = nameLocations[indexPath.row]
        cell.textLabel?.text = object.title
        return cell
    }
    
    // MARK: - Segues
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let lat = nameLocations[indexPath.row].latt
            let lon = nameLocations[indexPath.row].long
        delegate.addNew(latitude: lat,longtitude: lon,name: nameLocations[indexPath.row].title)
            navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            let current = manager.location!.coordinate
            var loc = NameLocation()
            loc.latt = String(describing: current.latitude)
            loc.long = String(describing: current.longitude)
            geocoder.reverseGeocodeLocation(manager.location!) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
                loc.title = "Aktualnie znajdujesz się w: " + (placemarks?.first?.locality!)!
                self.nameLocations.append(loc)
                self.tableView.reloadData()
            }
            //print("latt: " + loc.latt + "   long: " + loc.latt)
        
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            cityName = "Unable to Find Address for Location"
            
        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                cityName = placemark.locality!
            } else {
                cityName = "No Matching Addresses Found"
            }
        }
    }
    
}

