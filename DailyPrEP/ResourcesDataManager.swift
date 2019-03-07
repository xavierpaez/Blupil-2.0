//
//  ResourcesDataManager.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 3/12/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import Foundation

class ResourceDataManager {
    
    func getSection() -> [String] {
        return ["PrEP Resources (U.S. Only)", "HIV Resources (U.S. Only)", "PrEP Online Communities", "LGBTQ Community"]
    }
    
    func getResources() -> [[Resource]] {
        
        var resources = [[Resource]]()
        let prepResources: [Resource] = [
            Resource(title: "What is PrEP?", subtitle: "https://www.cdc.gov", url: URL(string: "https://www.cdc.gov/hiv/basics/prep.html")!),
            Resource(title: "The Questions About PrEP", subtitle: "https://men.prepfacts.org", url: URL(string: "https://men.prepfacts.org/the-questions/")!),
            Resource(title: "PrEP Medication Assistance Program", subtitle: "https://www.gilead.com", url: URL(string: "https://www.gileadadvancingaccess.com/?utm_source=TruvadaPREP_DTC&utm_medium=referral")!),
            Resource(title: "Payments Options for PrEP (NY)", subtitle: "https://www.health.ny.gov/", url: URL(string: "https://www.health.ny.gov/diseases/aids/general/prep/docs/payment_options.pdf")!)
            
            
        ]
        
        let hivResources : [Resource] = [
            Resource(title: "HIV Testing Sites & Care Services", subtitle: "https://aids.gov", url: URL(string: "https://locator.hiv.gov")!),
            Resource(title: "Free HIV Test", subtitle: "https://www.freehivtest.net", url: URL(string: "https://www.freehivtest.net")!)]
        
        let communitiesResources : [Resource] = [
            Resource(title: "PrEP Facts: Rethinking HIV Prevention and Sex", subtitle: "https://www.facebook.com/groups/PrEPFacts/", url: URL(string: "https://www.facebook.com/groups/PrEPFacts/")!),
            Resource(title: "Prepster", subtitle: "https://www.facebook.com/prepster.info/", url: URL(string: "https://www.facebook.com/prepster.info/")!)]
        
        let lgbtResources: [Resource] = [
            Resource(title: "Callen Lorde and PrEP", subtitle: "http://callen-lorde.org/prep/", url: URL(string: "http://callen-lorde.org/prep/")!)]

        
        resources.append(prepResources)
        resources.append(hivResources)
        resources.append(communitiesResources)
        resources.append(lgbtResources)
    
        return resources
    }
    
}
