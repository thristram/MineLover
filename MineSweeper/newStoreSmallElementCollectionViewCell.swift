//
//  newStoreSmallElementCollectionViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/13/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class newStoreSmallElementCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var storeElementView: UIView!
    @IBOutlet weak var storeCoverView: UIImageView!
    @IBOutlet weak var storeElementTitle: UILabel!
    @IBOutlet weak var storeElementImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.storeElementView.isHidden = true
        self.storeCoverView.isHidden = false
        self.storeView.layer.cornerRadius = 8
        self.storeView.clipsToBounds = true
    }
}
