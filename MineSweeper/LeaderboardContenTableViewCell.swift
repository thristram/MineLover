//
//  leaderboardContentableViewCell.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/20/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class LeaderboardContentTableViewCell: UITableViewCell {
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbContentValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
