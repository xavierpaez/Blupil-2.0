//
//  Location.swift
//  DailyPrEP
//
//  Created by Xavi Paez on 3/7/19.
//  Copyright © 2019 XavierPaez. All rights reserved.
//

import Foundation

struct Location {
    
    var title: String?
    var street: String?
    var phone: String?
    
    init(title: String, street: String, phone: String)
    {
        self.title = title
        self.street = street
        self.phone = phone
    }
    
}

