//
//  SettingsTableViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 8/14/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    var resources = SettingsDataManager().getExternalResources()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "webViewSegue" ,
                let webView = segue.destination as? WebViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                webView.url = resources[indexPath.section][indexPath.row].url
                webView.title = resources[indexPath.section][indexPath.row].title
            }
    }
    
    @IBAction func cancelToSettingsViewController(_ segue: UIStoryboardSegue) {
    }
}
