//
//  NameFetcher.swift
//  WeatherAppAdvanced
//
//  Created by Student on 30.10.2561 BE.
//  Copyright © 2561 BE Sebastian S. All rights reserved.
//

import Foundation

struct NameLocation {
    var title = ""
    var latt = ""
    var long = ""
    }

class NameFetcher {
    
    static func fetchName (city: String,completion: @escaping ((_ data: [NameLocation])-> Void)){
        var locationList : [NameLocation] = []
        let  apiURL = URL(string: "https://www.metaweather.com/api/location/search/?query=" + city)
        let session = URLSession.shared
        let task = session.dataTask(with: apiURL!){ (data, _, error) in
            if let error = error {
                print("Request Did Fail (\(error)")
            }
            else
            {
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                for element in json {
                    var record: NameLocation = NameLocation()
                    var data = element as! [String: Any]
                    record.title = data["title"] as! String
                    let latt_long = data["latt_long"] as! String
                    let delimiter = ","
                    var coordinates = latt_long.components(separatedBy: delimiter)
                    record.latt = coordinates[0]
                    record.long = coordinates[1]
                    locationList.append(record)
                }
                completion(locationList)
            }
        }
        task.resume()
    }
    
}
