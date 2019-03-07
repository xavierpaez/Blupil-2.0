//
//  CalendarExtensions.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 2/19/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        
        let startDate = formatter.date(from: "2018 01 01")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        var calendar = Calendar.current
        calendar.timeZone = .current
        // Make sure you set this up to your time zone. We'll just use default here
        
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: calendar,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .off,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CalendarCellView

        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CalendarCellView", for: indexPath) as! CalendarCellView
        myCustomCell.dayLabel.text = cellState.text
        
        handleCellTextColor(view: myCustomCell, cellState: cellState)
        handleCellSelection(view: myCustomCell, cellState: cellState)
        
        return myCustomCell
    
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
            handleCellSelection(view: cell, cellState: cellState)
            handleCellTextColor(view: cell, cellState: cellState)
            saveSelectedDate(cellState: cellState)
            updateStats()
            self.swallowsSummaryCollectionView.reloadData()
        }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        let currentDate = Date()
        let order = Calendar.current.compare(currentDate, to: date, toGranularity: .day)
        if (order != .orderedAscending){
            return true
        }
        return false
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        let currentDate = Date()
        let order = Calendar.current.compare(currentDate, to: date, toGranularity: .day)
        if (order != .orderedAscending && cellState.isSelected){
            return true
        }
        return false
    }

    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
            let alertController = UIAlertController(title: "DailyPrEP", message: "Are you sure you want to unmark the selected day?", preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
            
        let okAction = UIAlertAction(title: "OK", style: .default) {action in
            self.handleCellSelection(view: cell, cellState: cellState)
            self.handleCellTextColor(view: cell, cellState: cellState)
            self.saveSelectedDate(cellState: cellState)
            self.updateStats()
            self.swallowsSummaryCollectionView.reloadData()
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)

        }

    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.setupViewsOfCalendar(from: visibleDates)
    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}


