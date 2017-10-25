//
//  storeElementTableViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 5/26/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//
import Foundation
import UIKit

class storeElementTableViewCell: UITableViewCell {
    
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
    
    @IBOutlet weak var storeElementTitleConstraintsTop: NSLayoutConstraint!
    
    @IBAction func storeElementButtonPressed(_ sender: Any) {
        
    }

    var progressBarsElements: [UIView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateCellConstraints()
        self.storeElementButton.layer.borderColor = UIColor.white.cgColor
        self.progressBarsElements = [self.storeElementProgress_1, self.storeElementProgress_2, self.storeElementProgress_3, self.storeElementProgress_4, self.storeElementProgress_5]
        
        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func displayPrice(item: StoreItem){
        if item.soldOutFlag{
            self.storeElementButton.setTitle("SOLD OUT", for: .normal)
            self.storeElementButton.setImage(UIImage(named:""), for: .normal)
            self.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }   else{
            self.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, CGFloat(MinesLover.UIElements["storePriceButtonTitleOffset"]!), 0, 0)
            
            switch item.priceUnit{
            case .coin:
                self.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                break;
            case .gem:
                self.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                break;
            default:
                break;
            }
            self.storeElementButton.setTitle("\(item.price)", for: .normal)
            
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
                self.progressBarsElements[i-1].isHidden = false
            }   else{
                self.progressBarsElements[i-1].isHidden = true
            }
        }
    }
    func screenCellSize()->String{
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        
        switch screenHeight{
        case 480:
            return "4"
        case 568:
            return "5"
        case 667:
            return "7"
        case 736:
            return "7+"
        default:
            return ""
        }
    }

    func updateCellConstraints(){
        switch(screenCellSize()){
        case "5":
            
            break;
        case "7":
            let barHeight = 7
            storeElementProgress_1.layer.cornerRadius = CGFloat(barHeight/2)
            storeElementProgress_2.layer.cornerRadius = CGFloat(barHeight/2)
            storeElementProgress_3.layer.cornerRadius = CGFloat(barHeight/2)
            storeElementProgress_4.layer.cornerRadius = CGFloat(barHeight/2)
            storeElementProgress_5.layer.cornerRadius = CGFloat(barHeight/2)
            storeElementBarContainerConstraintsHeight.constant = CGFloat(barHeight)
            storeElementBarContainerConstraintsWidth.constant = 170
            break;
        case "+":
            
            break;
        default:
            
            break;
        }
        
    }

    
    }
