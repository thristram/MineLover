//
//  SettingsAboutViewController.swift
//  Seraph
//
//  Created by Fangchen Li on 9/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class SettingsAboutViewController: UIViewController,  MIBlurPopupDelegate {
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var versionBuildNo: UILabel!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    
    var popupView: UIView {
        return self.content
    }
    var blurEffectStyle: UIBlurEffectStyle {
        return .dark
    }
    var initialScaleAmmount: CGFloat {
        return 0.8
    }
    var animationDuration: TimeInterval {
        return TimeInterval(1)
    }
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        self.versionBuildNo.text = "v\(version) Build \(build)"
        self.bottomSpace.constant = CGFloat(MinesLover.UIElements["menuBottomHeight"]!) + 10
        
    }
    
   
    
    
}

