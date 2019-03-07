//
//  LocationSearchViewController.swift
//  DailyPrEP
//
//  Created by Xavi Paez on 3/7/19.
//  Copyright © 2019 XavierPaez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LocationSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    let CDC_API_URL = "https://npin.cdc.gov/api/organization/proximity"
    var locations = [Location]()
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var url = "\(CDC_API_URL)?prox[origin]=\(searchText)"
            print(url)
            locations.removeAll()
            getLocationsData(url: url)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        
        let location =  locations[indexPath.row]
        cell.textLabel?.text = location.title
        cell.detailTextLabel?.text = location.street
        
        return cell
    }

    func getLocationsData(url : String) {
        AF.request(url, method: .get)
            .responseJSON {
                response in if response.result.isSuccess {
                    let locationJSON : JSON = JSON(response.result.value!)
                    self.updateLocationData(json: locationJSON)
                  
                } else {
                    
                }
        }

    }
    
    func updateLocationData(json : JSON){
        for (_, object) in json {
            let titleField = object["title_field"].stringValue
            let street = object["field_org_street1"].stringValue
            let phone = object["field_org_phone"].stringValue
            var location = Location(title: titleField, street: street, phone: phone)
            locations.append(location)
        }
        
        locationsTableView.reloadData()
        
    }
    func updateTableViewUI(location : String){
        
    }
}
