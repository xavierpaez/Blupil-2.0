//
//  SettingsDataManager.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 8/1/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation

class SettingsDataManager {
    
    func getSections() -> [String] {
        return ["About", "Settings", "Help us"]
    }
    
    func getExternalResources() -> [[Resource]] {
        
        var resources = [[Resource]]()
        let aboutResources: [Resource] = [
            Resource(title: "Help", subtitle: "", url: URL(string: "http://xavierpaez.com/dailyprep/help/")!),
            Resource(title: "Privacy", subtitle: "", url: URL(string: "http://xavierpaez.com/dailyprep/")!),
            Resource(title: "Terms of Use", subtitle: "", url: URL(string: "http://xavierpaez.com/dailyprep/termsofuse/")!)
        ]
        
        resources.append(aboutResources)
        
        return resources
    }
}
    
