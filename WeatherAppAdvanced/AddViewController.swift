//
//  AddViewController.swift
//  WeatherAppAdvanced
//
//  Created by Iza on 28.10.2018.
//  Copyright © 2018 Sebastian S. All rights reserved.
//

import UIKit

protocol AddForecast {
    func addNew(latitude: String, longtitude: String)
}

class AddViewController: UIViewController {

    var delegate: AddForecast!
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longtitude: UITextField!
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        if latitude != nil && longtitude != nil {
            let lat = latitude.text!
            let lon = longtitude.text!
            delegate.addNew(latitude: lat,longtitude: lon)
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
