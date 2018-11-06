//
//  AddViewController.swift
//  WeatherAppAdvanced
//
//  Created by Iza on 28.10.2018.
//  Copyright © 2018 Sebastian S. All rights reserved.
//

import UIKit

protocol AddForecast {
    func addNew(latitude: String, longtitude: String, name: String)
}

class AddViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let dispatchGroup = DispatchGroup()
    var delegate: AddForecast!
    var nameLocations = [NameLocation]()
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var latitude = ""
    var longtitude = ""
    private let nameFetcher = NameFetcher()
    
    @IBAction func search(_ sender: UIButton) {
        dispatchGroup.enter()
        nameFetcher.fetchName(city: self.city.text!) { [weak self] (data:[NameLocation]) in
            self?.nameLocations = data
            self?.dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.delegate = self
        //tableView.dataSource = self
        // Do any additional setup after loading the view.
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
}

