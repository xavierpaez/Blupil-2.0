//
//  MainPillViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 7/25/18.
//  Copyright © 2018 XavierPaez. All rights reserved.
//

import UIKit

class MainPillViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "blupil")
        let imageView = NavigationImageView(image: logo)
        
        self.navigationItem.titleView = imageView
        imageView.contentMode = .scaleAspectFit  // s
        imageView.sizeToFit()
        
        let width: CGFloat = self.view.frame.size.width
        let height: CGFloat = self.view.frame.size.height-200
        
        
        let demoView = PillView(frame: CGRect(x: self.view.frame.size.width/2 - width/2,
                                              y: self.view.frame.size.height/2 - height/2,
            width: width,
            height: height))
        
        self.view.addSubview(demoView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
