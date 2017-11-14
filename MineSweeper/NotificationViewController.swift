//
//  NotificationViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 11/14/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {

    var notificationTitle: String = ""
    var notificationContent: String = ""
    var notificationType: NotificaitonType = .coinEarned
    
    @IBOutlet weak var messageView: SpringView!
    
    
    @IBOutlet weak var messageTopView: UIView!
    @IBOutlet weak var messageTopBackground: UIImageView!
    @IBOutlet weak var messageTopImage: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var messageTitle: UILabel!
    @IBOutlet weak var messageContent: UILabel!
    
    
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    @IBOutlet weak var MessageContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTopImageY: NSLayoutConstraint!
    @IBAction func dismissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        self.messageContainer.clipsToBounds = true
        self.messageContainer.layer.cornerRadius = 8
        self.dismissButton.clipsToBounds = true
        
        self.messageTitle.text = self.notificationTitle
        self.messageContent.text = self.notificationContent
        
        switch notificationType{
        case .normal:
            self.messageTopView.backgroundColor = UIColor.seraphRed
            self.messageTopBackground.isHidden = true
            self.messageTopImage.image = #imageLiteral(resourceName: "Icon-attention")
            self.messageTopImageY.constant = 0
            break
        case .coinEarned:
            self.messageTopView.backgroundColor = UIColor.seraphOrange
            self.messageTopBackground.isHidden = false
            self.messageTopBackground.image = #imageLiteral(resourceName: "background-shinny")
            self.messageTopImage.image = #imageLiteral(resourceName: "coin")
            break
        case .gemEarned:
            self.messageTopView.backgroundColor = UIColor.seraphLightPurple
            self.messageTopImage.image = #imageLiteral(resourceName: "gem")
            self.messageTopBackground.image = #imageLiteral(resourceName: "background-shinny")
            self.messageTopBackground.isHidden = false
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
