//
//  Resource.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 3/12/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation

struct Resource {

    var title: String
    var subtitle: String?
    var url: URL?
    
    init(title: String, subtitle: String, url: URL)
    {
        self.title = title
        self.subtitle = subtitle
        self.url = url
    }
    
    init(title: String)
    {
        self.title = title
    }
    
}
