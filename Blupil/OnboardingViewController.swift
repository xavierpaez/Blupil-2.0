//
//  OnboardingViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 8/14/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate
{
 
 
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var onboardingView: OnboardingView!
    
    let firstBackground = UIColor(red: 71/255, green: 136/255, blue: 199/255, alpha: 1)
    let secondBackground = UIColor(red: 71/255, green: 136/255, blue: 199/255, alpha: 1)
    let thirdBackground = UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
    }
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
       
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
            })
        }
    }
    
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    @IBAction func gotStarted(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "onboardingComplete")
        
        userDefaults.synchronize()
    }
    
    fileprivate let items = [
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "calendar-icon"),
                           title: "Never miss your PrEP!",
                           description: "In the main calendar tap the days you take your pill and also set your everyday reminder to get notified!",
                           pageIcon: UIImage(),
                           color: UIColor(red: 71/255, green: 136/255, blue: 199/255, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "pill"),
                           title: "Keep track of your refill",
                           description: "Set the day you start your prescription, keep track of remaining pills, and how many you've missed.",
                           pageIcon: UIImage(),
                           color: UIColor(red: 71/255, green: 136/255, blue: 199/255, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "book"),
                           title: "External Resources",
                           description: "All local stores are categorized for your convenience",
                           pageIcon: UIImage(),
                           color: UIColor(red: 217/255, green: 72/255, blue: 89/255, alpha: 1),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        ]
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
}

extension OnboardingViewController {
    private static let titleFont = UIFont(name: "AvenirNext-Bold", size: 24) ?? UIFont.boldSystemFont(ofSize: 36.0)
    private static let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18) ?? UIFont.systemFont(ofSize: 14.0)
}

