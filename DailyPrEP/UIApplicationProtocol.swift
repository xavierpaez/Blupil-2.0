//
//  UIApplicationProtocol.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 8/14/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit

protocol UIApplicationProtocol {
    var keyWindow: UIWindow? { get }
    func canOpenURL(_ url: URL) -> Bool
    func open(_ url: URL, options: [String : Any], completionHandler completion: ((Bool) -> Swift.Void)?)
}

extension UIApplication: UIApplicationProtocol {}
