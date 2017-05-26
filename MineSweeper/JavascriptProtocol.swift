//
//  JavascriptProtocol.swift
//  MineSweeper
//
//  Created by Fangchen Li on 5/25/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol JavaScriptMethodProtocol: JSExport {
    var value: String {get set}
    func postContent(_ value: String, _ number: String)
    func postContent(_ value: String, number: String)
}

class JavaScriptMethod : NSObject, JavaScriptMethodProtocol {
    
    
    var value: String {
        get { return ""}
        set {          }
    }
    
    func postContent(_ value: String, _ number: String) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "javascriptEvent"), object: nil, userInfo: ["method": value,"value":number])
    }
    
    func postContent(_ value: String, number: String) {
        //Method Name: postContentNumber
    }
}
