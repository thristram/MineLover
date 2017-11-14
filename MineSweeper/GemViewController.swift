//
//  GemViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class GemViewController: UIViewController {
    

    var openAs: GemViewFunctions = .gemFound
    
    ////////////////////////////////
    ////////GEMVIEW ELEMENTS////////
    ////////////////////////////////
    
    @IBOutlet weak var gemView: UIView!
    @IBOutlet weak var gemImage: SpringImageView!
    @IBOutlet weak var gemTitle: UILabel!
    @IBOutlet weak var gemDescription: UILabel!
    @IBOutlet weak var resumeGemViewButton: UIButton!
    @IBOutlet weak var gemNavBarView: UIView!
    @IBOutlet weak var gemViewTopBarBG: UIView!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    
    @IBAction func resumeGemViewPressed(_ sender: Any) {
        self.hideGemView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GEM View
        self.resumeGemViewButton.layer.borderColor = UIColor.white.cgColor
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)

        switch self.openAs {
        case .creazySweeperCountdown:
            self.gemTitle.text = "READY?"
            self.gemDescription.text = "You may click anywhere\nmarked in blue!"
            self.gemImage.image = UIImage(named: "number_3")
            self.resumeGemViewButton.isHidden = true
            self.gemNavBarView.isHidden = true
            break
        case .gemFound:
            self.gemTitle.text = "You got a GEM!"
            self.gemDescription.text = "You may use the GEM to purchase Power-Ups\nor Upgrade Power-Ups"
            self.resumeGemViewButton.isHidden = false
            self.gemNavBarView.isHidden = false
            self.resumeGemViewButton.setTitle("RESUME", for: .normal)
            self.gemImage.image = UIImage(named: "gem")
            self.gemImage.animation = "FadeIn"
            self.gemImage.scaleX = 0.2
            self.gemImage.scaleY = 0.2
            self.gemImage.damping = 0.3
            self.gemViewTopBarBG.isHidden = false
            break
        case .multiplerMatch:
            break
//        default:
//            self.gemTitle.text = self.pageTitle
//            self.gemDescription.text = self.pageDescription
//            break
        }
       
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch self.openAs {
        case .creazySweeperCountdown:
            self.countDownAnimation()
            break
        case .gemFound:
            self.gemImage.animate()
            let when = DispatchTime.now()
            DispatchQueue.main.asyncAfter(deadline: when + 1) {
                self.hideGemView()
            }
            break
        case .multiplerMatch:
            break
        }

    }
    
    func countDownAnimation(){
        UIView.animate(withDuration: 0.5, animations: {
            self.gemView.alpha = 1.0
        }, completion: { (finished: Bool) in
            let when = DispatchTime.now();
            DispatchQueue.main.asyncAfter(deadline: when + 1) {
                self.gemImage.image = UIImage(named: "number_2")
            }
            DispatchQueue.main.asyncAfter(deadline: when + 2) {
                self.gemImage.image = UIImage(named: "number_1")
            }
            DispatchQueue.main.asyncAfter(deadline: when + 3) {
                self.dismiss(animated: true, completion: nil)
                
            }
            
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideGemView(){
        self.dismiss(animated: true, completion: {
            finish in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil, userInfo: [:])
        })
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
