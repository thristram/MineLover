//
//  LevelSelectCollectionViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/13/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class LevelSelectCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.cellView.layer.borderWidth = 4
        
    }
}
