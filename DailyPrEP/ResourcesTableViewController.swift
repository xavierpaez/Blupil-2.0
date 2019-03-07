//
//  ResourcesTableViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 3/12/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit

class ResourcesTableViewController: UITableViewController {

    var sections = ResourceDataManager().getSection()
    var resources = ResourceDataManager().getResources()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resources[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resourceCell", for: indexPath)
        let resource = resources[indexPath.section][indexPath.row]
        cell.textLabel?.text = resource.title
        cell.detailTextLabel?.text = resource.subtitle
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as? WebViewController else {
            return
        }
        
        guard let locatorVC = storyboard?.instantiateViewController(withIdentifier: "ResourceLocatorView") as? LocationSearchViewController else {
            return
        }
        
        vc.url = resources[indexPath.section][indexPath.row].url
        vc.title = resources[indexPath.section][indexPath.row].title
        if indexPath.section == 4 {
            self.navigationController?.pushViewController(locatorVC, animated: true)
        } else {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
