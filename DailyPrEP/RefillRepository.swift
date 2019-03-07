//
//  File.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 7/18/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation
import CoreData

class RefillRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveChanges() {
        try? context.save()
    }
    
//    func find(date: Date) -> Record? {
//        let fetchRequest: NSFetchRequest<Record> = Record.fetchRequest()
////        fetchRequest.predicate = makeDayPredicate(date: date)
//        
//        if let records = try? context.fetch(fetchRequest) {
//            return records.first
//        }
//        return nil
//    }
//    
//    func create(date: Date) -> Refills {
//        let refills = Refills(context: context)
//        refills.currentPrescriptionStartDate = date as NSDate
//    }
//    
//    func create(date: Date, isTaken: Bool) -> Record {
//        let record = Record(context: context)
//        record.date = date
//        record.taken = isTaken
//        return record
//    }
//
    
}
