//
//  GemViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class GemViewController: UIViewController {
    
    
    var pageTitle: String = ""
    var pageDescription: String = ""
    var isCountDown:Bool = false

    ////////////////////////////////
    ////////GEMVIEW ELEMENTS////////
    ////////////////////////////////
    
    @IBOutlet weak var gemView: UIView!
    @IBOutlet weak var gemImage: UIImageView!
    @IBOutlet weak var gemTitle: UILabel!
    @IBOutlet weak var gemDescription: UILabel!
    @IBOutlet weak var coinGemViewLabel: UILabel!
    @IBOutlet weak var gemGemViewLabel: UILabel!
    @IBOutlet weak var resumeGemViewButton: UIButton!

    @IBAction func resumeGemViewPressed(_ sender: Any) {
        self.hideGemView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //GEM View
        self.resumeGemViewButton.layer.borderColor = UIColor.white.cgColor
        self.gemTitle.text = self.pageTitle
        self.gemDescription.text = self.pageDescription
        self.gemGemViewLabel.text = "\(MinesLover.Gems)"
        self.coinGemViewLabel.text = "\(MinesLover.Coins)"
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isCountDown{
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
                
                
            });
        }
        /*
        let when = DispatchTime.now();
        DispatchQueue.main.asyncAfter(deadline: when + 1) {
            
            
        }
 */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideGemView(){
        self.dismiss(animated: false, completion: nil)
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
