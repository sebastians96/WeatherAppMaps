//
//  MapViewController.swift
//  WeatherAppMaps
//
//  Created by Iza on 06.11.2018.
//  Copyright © 2018 Sebastian S. All rights reserved.
//

import Foundation
import MapKit
import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var latitude: String = ""
    var longtitude: String = ""
    
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setLocation(name: String)
    {
        dispatchGroup.enter()
        NameFetcher.fetchName(city: name) { [weak self] (data:[NameLocation]) in
            self?.latitude = data[0].latt
            self?.longtitude = data[0].long
            self?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){
            let coordinates = CLLocationCoordinate2D(latitude: Double(self.latitude)!, longitude: Double(self.longtitude)!)
            self.mapView.setCenter(coordinates, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            self.mapView.addAnnotation(annotation)
        }
    }
    
}
