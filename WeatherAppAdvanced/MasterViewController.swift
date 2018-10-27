//
//  MasterViewController.swift
//  WeatherAppAdvanced
//
//  Created by Iza on 27.10.2018.
//  Copyright © 2018 Sebastian S. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var forecasts = [[WeatherData]]()
    private let weatherFetcher = WeatherFetcher()
    let dispatchGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        populateInitialCities()
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc
    func insertNewObject(_ sender: Any) {
        var newForecast : [WeatherData] = []
        dispatchGroup.enter()
        weatherFetcher.fetchWeather(lat: "37.983810",lon: "23.727539") { [weak self] (data:[WeatherData]) in
            newForecast = data
            self?.dispatchGroup.leave()
        }

        forecasts.insert(newForecast, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = forecasts[indexPath.row]
                let uiNav = segue.destination as! UINavigationController
                let controller = uiNav.topViewController as! DetailViewController
                //controller.detailDescriptionLabel.text = object.first?.city
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell //let cell = Bundle.main.loadNibNamed("Cell", owner: self, options: nil)?.first as! TableViewCell
        let object = forecasts[indexPath.row]
        cell.city.text = object[0].city
        cell.temperature.text = "\(object[0].temperatureHigh)"
        cell.icon.image = UIImage(named: object[0].icon)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            forecasts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func populateInitialCities() {
        dispatchGroup.enter()
        weatherFetcher.fetchWeather(lat: "52.237049",lon: "21.017532") { [weak self] (data:[WeatherData]) in
            // Warsaw
            self?.forecasts.append(data)
            self?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        weatherFetcher.fetchWeather(lat: "48.864716",lon: "2.349014") { [weak self] (data:[WeatherData]) in
            // Berlin
            self?.forecasts.append(data)
            self?.dispatchGroup.leave()
        }
        dispatchGroup.enter()
        weatherFetcher.fetchWeather(lat: "37.983810",lon: "23.727539") { [weak self] (data:[WeatherData]) in
            // Athens
            self?.forecasts.append(data)
            self?.dispatchGroup.leave()
        }
        
    }

}

