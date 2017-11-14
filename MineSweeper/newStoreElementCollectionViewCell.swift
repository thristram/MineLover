//
//  newStoreElementCollectionViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/13/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class newStoreElementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var storeElementView: UIView!
    @IBOutlet weak var storeElementImage: UIImageView!
    @IBOutlet weak var storeElementTitle: UILabel!
    @IBOutlet weak var storeElementDescription: UILabel!
    @IBOutlet weak var storeElementButton: UIButton!
    @IBOutlet weak var storeElementLock: UIImageView!

    @IBOutlet weak var storeElementPriceContainer: UIView!
    @IBOutlet weak var storeElementPrice: UILabel!
    @IBOutlet weak var storeElementPriceType: UIImageView!
    @IBOutlet weak var storeElementPriceSeperatorWidth: NSLayoutConstraint!
    
    @IBOutlet weak var storeElementPriceTypeWidth: NSLayoutConstraint!
    @IBOutlet weak var storeElementTitleOffset: NSLayoutConstraint!
    @IBOutlet weak var storeElementDescriptionOffset: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.storeView.layer.cornerRadius = 4
        self.storeView.clipsToBounds = true

        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    func setSingleLine(){
        self.storeElementDescription.isHidden = true
        self.storeElementTitleOffset.constant = 0
        self.storeElementDescriptionOffset.constant = 16
    }
    func setDoubleLine(){
        self.storeElementDescription.isHidden = false
        self.storeElementTitleOffset.constant = -10
        self.storeElementDescriptionOffset.constant = 10
    }
    func displayPrice(item: StoreItem){
        print(item.priceUnit)
        if item.soldOutFlag{
            self.storeElementPrice.text = "OUT"
            self.storeElementPriceType.image = UIImage(named:"")
            self.storeElementPriceType.isHidden = true
            self.storeElementPriceSeperatorWidth.constant = 0
            self.storeElementPriceTypeWidth.constant = 0
        }   else if item.price == 0{
            self.storeElementPrice.text = "FREE"
            self.storeElementPriceType.image = UIImage(named:"")
            self.storeElementPriceType.isHidden = true
            self.storeElementPriceSeperatorWidth.constant = 0
            self.storeElementPriceTypeWidth.constant = 0
        }   else    {
            self.storeElementPriceSeperatorWidth.constant = 4
            
            switch item.priceUnit{
            case .coin:
                self.storeElementPriceType.image = UIImage(named:"coin")
                self.storeElementPrice.text = "\(item.price)"
                self.storeElementPriceTypeWidth.constant = 20
                self.storeElementPriceType.isHidden = false
                break;
            case .gem:
                self.storeElementPriceType.image = UIImage(named:"gem")
                self.storeElementPrice.text = "\(item.price)"
                self.storeElementPriceTypeWidth.constant = 20
                self.storeElementPriceType.isHidden = false
                break;
            case .realMoney:
                self.storeElementPrice.text = "$\(Double(item.price) - 0.01)"
                self.storeElementPriceType.image = UIImage(named:"")
                self.storeElementPriceSeperatorWidth.constant = 0
                self.storeElementPriceTypeWidth.constant = 0
            }
            
            
        }
    }
    func storeItemStatus(status: StoreItemStatus){
        switch status{
        case .none:
            self.storeElementLock.isHidden = true
            self.storeElementPriceContainer.isHidden = false
            break
        case .fullyUpgraded:
            self.storeElementLock.isHidden = false
            self.storeElementPriceContainer.isHidden = true
            self.storeElementLock.image = #imageLiteral(resourceName: "Icon-upgraded")
            break
        case .locked:
            self.storeElementLock.isHidden = false
            self.storeElementPriceContainer.isHidden = true
            self.storeElementLock.image = #imageLiteral(resourceName: "Icon-lock")
            break
        case .soldOut:
            self.storeElementLock.isHidden = false
            self.storeElementPriceContainer.isHidden = true
            self.storeElementLock.image = #imageLiteral(resourceName: "Icon-soldout")
            break
        }
    }
    
    
}
