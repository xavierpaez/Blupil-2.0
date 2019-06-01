//
//  RefillCalendarViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 7/13/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit
import Foundation

class RefillCalendarViewController: UIViewController {

 
    @IBOutlet weak var datePicker: UIDatePicker!
    let userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerSetup()
        
    }
    
    func pickerSetup(){
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.maximumDate = Date()
        
        if let date = userDefaults.object(forKey: "LastRefill"){
            datePicker.date = date as! Date
        }
    }
  
    @IBAction func dateSelection(_ sender: UIDatePicker) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(datePicker.date, forKey: "LastRefill")
        print(datePicker.date)
        userDefaults.synchronize()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        datePicker.date = Date()
    }
}



