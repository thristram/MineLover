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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
