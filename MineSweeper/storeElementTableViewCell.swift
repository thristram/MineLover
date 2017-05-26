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
    @IBOutlet weak var storeElementImage: UIImageView!
    @IBOutlet weak var storeElementTitle: UILabel!
    @IBOutlet weak var storeElementDescription: UILabel!
    @IBOutlet weak var storeElementButton: UIButton!
    @IBOutlet weak var storeElementPriceView: UIView!
    @IBOutlet weak var storeElementPriceImage: UIImageView!
    @IBOutlet weak var storeElementPriceLabel: UILabel!

    @IBOutlet weak var storeElementBarContainer: UIView!
    @IBOutlet weak var storeElementProgress_1: UIView!
    @IBOutlet weak var storeElementProgress_2: UIView!
    @IBOutlet weak var storeElementProgress_3: UIView!
    @IBOutlet weak var storeElementProgress_4: UIView!
    @IBOutlet weak var storeElementProgress_5: UIView!
    
    @IBOutlet weak var storeElementTitleConstraintsTop: NSLayoutConstraint!
    
    @IBAction func storeElementButtonPressed(_ sender: Any) {
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        storeElementButton.layer.borderColor = UIColor.white.cgColor
        
        
        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    }
