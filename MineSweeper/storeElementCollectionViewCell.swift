//
//  storeElementCollectionViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/27/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class storeElementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var storeElementView: UIView!
    @IBOutlet weak var storeElementImage: UIImageView!
    @IBOutlet weak var storeElementTitle: UILabel!
    @IBOutlet weak var storeElementDescription: UILabel!
    @IBOutlet weak var storeElementButton: UIButton!
    @IBOutlet weak var storeElementLock: UIImageView!
    
    
    @IBOutlet weak var storeElementBarContainer: UIView!
    @IBOutlet weak var storeElementProgress_1: UIView!
    @IBOutlet weak var storeElementProgress_2: UIView!
    @IBOutlet weak var storeElementProgress_3: UIView!
    @IBOutlet weak var storeElementProgress_4: UIView!
    @IBOutlet weak var storeElementProgress_5: UIView!
    
    @IBOutlet weak var storeElementBarContainerConstraintsWidth: NSLayoutConstraint!
    @IBOutlet weak var storeElementBarContainerConstraintsHeight: NSLayoutConstraint!
    
    var progressBarsElements: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.storeElementButton.layer.borderColor = UIColor.white.cgColor
        self.progressBarsElements = [self.storeElementProgress_1, self.storeElementProgress_2, self.storeElementProgress_3, self.storeElementProgress_4, self.storeElementProgress_5]

        self.storeView.layer.cornerRadius = 8
        self.storeView.clipsToBounds = true
        self.storeView.backgroundColor = UIColor(hex:0x1b1b1b)
        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    
    func displayPrice(item: StoreItem){
        if item.soldOutFlag{
            self.storeElementButton.setTitle("SOLD OUT", for: .normal)
            self.storeElementButton.setImage(UIImage(named:""), for: .normal)
            self.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }   else if item.price == 0{
            self.storeElementButton.setTitle("FREE", for: .normal)
            self.storeElementButton.setImage(UIImage(named:""), for: .normal)
            self.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }   else    {
            self.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(MinesLover.UIElements["storePriceButtonTitleOffset"]!), 0, 0)
            
            switch item.priceUnit{
            case .coin:
                self.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                self.storeElementButton.setTitle("\(item.price)", for: .normal)
                break;
            case .gem:
                self.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                self.storeElementButton.setTitle("\(item.price)", for: .normal)
                break;
            case .realMoney:
                self.storeElementButton.setTitle("$ \(item.price)", for: .normal)
                self.storeElementButton.setImage(UIImage(named:""), for: .normal)
                self.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                
            }
            
            
        }
    }
    func lockItem(ifLock:Bool){
        if ifLock{
            self.storeElementView.alpha = 0.5
            self.storeElementLock.isHidden = false;
        }   else{
            self.storeElementLock.isHidden = true;
            self.storeElementView.alpha = 1.0
        }
    }
    func displayProgressBar(number: Int){
        for i in 1...5{
            if (number - i) > -1 {
//                self.progressBarsElements[i-1].isHidden = false
                self.progressBarsElements[i-1].backgroundColor = UIColor.seraphDarkPurple
            }   else{
//                self.progressBarsElements[i-1].isHidden = true
                self.progressBarsElements[i-1].backgroundColor = UIColor.seraphLightWhite
            }
        }
    }
 

}
