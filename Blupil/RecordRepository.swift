//
//  RecordRepository.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 7/10/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation
import CoreData

class RecordRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveChanges() {
        try? context.save()
    }
    
    func dateToCurrentDayRecords(date: Date, isTaken: Bool) -> [Record] {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.predicate = dateToCurrentDay(date: date, isTaken: isTaken)
        return (try? context.fetch(request)) ?? []

    }

    func findTakenRecords() -> [Record] {
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.predicate = takenRecordsPredicate()
        return (try? context.fetch(request)) ?? []
    }
    
    private func takenRecordsPredicate() -> NSPredicate {
        return NSPredicate(format: "taken = true")
    }
    
    func find(date: Date) -> Record? {
        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
        fetchRequest.predicate = makeDayPredicate(date: date)
        
        if let records = try? context.fetch(fetchRequest) {
            return records.first
        }
        return nil
    }
    
    func create(date: Date, isTaken: Bool) -> Record {
        let record = Record(context: context)
        record.date = date
        record.taken = isTaken
        return record
    }
    
    func upsert(date: Date, isTaken: Bool) -> Record {
        if let record = find(date: date) {
            record.date = date
            record.taken = isTaken
            return record
        }
        
        return create(date: date, isTaken: isTaken)
    }
    
    private func dateToCurrentDay(date: Date, isTaken: Bool) -> NSPredicate {
        print(date.description)
        if isTaken {
             return NSPredicate(format: "date >= %@ AND date =< %@ AND taken = true", argumentArray: [date, Date()])
        } else {
             return NSPredicate(format: "date >= %@ AND date =< %@", argumentArray: [date, Date()])
        }
       
    }
    
    private func makeDayPredicate(date: Date) -> NSPredicate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        return NSPredicate(format: "date >= %@ AND date =< %@ AND taken = true", argumentArray: [startDate!, endDate!])
    }

}
