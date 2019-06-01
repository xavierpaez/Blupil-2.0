//
//  RefillsViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 4/16/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit
import Foundation
import CoreData


class RefillsViewController: UIViewController{

    @IBOutlet weak var circularProgressView: KDCircularProgress!
    let userDefaults = UserDefaults.standard
    @IBOutlet weak var pillsLeft: UILabel!
    @IBOutlet weak var missingDays: UILabel!
    @IBOutlet weak var circularMissingView: KDCircularProgress!
    @IBOutlet weak var nextRefill: UILabel!
    let calendar = NSCalendar.current
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStats()
    }
    
    func updateStats(){
        let pillsTaken = getSelectedDateRecord()
        pillsLeft.text = String(30 - pillsTaken)
        circularProgressAngle(pills: pillsTaken)
        missingDaysAngle(pillsTaken: pillsTaken)
        getNextRefillDate()
    }
    
    func circularProgressAngle(pills: Int){
        let angle = (360*30)/30
        circularProgressView.animate(toAngle: Double(angle), duration: 1, completion: nil)
    }
    
    func missingDaysAngle(pillsTaken: Int)
    {
        let refillDate : Date
        if let date = userDefaults.object(forKey: "LastRefill") as? Date {
            refillDate = date
        } else {
            refillDate = Date()
            missingDays.text = "0"
        }
        let date1 = calendar.startOfDay(for: refillDate)
        let date2 = calendar.startOfDay(for: Date())
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        var missingPills = components.day! - pillsTaken
        if missingPills < 0 {
            missingPills = 0
        }
        missingDays.text =  String(missingPills)
        let angle = (360*missingPills)/30
        circularMissingView.animate(toAngle: Double(angle), duration: 1, completion: nil)
    
        
    }
    
    func getSelectedDateRecord() -> Int{
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = makeDayPredicate()
        do {
            return try context.count(for: fetchRequest)
        }
        catch {  }
        return 0
    }
    
    
    func getNextRefillDate(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
 
        
        let refillDate : Date
        if let date = userDefaults.object(forKey: "LastRefill") as? Date {
            refillDate = date
            let components = calendar.date(byAdding: .day, value: 30, to: refillDate)
            nextRefill.text = dateFormatter.string(from: components!)
            
        } else {
            nextRefill.text = "Set current prescription"
            
        }
        
    }
    
    func makeDayPredicate() -> NSPredicate {
        let refillDate : Date
        if let date = calendar.date(byAdding: .day, value: -30, to: Date()){
            refillDate = date
        } else {
            refillDate = Date()
        }
        let endDate = Date()
        return NSPredicate(format: "date >= %@ AND date =< %@ AND taken == YES" , argumentArray: [refillDate, endDate])
    }
    

}
