//
//  PowerUpCollectionViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class PowerUpCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var powerUpView: UIView!
    @IBOutlet weak var powerUpContentView: UIView!
    @IBOutlet weak var powerUpImage: UIImageView!
    @IBOutlet weak var powerUpTitle: UILabel!
    @IBOutlet weak var powerUpDescription: UILabel!
    
    @IBOutlet weak var powerUpProgressBar: UIView!
    @IBOutlet weak var powerUpProgressBar_1: UIView!
    @IBOutlet weak var powerUpProgressBar_2: UIView!
    @IBOutlet weak var powerUpProgressBar_3: UIView!
    @IBOutlet weak var powerUpProgressBar_4: UIView!
    @IBOutlet weak var powerUpProgressBar_5: UIView!
    
    @IBOutlet weak var powerUpLock: UIImageView!
    @IBOutlet weak var powerUpStatus: UILabel!
    
    @IBOutlet weak var powerUpImageVerticalAlign: NSLayoutConstraint!
    var progressBarsElements: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.powerUpView.layer.cornerRadius = 8
        self.powerUpView.clipsToBounds = true
        self.powerUpView.backgroundColor = UIColor(hex: 0xFFFFFF, alpha: 0.06)
        self.progressBarsElements = [self.powerUpProgressBar_1, self.powerUpProgressBar_2, self.powerUpProgressBar_3, self.powerUpProgressBar_4, self.powerUpProgressBar_5]
        // Initialization code
    }
    
    func displayProgressBar(number: Int){
        for i in 1...5{
            if (number - i) > -1 {
                //self.progressBarsElements[i-1].isHidden = false
                self.progressBarsElements[i-1].backgroundColor = UIColor.seraphDarkPurple
            }   else{
//                self.progressBarsElements[i-1].isHidden = true
                self.progressBarsElements[i-1].backgroundColor = UIColor.seraphLightWhite
            }
        }


    }
    
    enum cellStatus: Int{
        case enable
        case disable
        case lock
    }
    
    func changeCellStatus(status: cellStatus){
        switch status{
        case .enable:
            self.powerUpContentView.alpha = 1
            self.powerUpLock.isHidden = true
            break
        case .disable:
            self.powerUpContentView.alpha = 0.5
            self.powerUpLock.isHidden = true
            break
        case .lock:
            self.powerUpContentView.alpha = 0.5
            self.powerUpLock.isHidden = false
            break
        }
    }
    
    func constructCell(powerUp: PowerUp){
        self.powerUpImageVerticalAlign.constant = -51
        self.powerUpTitle.text = powerUp.name
        self.powerUpImage.image = UIImage(named: powerUp.shortCode)
        self.powerUpDescription.text = powerUp.getDescription()
        self.displayProgressBar(number: powerUp.remainingPass)
        
        if powerUp.currentLevel == 0{
            self.powerUpStatus.isHidden = false
            self.powerUpStatus.text = "NEED UNLOCK"
            self.changeCellStatus(status: .lock)
        }   else if powerUp.powerUpUsed   {
            self.powerUpStatus.isHidden = false
            self.powerUpStatus.text = "POWER UP USED"
            self.changeCellStatus(status: .disable)
        }   else if MinesLover.powerUpMode != .none {
            if MinesLover.powerUpMode == powerUp.type {
                self.powerUpStatus.isHidden = false
                self.powerUpStatus.text = "POWER UP IN-USE"
                self.changeCellStatus(status: .disable)
            }   else    {
                self.powerUpStatus.isHidden = false
                self.powerUpStatus.text = "OTHER POWER UP IN-USE"
                self.changeCellStatus(status: .disable)
            }
        }   else    {
            if powerUp.remainingPass == 0{
                self.powerUpStatus.isHidden = false
                self.powerUpStatus.text = "NO PASSES LEFT"
                self.changeCellStatus(status: .disable)
            }   else    {
                self.powerUpStatus.isHidden = true
                self.changeCellStatus(status: .enable)
            }
        }
        
        
        
    }

}
