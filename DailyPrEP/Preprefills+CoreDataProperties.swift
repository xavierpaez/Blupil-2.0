//
//  Preprefills+CoreDataProperties.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 7/18/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation
import CoreData


extension Refills {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Refills> {
        return NSFetchRequest<Refills>(entityName: "Refills")
    }

    @NSManaged public var remaining: Int32
    @NSManaged public var currentPrescriptionStartDate: NSDate?
    @NSManaged public var nextRefill: Int32

}
