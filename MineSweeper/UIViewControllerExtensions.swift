//
//  UIViewExtensions.swift
//  MineSweeper
//
//  Created by Fangchen Li on 10/19/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore



extension UIViewController{
    func notifyUser(_ title: String, message: String, type: NotificaitonType = .normal) -> Void{
        
        let popupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "notification") as! NotificationViewController
        popupVC.modalPresentationStyle = .overCurrentContext
        popupVC.modalTransitionStyle = .crossDissolve
        popupVC.notificationTitle = title
        popupVC.notificationContent = message
        popupVC.notificationType = type
        self.present(popupVC, animated: true, completion: nil)
        
    
    }
}


