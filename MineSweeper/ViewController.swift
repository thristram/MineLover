//
//  ViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 5/17/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import JavaScriptCore




class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    ////////////////////////////////
    ////////STORAGE VARIABLES///////
    ////////////////////////////////
    
    //iCloud
    var iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    let iCloudTextKey = "iCloudText"
    
    
    //Local
    var defaultKeyStore: UserDefaults? = UserDefaults.standard
    let DefaultsTextKey = "DefaultsText"
    
    
    ////////////////////////////////
    //////////GAME VARIABLES////////
    ////////////////////////////////
    
    var totalMines = 0;
    var gameWidth = 0;
    var gameHeight = 0;
    var sweeped = 0;
    var sweepCorrected = 0;
    var sweepNotCorrected = 0;
    var checked = 0;
    var timePassed = "0:00"

    var isGameOvered = false;
    var isGameWined = false;
    
    var currentLevel = 2;
    var currentMap = "";
    var ifChangeLevel = false;
    var setWidth = 8;
    var setHeight = 13;
    var setScale = 1.65;
    var setScaleable = "no";
    var setMaxScale = 1.0
    var setMinScale = 1.0
    var setMines = 20;
    //var setMines = 5;
    var marginLeft = 2
    var marginTop = 2
    var tdWidth = 31
    var tdHeight = 31
    var divWidth = 30
    var divHeight = 30
    var fontSize = "100%"
    var iconFontSize = "150%"
    
    var PO_mode = "none";
    var game_mode = "normal";
    var gameStarted = false;
    var squareUsed = false;
    var protectorUsed = false;
    var enablePowerUps = true;
    
    var timerCounter = 0;
    var timer = Timer()


    
    var ifReadLove = false;
    var jsContext : JSContext!
    
    
    var powerUp1Range: [String] = ["[LOCKED]", "1x3", "2x3", "3x3", "5x3", "5x5", "Full"]
    var powerUp2Range: [String] = ["[LOCKED]", "5x5", "8x13", "10x17", "12x20", "Unlimited", "Full"]
    var powerUp2TimeLimit: [String] = ["1s", "2s", "3s", "4s", "5s", "6s", "Full"]

    

    var lv_1_Statistics:[String:String] = [
        
        "averageTime":"0", "averageTimeWin":"0", "averageTimeLose":"0", "explorationPercentage":"0", "totalWin":"0", "totalLose":"0", "totalGame":"0", "longestGame": "0", "longestWin": "0", "longestLose": "0", "shortestLose": "0", "totalChecked": "0", "totalMineSweeped":"0", "totalMineSweepedWrong": "0",
        
        "1_Date":"0", "2_Date":"0", "3_Date":"0", "4_Date":"0", "5_Date":"0", "6_Date":"0", "7_Date":"0", "8_Date":"0", "9_Date":"0", "10_Date":"0",
        
        "1_Record":"0", "2_Record":"0", "3_Record":"0", "4_Record":"0", "5_Record":"0", "6_Record":"0", "7_Record":"0", "8_Record":"0", "9_Record":"0", "10_Record":"0",
        
        "1_map":"{}", "2_map":"{}", "3_map":"{}", "4_map":"{}", "5_map":"{}", "6_map":"{}", "7_map":"{}", "8_map":"{}", "9_map":"{}", "10_map":"{}"
        
    ];
    
    var lv_2_Statistics:[String:String] = [
        
        "averageTime":"0", "averageTimeWin":"0", "averageTimeLose":"0", "explorationPercentage":"0", "totalWin":"0", "totalLose":"0", "totalGame":"0", "longestGame": "0", "longestWin": "0", "longestLose": "0", "shortestLose": "0", "totalChecked": "0", "totalMineSweeped":"0", "totalMineSweepedWrong": "0",
        
        "1_Date":"0", "2_Date":"0", "3_Date":"0", "4_Date":"0", "5_Date":"0", "6_Date":"0", "7_Date":"0", "8_Date":"0", "9_Date":"0", "10_Date":"0",
        
        "1_Record":"0", "2_Record":"0", "3_Record":"0", "4_Record":"0", "5_Record":"0", "6_Record":"0", "7_Record":"0", "8_Record":"0", "9_Record":"0", "10_Record":"0",
        
        "1_map":"{}", "2_map":"{}", "3_map":"{}", "4_map":"{}", "5_map":"{}", "6_map":"{}", "7_map":"{}", "8_map":"{}", "9_map":"{}", "10_map":"{}"
        
    ];
    
    var lv_3_Statistics:[String:String] = [
        
        "averageTime":"0", "averageTimeWin":"0", "averageTimeLose":"0", "explorationPercentage":"0", "totalWin":"0", "totalLose":"0", "totalGame":"0", "longestGame": "0", "longestWin": "0", "longestLose": "0", "shortestLose": "0", "totalChecked": "0", "totalMineSweeped":"0", "totalMineSweepedWrong": "0",
        
        "1_Date":"0", "2_Date":"0", "3_Date":"0", "4_Date":"0", "5_Date":"0", "6_Date":"0", "7_Date":"0", "8_Date":"0", "9_Date":"0", "10_Date":"0",
        
        "1_Record":"0", "2_Record":"0", "3_Record":"0", "4_Record":"0", "5_Record":"0", "6_Record":"0", "7_Record":"0", "8_Record":"0", "9_Record":"0", "10_Record":"0",
        
        "1_map":"{}", "2_map":"{}", "3_map":"{}", "4_map":"{}", "5_map":"{}", "6_map":"{}", "7_map":"{}", "8_map":"{}", "9_map":"{}", "10_map":"{}"
        
    ];
    
    var lv_4_Statistics:[String:String] = [
        
        "averageTime":"0", "averageTimeWin":"0", "averageTimeLose":"0", "explorationPercentage":"0", "totalWin":"0", "totalLose":"0", "totalGame":"0", "longestGame": "0", "longestWin": "0", "longestLose": "0", "shortestLose": "0", "totalChecked": "0", "totalMineSweeped":"0", "totalMineSweepedWrong": "0",
        
        "1_Date":"0", "2_Date":"0", "3_Date":"0", "4_Date":"0", "5_Date":"0", "6_Date":"0", "7_Date":"0", "8_Date":"0", "9_Date":"0", "10_Date":"0",
        
        "1_Record":"0", "2_Record":"0", "3_Record":"0", "4_Record":"0", "5_Record":"0", "6_Record":"0", "7_Record":"0", "8_Record":"0", "9_Record":"0", "10_Record":"0",
        
        "1_map":"{}", "2_map":"{}", "3_map":"{}", "4_map":"{}", "5_map":"{}", "6_map":"{}", "7_map":"{}", "8_map":"{}", "9_map":"{}", "10_map":"{}"
        
    ];
    var saveCoins = 0;
    var saveGems = 0;
    var powerUp1:[String:Int] = ["remaining" : 0, "level": 0]
    var powerUp2:[String:Int] = ["remaining" : 0, "level": 0, "time": 0]
    var powerUp3:[String:Int] = ["remaining" : 0, "level": 0]
    

    
    var dailyCheckIn:[String:Int] = [
        "Gem": 2, "lastClaimGem": 0,
        "Coin": 2000, "lastClaimCoin": 0
    ]
    
    
    
    var priceList: [String:Int] = [
        "Passes_XRay" : 1000, "Passes_XRay_type": 1,
        "Passes_Sweeper" : 1500, "Passes_Sweeper_type": 1,
        "Passes_Protector" : 1000, "Passes_Protector_type": 1,
        
        "Ability_XRay_lv_1" : 2, "Ability_XRay_lv_1_type": 2,
        "Ability_XRay_lv_2" : 3, "Ability_XRay_lv_2_type": 2,
        "Ability_XRay_lv_3" : 5, "Ability_XRay_lv_3_type": 2,
        "Ability_XRay_lv_4" : 8, "Ability_XRay_lv_4_type": 2,
        "Ability_XRay_lv_5" : 10, "Ability_XRay_lv_5_type": 2,
        
        "Ability_Sweeper_lv_1" : 2, "Ability_Sweeper_lv_1_type": 2,
        "Ability_Sweeper_lv_2" : 3, "Ability_Sweeper_lv_2_type": 2,
        "Ability_Sweeper_lv_3" : 5, "Ability_Sweeper_lv_3_type": 2,
        "Ability_Sweeper_lv_4" : 8, "Ability_Sweeper_lv_4_type": 2,
        "Ability_Sweeper_lv_5" : 10, "Ability_Sweeper_lv_5_type": 2,
        
        "Ability_Sweeper_time_1" : 2, "Ability_Sweeper_time_1_type": 2,
        "Ability_Sweeper_time_2" : 3, "Ability_Sweeper_time_2_type": 2,
        "Ability_Sweeper_time_3" : 4, "Ability_Sweeper_time_3_type": 2,
        "Ability_Sweeper_time_4" : 5, "Ability_Sweeper_time_4_type": 2,
        "Ability_Sweeper_time_5" : 6, "Ability_Sweeper_time_5_type": 2,
        
        "Ability_protector_lv_1" : 2, "Ability_protector_lv_1_type": 2,
        "Ability_protector_lv_2" : 3, "Ability_protector_lv_2_type": 2,
        "Ability_protector_lv_3" : 5, "Ability_protector_lv_3_type": 2,
        "Ability_protector_lv_4" : 8, "Ability_protector_lv_4_type": 2,
        "Ability_protector_lv_5" : 10, "Ability_protector_lv_5_type": 2,
        
        "currency_1_price" : 1, "currency_1_price_type": 2, "currency_1_product": 2000, "currency_1_product_type": 1,
        "currency_2_price" : 2, "currency_2_price_type": 2, "currency_2_product": 4500, "currency_2_product_type": 1,
        "currency_3_price" : 5, "currency_3_price_type": 2, "currency_3_product": 15000, "currency_3_product_type": 1,
        
        
        
        ]

    
    
    ////////////////////////////////
    /////MAIN GAME VIEW ELEMENTS////
    ////////////////////////////////
    
    
    //STATUS BAR
    @IBOutlet weak var mainViewStatusBar: UIView!
    @IBOutlet weak var mainViewMineRemaining: UILabel!
    @IBOutlet weak var mainViewTimeLeft: UILabel!
    
    //STATUS BAR BUTTONS
    @IBOutlet weak var powerUpButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var mineButton: UIButton!
    
    //MAIN WEBVIEW
    @IBOutlet weak var mineWebView: UIWebView!
    
    
    
    ////////////////////////////////
    //////////MENU ELEMENTS/////////
    ////////////////////////////////
    
    
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var menuView: UIView!
    
    //COIN & GEMS
    @IBOutlet weak var gemLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    
    //MENU BUTTONS
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //OTHERS
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var levelSegmentControl: UISegmentedControl!
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuText1: UILabel!
    @IBOutlet weak var menuText2: UILabel!
    
    
    
    
    ////////////////////////////////
    //////LEADERBOARD ELEMENTS//////
    ////////////////////////////////
    
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    ////////////////////////////////
    ////////POWERUP ELEMENTS////////
    ////////////////////////////////
    
    @IBOutlet weak var powerUpMenu: UIView!
    
    //POWERUP 1
    @IBOutlet weak var powerUp1View: UIView!
    @IBOutlet weak var powerUp1Image: UIImageView!
    @IBOutlet weak var powerUp1Title: UILabel!
    @IBOutlet weak var powerUp1Description: UILabel!
    
    @IBOutlet weak var powerUp1ProgressBar: UIView!
    @IBOutlet weak var powerUp1ProgressBar_1: UIView!
    @IBOutlet weak var powerUp1ProgressBar_2: UIView!
    @IBOutlet weak var powerUp1ProgressBar_3: UIView!
    @IBOutlet weak var powerUp1ProgressBar_4: UIView!
    @IBOutlet weak var powerUp1ProgressBar_5: UIView!
    
    @IBOutlet weak var powerUp1Lock: UIImageView!
    @IBOutlet weak var powerUp1Status: UILabel!
    
    
    //POWERUP 2
    @IBOutlet weak var powerUp2View: UIView!
    @IBOutlet weak var powerUp2Title: UILabel!
    @IBOutlet weak var powerUp2Description: UILabel!
    @IBOutlet weak var powerUp2Image: UIImageView!

    @IBOutlet weak var powerUp2ProgressBar: UIView!
    @IBOutlet weak var powerUp2ProgressBar_1: UIView!
    @IBOutlet weak var powerUp2ProgressBar_2: UIView!
    @IBOutlet weak var powerUp2ProgressBar_3: UIView!
    @IBOutlet weak var powerUp2ProgressBar_4: UIView!
    @IBOutlet weak var powerUp2ProgressBar_5: UIView!

    @IBOutlet weak var powerUp2Lock: UIImageView!
    @IBOutlet weak var powerUp2Status: UILabel!
    
    
    ////////////////////////////////
    ////////GEMVIEW ELEMENTS////////
    ////////////////////////////////
    
    @IBOutlet weak var gemView: UIView!
    @IBOutlet weak var gemImage: UIImageView!
    @IBOutlet weak var gemTitle: UILabel!
    @IBOutlet weak var gemDescription: UILabel!
    @IBOutlet weak var coinGemViewButton: UIButton!
    @IBOutlet weak var gemGemViewButton: UIButton!
    @IBOutlet weak var coinGemViewLabel: UILabel!
    @IBOutlet weak var gemGemViewLabel: UILabel!
    @IBOutlet weak var resumeGemViewButton: UIButton!

    
    ////////////////////////////////
    /////////STORE ELEMENTS/////////
    ////////////////////////////////
    
    @IBOutlet weak var coinStoreView: EFCountingLabel!
    @IBOutlet weak var gemStoreView: EFCountingLabel!
    @IBOutlet weak var storeSegmentControl: UISegmentedControl!
    @IBOutlet weak var storeView: UIView!
    @IBOutlet weak var passesTableView: UITableView!
    @IBOutlet weak var abilitiesTableView: UITableView!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var dealsTableView: UITableView!
    
    //Segement Control Elements
    @IBOutlet weak var storeSegmentBarContainer: UIView!
    @IBOutlet weak var storeSegmentBar1: UIView!
    @IBOutlet weak var storeSegmentBar2: UIView!
    @IBOutlet weak var storeSegmentBar3: UIView!
    @IBOutlet weak var storeSegmentBar4: UIView!
    
    
    
    
    @IBAction func storeSelection(_ sender: Any) {
        switch((sender as AnyObject).selectedSegmentIndex){
        case 0:
            switchToStoreDeals()
            break;
        case 1:
            switchToStoreCurrency()
            break;
        case 2:
            switchToStoreAbility()
            break;
        case 3:
            switchToStorePasses()
            break;
        default:
            break;
            
        }
    }
    
    func switchToStoreDeals(){
        self.dealsTableView.isHidden = false;
        self.currencyTableView.isHidden = true;
        self.abilitiesTableView.isHidden = true;
        self.passesTableView.isHidden = true;
        
        self.storeSegmentBar1.isHidden = false;
        self.storeSegmentBar2.isHidden = true;
        self.storeSegmentBar3.isHidden = true;
        self.storeSegmentBar4.isHidden = true;

    }
    func switchToStoreCurrency(){
        self.dealsTableView.isHidden = true;
        self.currencyTableView.isHidden = false;
        self.abilitiesTableView.isHidden = true;
        self.passesTableView.isHidden = true;
        
        self.storeSegmentBar1.isHidden = true;
        self.storeSegmentBar2.isHidden = false;
        self.storeSegmentBar3.isHidden = true;
        self.storeSegmentBar4.isHidden = true;

    }
    func switchToStoreAbility(){
        self.dealsTableView.isHidden = true;
        self.currencyTableView.isHidden = true;
        self.abilitiesTableView.isHidden = false;
        self.passesTableView.isHidden = true;
        
        self.storeSegmentBar1.isHidden = true;
        self.storeSegmentBar2.isHidden = true;
        self.storeSegmentBar3.isHidden = false;
        self.storeSegmentBar4.isHidden = true;
    }
    
    func switchToStorePasses(){
        self.dealsTableView.isHidden = true;
        self.currencyTableView.isHidden = true;
        self.abilitiesTableView.isHidden = true;
        self.passesTableView.isHidden = false;
        
        self.storeSegmentBar1.isHidden = true;
        self.storeSegmentBar2.isHidden = true;
        self.storeSegmentBar3.isHidden = true;
        self.storeSegmentBar4.isHidden = false;
    }
    @IBAction func storePauseViewPressed(_ sender: Any) {
        showStoreView()
    }
    @IBAction func closeStorePressed(_ sender: Any) {
        hideStoreView();
    }
    
    @IBAction func resumeGemViewPressed(_ sender: Any) {
        hideGemView()
    }
    @IBAction func coinGemViewPressed(_ sender: Any) {
    }
    @IBAction func gemGemViewPressed(_ sender: Any) {
    }

    
    @IBAction func coinButtonPressed(_ sender: Any) {
    }
    @IBAction func gemButtonPressed(_ sender: Any) {
    }
    
    
    
    @IBAction func powerUpPressed(_ sender: Any) {
        self.stopTimer();
        if(gameStarted){
            
            if(enablePowerUps){
                showPowerUpMenu()
            }   else   {
                self.notifyUser("CAUTION", message: "Comming Soon!")

            }

        }   else{
            self.notifyUser("CAUTION", message: "Power ups are avalible after game started")

        }
        
    }
    @IBAction func pausePressed(_ sender: Any) {
        self.stopTimer();
        if(self.isGameWined){
            showMenu(event: "win")
        }   else if(self.isGameOvered){
            showMenu(event: "gameover")
        }   else{
            showMenu(event: "pause")
            
        }
    }
    @IBAction func minePress(_ sender: Any) {
        let _self = self;
        if(self.game_mode == "sweep"){
            game_mode = "normal";
            _self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
            UIView.animate(withDuration: 0.3, animations: {
                _self.mineButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
                
            }, completion: { (finished: Bool) in
                _self.mineButton.setImage(UIImage(named: "mine"), for: .normal)
                
                UIView.animate(withDuration: 0.3, animations: {
                    _self.mineButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
                    
                }, completion: { (finished: Bool) in
                    
                    
                    UIView.animate(withDuration: 0.15, animations: {
                        _self.mineButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                        
                    });
                });
            });

        }   else{
            game_mode = "sweep"
            _self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeSweep()")
            UIView.animate(withDuration: 0.3, animations: {
                _self.mineButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
                
            }, completion: { (finished: Bool) in
                _self.mineButton.setImage(UIImage(named: "heart"), for: .normal)
                
                UIView.animate(withDuration: 0.3, animations: {
                    _self.mineButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
                    
                }, completion: { (finished: Bool) in
                    
                    
                    UIView.animate(withDuration: 0.15, animations: {
                        _self.mineButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                        
                    });
                });
            });

            
        }
    }
    
    
    
    
    @IBAction func selectLevel(_ sender: Any) {
        switch((sender as AnyObject).selectedSegmentIndex){
            case 0:
                currentLevel = 1;
                setWidth = 8;
                setHeight = 13;
                setScale = 1.6;
                setScaleable = "yes";
                setMaxScale = 1.0;
                setMinScale = 1.0
                setMines = 12;
                //setMines = 5;
                ifChangeLevel = true;
                
                marginTop = 2
                marginLeft = 2
                
                tdWidth = 32
                tdHeight = 32
                divWidth = 30
                divHeight = 30
                iconFontSize = "150%"
                fontSize = "100%"

                
                mineWebView.scrollView.isScrollEnabled = false
                
                break;
            case 1:
                currentLevel = 2;
                setWidth = 8;
                setHeight = 13;
                setScale = 1.6;
                setScaleable = "yes";
                setMaxScale = 1.0;
                setMinScale = 1.0
                setMines = 20;
                //setMines = 5;
                ifChangeLevel = true;
                
                marginTop = 2
                marginLeft = 2
                
                tdWidth = 32
                tdHeight = 32
                divWidth = 30
                divHeight = 30
                iconFontSize = "150%"
                fontSize = "100%"

                
                mineWebView.scrollView.isScrollEnabled = false
                
                
                break;
            case 2:
                currentLevel = 3;
                setWidth = 10;
                setHeight = 17;
                setScale = 1.28;
                setScaleable = "yes";
                setMaxScale = 2.0;
                setMinScale = 1
                setMines = 35;
                //setMines = 5;

                ifChangeLevel = true;
                
                marginTop = 2
                marginLeft = 3

    
                tdWidth = 32
                tdHeight = 31
                divWidth = 30
                divHeight = 30
                iconFontSize = "150%"
                fontSize = "100%"
                
                mineWebView.scrollView.isScrollEnabled = false;
                break;
            
            case 3:
                currentLevel = 4;
                setWidth = 16;
                setHeight = 26;
                setScale = 0.80;
                setScaleable = "yes";
                setMaxScale = 2.0;
                setMinScale = 1
                setMines = 90;
                //setMines = 5;
                ifChangeLevel = true;
                
                marginTop = 10
                marginLeft = 4
                
                
                tdWidth = 32
                tdHeight = 32
                divWidth = 30
                divHeight = 30
                iconFontSize = "150%"
                fontSize = "100%"
                
                mineWebView.scrollView.isScrollEnabled = true;
            
            
            
                break;
            default:
                break;
        }
    }
    @IBAction func failButtonPressed(_ sender: Any) {
        
        hideMenu();
        startNewGame();
        self.pauseButton.setImage(UIImage(named: "icon_pause"), for: .normal)
        
        
    }
    @IBAction func resumeButtonPressed(_ sender: Any) {
        hideMenu();
        if(self.isGameWined){
            self.pauseButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        }   else if(self.isGameOvered){
            self.pauseButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        }   else{
            self.pauseButton.setImage(UIImage(named: "icon_pause"), for: .normal)
            startTimer();
        }
        
    }
    @IBAction func switchToLeaderboard(_ sender: Any) {
        let _self = self;
        self.tableView.reloadData();
        _self.leaderboardView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            _self.pauseView.alpha = 0.0
            _self.leaderboardView.alpha = 1.0
            
        }, completion: { (finished: Bool) in
            _self.pauseView.isHidden = true
        });
    }
    
    @IBAction func switchToControl(_ sender: Any) {
        let _self = self;
        
        _self.pauseView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            _self.pauseView.alpha = 1.0
            _self.leaderboardView.alpha = 0.0
            
        }, completion: { (finished: Bool) in
            _self.leaderboardView.isHidden = true
        });

    }
    @IBAction func closePowerUpView(_ sender: Any) {
        hidePowerUpMenu()
        startTimer()
    }
    
    
    @IBAction func powerUp1Click(_ sender: Any) {
        if(gameStarted){
            if((powerUp1["level"]!) > 0){
                if(powerUp1["remaining"]! > 0){
                    if(PO_mode == "none"){
                    
                    
                        if(!squareUsed){
                            powerUp1["remaining"]! -= 1
                            saveRecord()
                            self.disablePowerUp1();
                        
                            /*POWERUP1 PROGRESS*/
                        
                            PO_mode = "square"
                            squareUsed = true;
                            let powerUpLevel = powerUp1["level"]!
                            self.mineWebView.stringByEvaluatingJavaScript(from: "setPOSqaure(\(powerUpLevel), \(powerUpLevel))")
                        }
                        startTimer();
                        hidePowerUpMenu()
                    }
                }   else    {
                    print("X-Ray pass is \(String(describing: powerUp1["remaining"])) which is < 0")
                    self.switchToStorePasses()
                    showStoreView();
                }
            }   else{
                self.switchToStoreAbility()
                showStoreView();
                
            }
        }
    }
    @IBAction func powerUp2Click(_ sender: Any) {
        if(gameStarted){
            if((powerUp2["level"]!) > 0){
                if(powerUp2["remaining"]! > 0){
                    if(PO_mode == "none"){
                    
                        if(!protectorUsed){
                            powerUp2["remaining"]! -= 1
                            saveRecord()
                            self.disablePowerUp2();
                            /*POWERUP2 PROGRESS*/
                            PO_mode = "protector"
                            protectorUsed = true;
                            let powerUpLevel = powerUp2["level"]!
                            let powerUpTime = powerUp2["time"]!
                            self.mineWebView.stringByEvaluatingJavaScript(from: "setPOProtector(\(powerUpLevel), \(powerUpTime))")
                        }
                        startTimer();
                        hidePowerUpMenu()
                
                    }
                }   else    {
                    print("Protector Pass is \(String(describing: powerUp1["remaining"])) which is < 0")
                    self.switchToStorePasses()
                    showStoreView();
                }
            }   else{
                self.switchToStoreAbility()
                showStoreView();
            }
        }
    }
    @IBAction func powerUpStoreClick(_ sender: Any) {
        showStoreView();
    }
    
    func hidePowerUpMenu(){
        self.powerUpMenu.alpha = 0.0
        self.mainViewStatusBar.alpha = 1.0
        self.powerUpMenu.isHidden = true
        
        
    }
    func showPowerUpMenu(){
        updatePowerUpText()
        self.powerUpMenu.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.powerUpMenu.alpha = 1.0
            self.mainViewStatusBar.alpha = 0.0
            
        });
        
    }
    
    
    func updatePowerUpText(){
        
        var powerUp1BarElements: [UIView] = [self.powerUp1ProgressBar_1, self.powerUp1ProgressBar_2, self.powerUp1ProgressBar_3, self.powerUp1ProgressBar_4, self.powerUp1ProgressBar_5]
        var powerUp2BarElements: [UIView] = [self.powerUp2ProgressBar_1, self.powerUp2ProgressBar_2, self.powerUp2ProgressBar_3, self.powerUp2ProgressBar_4, self.powerUp2ProgressBar_5]
        
        self.powerUp1Description.text = "Detect any mines\nwithin \(self.powerUp1Range[self.powerUp1["level"]!]) range"
        self.powerUp2Description.text = "click anywhere inside a\nin \(self.powerUp2Range[self.powerUp2["level"]!]) block within \(self.powerUp2TimeLimit[powerUp2["time"]!])"
        if((self.powerUp2["level"]!) == 5){
            self.powerUp2Description.text = "click anywhere\nwithin \(self.powerUp2TimeLimit[self.powerUp2["time"]!])"
        }
        
        
        if((self.powerUp1["level"]!) < 1){
            self.powerUp1Description.text = "Detect hidden mines.\nUnlock Power Up in Store"
            self.powerUp1Lock.isHidden = false;
            disablePowerUp1()
            
        }   else    {
            self.powerUp1Lock.isHidden = true
            if(powerUp1["remaining"]! < 1){
                self.powerUp1Status.isHidden = false
                self.powerUp1Status.text = "NO PASSES LEFT"
                self.disablePowerUp1();
            }   else if(squareUsed)   {
                self.powerUp1Status.isHidden = false
                self.powerUp1Status.text = "POWER UP USED"
                self.disablePowerUp1();
            }   else{
                self.powerUp1Status.isHidden = true;
                self.enablePowerUp1();
            }
            
        }
        
        
        
        if((self.powerUp2["level"]!) < 1){
            self.powerUp2Description.text = "Crazy click\nUnlock Power Up in Store"
            self.powerUp2Lock.isHidden = false;
            disablePowerUp2()
        }   else{
            
            self.powerUp2Lock.isHidden = true
            if(powerUp2["remaining"]! < 1){
                self.powerUp2Status.isHidden = false
                self.powerUp2Status.text = "NO PASSES LEFT"
                self.disablePowerUp2();
            }   else if(protectorUsed)   {
                self.powerUp2Status.isHidden = false
                self.powerUp2Status.text = "POWER UP USED"
                self.disablePowerUp2();
            }   else{
                self.powerUp2Status.isHidden = true;
                self.enablePowerUp2();
            }
        }
        
        
        
        for i in (1...5){
            if(i <= (powerUp1["remaining"]!)){
                powerUp1BarElements[i-1].isHidden = false;
            }   else{
                powerUp1BarElements[i-1].isHidden = true;
            }
            if(i <= (powerUp2["remaining"]!)){
                powerUp2BarElements[i-1].isHidden = false;
            }   else{
                powerUp2BarElements[i-1].isHidden = true;
            }
            
        }

        
        
    }
    
    func disablePowerUp1(){
        //self.powerUp1View.alpha = 0.5;
        self.powerUp1Image.alpha = 0.5
        self.powerUp1Title.alpha = 0.5
        self.powerUp1Description.alpha = 0.5
        self.powerUp1ProgressBar.alpha = 0.5
        self.powerUp1Status.alpha = 0.5
    }
    
    func enablePowerUp1(){
        //self.powerUp1View.alpha = 1.0;
        self.powerUp1Image.alpha = 1.0
        self.powerUp1Title.alpha = 1.0
        self.powerUp1Description.alpha = 1.0
        self.powerUp1ProgressBar.alpha = 1.0
        self.powerUp1Status.alpha = 1.0
    }
    
    func disablePowerUp2(){
        //self.powerUp2View.alpha = 0.5;
        self.powerUp2Image.alpha = 0.5
        self.powerUp2Title.alpha = 0.5
        self.powerUp2Description.alpha = 0.5
        self.powerUp2ProgressBar.alpha = 0.5
        self.powerUp2Status.alpha = 0.5
    
    }
    
    func enablePowerUp2(){
        //self.powerUp2View.alpha = 1.0;
        self.powerUp2Image.alpha = 1.0
        self.powerUp2Title.alpha = 1.0
        self.powerUp2Description.alpha = 1.0
        self.powerUp2ProgressBar.alpha = 1.0
        self.powerUp2Status.alpha = 1.0
    }

    func startNewGame(){
        self.mineWebView.scalesPageToFit = true;
        self.isGameOvered = false;
        self.isGameWined = false;
        sweeped = 0;
        sweepCorrected = 0;
        sweepNotCorrected = 0;
        checked = 0;
        
        
        
        totalMines = setMines
        if(ifChangeLevel){
            constructGame()
        }   else    {
            resetGame()
            mineWebView.stringByEvaluatingJavaScript(from: "restartGame()")
        }
        
        
        self.mainViewMineRemaining.text = formatMineDisplay(mineInput: self.totalMines)


        resetTimer();
        self.mainViewTimeLeft.text = "0:00";
        //self.mainViewMineRemaining.text = totalMines;
    }
    
    
    //Subscribe/Listen for the events
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //RECORD
        getRecord()
        iCloudSetUp()
        
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        passesTableView.delegate = self
        passesTableView.dataSource = self
        
        
        currencyTableView.delegate = self
        currencyTableView.dataSource = self

        dealsTableView.delegate = self
        dealsTableView.dataSource = self
        
        abilitiesTableView.delegate = self
        abilitiesTableView.dataSource = self
        
        dealsTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        passesTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        currencyTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        abilitiesTableView.register(UINib(nibName: "storeElementCell", bundle: nil), forCellReuseIdentifier: "storeTbCell")
        
        
        //MENU
        menuView.isHidden = true;
        menuView.alpha = 0.0;
        tryAgainButton.layer.borderColor = UIColor.white.cgColor
        resumeButton.layer.borderColor = UIColor.white.cgColor
        levelSegmentControl.selectedSegmentIndex = 1;
        
        //GEM View
        resumeGemViewButton.layer.borderColor = UIColor.white.cgColor
        gemView.alpha = 0.0;
        gemView.isHidden = true;
        self.gemGemViewLabel.text = "\(self.saveGems)";
        
        
        //STORE View
        
        
        
        let attr = NSDictionary(object: UIFont(name: "OpenSans", size: 15.0)!, forKey: NSFontAttributeName as NSCopying)
        self.storeSegmentControl.setTitleTextAttributes(attr as? [AnyHashable : Any], for: .normal)
        self.storeSegmentControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: .normal)
        self.storeSegmentControl.tintColor = UIColor.clear
        
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.versionLabel.text = "MineLover v\(version) Build \(build)"
            }
        }
        self.coinStoreView.format = "%d"
        self.gemStoreView.format = "%d"
        
        self.coinStoreView.text = "\(self.saveCoins)";
        self.gemStoreView.text = "\(self.saveGems)";
        
        
        
        
        
        
        
        //Mine View
        mineWebView.scrollView.isMultipleTouchEnabled = false;
        
        
        loadHTML()
        //JS Bridge
        NotificationCenter.default.addObserver(self, selector: #selector(self.handelJSEvent(_:)), name: NSNotification.Name(rawValue: "javascriptEvent"), object: nil)
        jsContext = self.mineWebView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptMethod(), forKeyedSubscript: "callSwift" as NSCopying & NSObjectProtocol)
        
        
        self.mainViewMineRemaining.text = formatMineDisplay(mineInput: self.setMines)
        
        
        //520 Special
        
        let defaults = UserDefaults.standard
        let _self = self;
        if let stringOne = defaults.string(forKey: "ifReadLove") {
            if(stringOne == "1"){
                _self.ifReadLove = true
            }// Some String Value
        }
        
        if(ifReadLove == true){
            mineWebView.stringByEvaluatingJavaScript(from: "readLove()");
        }
        
        
    }
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    /*
 
     SHAKE EVENT
 
     */
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked");
            self.stopTimer();
            if(self.isGameWined){
                showMenu(event: "win")
            }   else if(self.isGameOvered){
                showMenu(event: "gameover")
            }   else{
                showMenu(event: "pause")

            }
        }
    }
    
    
    /*
     
     INITIAL OPERATIONS
     
     */
    
    
    func loadHTML(){
        let path = Bundle.main.path(forResource: "index", ofType: "html")
        let url = URL(fileURLWithPath:path!)
        let request = URLRequest(url:url)
        mineWebView.loadRequest(request)
        mineWebView.scrollView.bounces = false
        mineWebView.scrollView.isScrollEnabled = false
        mineWebView.scalesPageToFit = true;
        mineWebView.scrollView.bouncesZoom = false;
        
        
        
    }
    func resetGame(){
    
        self.PO_mode = "none";
        self.gameStarted = false;
        self.squareUsed = false;
        self.protectorUsed = false;
        
        



    }
    /*
     
     MENU
     
     */

    
    func showMenu(event: String){
        let _self = self;
        
        
        /*
        let totalNumberOfBlocks = gameHeight * gameWidth;
        
        var percentageCompleted = 0;
        if ((totalNumberOfBlocks - totalMines) != 0){
            percentageCompleted = ((_self.checked * 100) / (totalNumberOfBlocks - totalMines));
        }
         */
        switch (event){
            case "win":
                //percentageCompleted = 100;
                
                _self.menuText1.text = "You got everything"
                _self.menuText2.text = "I Love You"
                _self.menuIcon.image = UIImage(named: "smile");
                _self.resumeButton.setTitle("BACK TO MAP", for: .normal)
                _self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
                break;

            case "gameover":
                
                _self.menuText1.text = "You found \(_self.sweepCorrected) out"
                _self.menuText2.text = "of \(_self.totalMines) mines"
                
                _self.menuIcon.image = UIImage(named: "cry");
                _self.resumeButton.setTitle("BACK TO MAP", for: .normal)
                _self.tryAgainButton.setTitle("TRY AGAIN", for: .normal)
                break;

            case "pause":
                _self.menuText1.text = "Paused";
                _self.menuText2.text = "Click resume to play";
                _self.menuIcon.image = UIImage(named: "pause");
                _self.resumeButton.setTitle("RESUME", for: .normal)
                _self.tryAgainButton.setTitle("NEW GAME", for: .normal)
                break;
            
            default:
                break;
        }

        coinLabel.text = "\(saveCoins)";
        gemLabel.text = "\(saveGems)";
        menuView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            _self.menuView.alpha = 1.0
            _self.mainViewStatusBar.alpha = 0.0
            
        });
        

    }
    func hideMenu(){
        self.menuView.alpha = 0.0
        self.mainViewStatusBar.alpha = 1.0
        self.menuView.isHidden = true
        
        
    }
    func showStoreView(){
        self.storeView.isHidden = false
        self.coinStoreView.text = "\(saveCoins)";
        self.gemStoreView.text = "\(saveGems)";
        self.dealsTableView.reloadData();
        self.passesTableView.reloadData();
        self.abilitiesTableView.reloadData();
        self.currencyTableView.reloadData();
        self.stopTimer();
        UIView.animate(withDuration: 0.5, animations: {
            self.storeView.alpha = 1.0
            self.mainViewStatusBar.alpha = 0.0
        });
    }
    func hideStoreView(){
        updatePowerUpText()
        UIView.animate(withDuration: 0.5, animations: {
            self.storeView.alpha = 0.0
            self.mainViewStatusBar.alpha = 1.0
        }, completion: { (finished: Bool) in
            self.storeView.isHidden = true
            self.startTimer();
            self.coinLabel.text = "\(self.saveCoins)";
            self.gemLabel.text = "\(self.saveGems)";
        
        });
    }
    
    func showProtectCountDownView(){
        self.gemView.isHidden = false;
        self.coinGemViewLabel.text = "\(self.saveCoins)";
        self.gemImage.image = UIImage(named: "number_3")
        self.gemTitle.text = "READY?"
        self.gemDescription.text = "You may click anywhere\nmarked in blue!"
        self.resumeGemViewButton.setTitle("START CLICK", for: .normal)
        self.resumeGemViewButton.isHidden = true;
        UIView.animate(withDuration: 0.5, animations: {
            self.gemView.alpha = 1.0
            self.mainViewStatusBar.alpha = 0.0
        }, completion: { (finished: Bool) in
            let when = DispatchTime.now();
            DispatchQueue.main.asyncAfter(deadline: when + 1) {
                self.gemImage.image = UIImage(named: "number_2")
            }
            DispatchQueue.main.asyncAfter(deadline: when + 2) {
                self.gemImage.image = UIImage(named: "number_1")
            }
            DispatchQueue.main.asyncAfter(deadline: when + 3) {
                self.hideGemView()
                
            }
            DispatchQueue.main.asyncAfter(deadline: when + 3.5) {
                self.executeJS(jsCode: "startPOProtector()")
            }
            
        });
        
    }
    func showGemView(){
        let _self = self;
        self.gemView.isHidden = false;
        self.coinGemViewLabel.text = "\(self.saveCoins)";
        self.gemImage.image = UIImage(named: "gem")
        self.gemTitle.text = "You got a GEM!"
        self.gemDescription.text = "You may use the GEM to purchase Power-Ups\nor Upgrade Power-Ups"
        self.resumeGemViewButton.setTitle("RESUMME", for: .normal)
        self.resumeGemViewButton.isHidden = false;
        stopTimer();
        
        UIView.animate(withDuration: 0.5, animations: {
            _self.gemView.alpha = 1.0
            _self.mainViewStatusBar.alpha = 0.0
        }, completion: { (finished: Bool) in
            
            
            
            //
            UIView.animate(withDuration: 0.3, animations: {
                _self.gemGemViewLabel.transform = CGAffineTransform(scaleX: 3.0, y: 3.0);
                
            }, completion: { (finished: Bool) in
                _self.gemGemViewLabel.text = "\(_self.saveGems)";
                
                UIView.animate(withDuration: 0.3, animations: {
                    _self.gemGemViewLabel.transform = CGAffineTransform(scaleX: 0.2, y: 0.2);
                    
                }, completion: { (finished: Bool) in
                    
                    UIView.animate(withDuration: 0.15, animations: {
                       _self.gemGemViewLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                        
                    }, completion: { (finished: Bool) in
                        _self.hideGemView()
                        /*
                        let when = DispatchTime.now();
                        DispatchQueue.main.asyncAfter(deadline: when + 1) {
                            
 
                        }
                        */

                    });
                });
            });

            
            
        });
        
    }
    func hideGemView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.gemView.alpha = 0.0
            self.mainViewStatusBar.alpha = 1.0
        }, completion: { (finished: Bool) in
            self.gemView.isHidden = true
            self.startTimer();
        });
    }
    
    /*
     
     JS BRIDGE
     
     */
    func constructGame(){
        resetGame()
        let JSConstructGame = "resetGame( \(setWidth), \(setHeight), \(setMines), \(setScale), '\(setScaleable)', '\(setMaxScale)', '\(setMinScale)', '\(marginTop)', '\(marginLeft)', '\(tdWidth)', '\(tdHeight)', '\(divWidth)', '\(divHeight)', '\(fontSize)', '\(iconFontSize)')"
        mineWebView.stringByEvaluatingJavaScript(from: JSConstructGame)
        print (JSConstructGame)

    }
    func handelJSReceivedData(method: String, value: String){
        let _self = self;
        switch (method){
        case "gameInit":
            print("webLoad Ready")
            constructGame();
            break;
        case "console":
            print (value);
    
            break;
        case "mines":
            
            break;
        case "gameStart":
            _self.gameStarted = true;
            startRecord();
            startTimer();
            break;
        case "gameStop":
            _self.gameStarted = false;

            break;
        case "gameover":
            self.stopTimer();
            loseRecord()
            
            _self.resetGame()
            _self.isGameOvered = true;
            _self.checked = Int(value)!;
            showMenu(event: "gameover")
            break;
        case "win":
            self.stopTimer();
            winRecord()
            _self.resetGame()
            self.tableView.reloadData();
            _self.isGameWined = true;
            showMenu(event: "win")
            break;
        case "gameTotalMines":
            _self.totalMines = Int(value)!;
            break;
        case "gameWidth":
            _self.gameWidth = Int(value)!;
            break;
        case "gameHeight":
            _self.gameHeight = Int(value)!;
            break;
        case "sweepCorrected":
            _self.sweepCorrected = Int(value)!;
            break;
        case "sweepNotCorrected":
            _self.sweepNotCorrected = Int(value)!;
            break;
        case "checked":
            _self.checked = Int(value)!;
            break;
        case "sweeped":
            _self.sweeped = Int(value)!;
            let minesRemaining = _self.totalMines - _self.sweeped
            _self.mainViewMineRemaining.text = formatMineDisplay(mineInput: minesRemaining)
            break;
        case "currentMap":
            _self.currentMap = value;
            break;
        case "readLove":
            _self.ifReadLove = true;
            let defaults = UserDefaults.standard
            defaults.set("1", forKey: "ifReadLove")
            
            break;
        case "stopProtector":
            _self.PO_mode = "none"
            break;
        case "stopSquare":
            _self.PO_mode = "none"
            break;
        case "gemDetected":
            _self.saveGems = _self.saveGems + Int(value)!;
            saveRecord();
            showGemView();
            break;
        case "protectorReady":
            self.showProtectCountDownView()
            break;
        default:
            break;
            
            
        }

    
    }
    func handelJSEvent(_ notification: NSNotification) {
        let _self = self;
        
        if let method = notification.userInfo?["method"] as? String {
            
            if let value = notification.userInfo?["value"] as? String {
                if(method != "console"){
                    print("[\(method)] \(value)")
                }
                
                DispatchQueue.main.async {
                    _self.handelJSReceivedData(method: method, value: value)
                }
                
            }
        }
    }
    
    /*
     
     TIMER
     
     */
    
    func startTimer(){
        timer.invalidate() // just in case this button is tapped multiple times
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer.invalidate() // just in case this button is tapped multiple times
        
    }
    func resetTimer(){
        timer.invalidate() // just in case this button is tapped multiple times
        timerCounter = 0
        
    }
    func timerAction() {
        timerCounter += 1
        let min = timerCounter / 60;
        let sec = timerCounter % 60;
        if(sec < 10){
            self.mainViewTimeLeft.text = "\(min):0\(sec)"
        }   else{
            self.mainViewTimeLeft.text = "\(min):\(sec)"
        }
        
    }

    /*
 
     PUBLIC METHOD
     
     */
    func formatMineDisplay(mineInput: Int) -> String{
        var mi = mineInput;
        var displayedMine = "";
        var mineSign = "";
        
        if(mineInput < 0){
            mineSign = "-";
            mi = mineInput * (-1)
        }
        
        if(mi < 10){
            displayedMine = "\(mineSign)00\(mi)"
        }   else if(mi < 100){
            displayedMine = "\(mineSign)0\(mi)"
        }   else{
            displayedMine = "\(mineSign)\(mi)"
        }
        return displayedMine

    }
    func getTimestamp() -> String{
        return "\(Int(NSDate().timeIntervalSince1970))";
    }
    
    func timestamp2Date(timestamp: String) -> String{
        if let ts = Int(timestamp){
            let date = NSDate(timeIntervalSince1970: Double(ts))
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY"
            
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return dateString

        }   else{
            let date = NSDate(timeIntervalSince1970: 0.0)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "MMM dd, YYYY"
            
            let dateString = dayTimePeriodFormatter.string(from: date as Date)
            return dateString

        }
        
    
        
    }
    func min2Sec(time: String) -> Int{

        let timeArr = time.characters.split{$0 == ":"}.map(String.init)
        return (Int(timeArr[0])! * 60 + Int(timeArr[1])!)

    }
    func sec2Min(time: String) -> String{
        
        let sec = Int(time)!
        let newSec = sec%60
        var newSecStr = "\(newSec)"
        if(newSec < 10){
            newSecStr = "0\(newSec)"
        }
        return ("\(sec/60):\(newSecStr)")
        
    }
    
    
    /*
 
     STORAGE SETUP
     
     */
    
    
    
    func keyValueStoreDidChange(_ notification: NSNotification) {
        if let savedString = iCloudKeyStore?.string(forKey: iCloudTextKey) {
            print("String Saved: \(savedString)")
        }
    }
    func iCloudSetUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyValueStoreDidChange(_:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudKeyStore)
        iCloudKeyStore?.synchronize()
    }

    func saveToiCloud(key: String, value: String) {
        iCloudKeyStore?.set(value, forKey: key)
        iCloudKeyStore?.synchronize()
    }
    
    func localSetUp() {
        NotificationCenter.default.removeObserver(self, name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: iCloudKeyStore)
        
        if let savedString = defaultKeyStore?.string(forKey: DefaultsTextKey) {
            print("String Saved: \(savedString)")
        }
    }
    func saveLocally(key: String, value: String) {
        defaultKeyStore?.set(value, forKey: key)
        defaultKeyStore?.synchronize()
    }
    
    func saveRecord(){
        print("RECORD SAVED");
        print("Coins: \(saveCoins), Gems: \(saveGems)");
        UserDefaults.standard.set(lv_1_Statistics, forKey: "lv_1_Statistics")
        UserDefaults.standard.set(lv_2_Statistics, forKey: "lv_2_Statistics")
        UserDefaults.standard.set(lv_3_Statistics, forKey: "lv_3_Statistics")
        UserDefaults.standard.set(lv_4_Statistics, forKey: "lv_4_Statistics")
        UserDefaults.standard.set(saveCoins, forKey: "coin")
        UserDefaults.standard.set(saveGems, forKey: "gem")
        UserDefaults.standard.set(powerUp1, forKey: "powerUp1")
        UserDefaults.standard.set(powerUp2, forKey: "powerUp2")
        UserDefaults.standard.set(powerUp3, forKey: "powerUp3")
        UserDefaults.standard.set(dailyCheckIn, forKey: "dailyCheckIn")

        UserDefaults.standard.synchronize()
        
    }
    func getRecord() {
        
        if let result = UserDefaults.standard.value(forKey: "lv_1_Statistics"){
            lv_1_Statistics = result as! [String : String];
        }   else {
            UserDefaults.standard.set(lv_1_Statistics, forKey: "lv_1_Statistics")
        }
        
        if let result = UserDefaults.standard.value(forKey: "lv_2_Statistics"){
            lv_2_Statistics = result as! [String : String];
        }   else {
            UserDefaults.standard.set(lv_2_Statistics, forKey: "lv_2_Statistics")
        }
        
        if let result = UserDefaults.standard.value(forKey: "lv_3_Statistics"){
            lv_3_Statistics = result as! [String : String];
        }   else {
            UserDefaults.standard.set(lv_3_Statistics, forKey: "lv_3_Statistics")
        }
        
        if let result = UserDefaults.standard.value(forKey: "lv_4_Statistics"){
            lv_4_Statistics = result as! [String : String];
        }   else {
            UserDefaults.standard.set(lv_4_Statistics, forKey: "lv_4_Statistics")
        }
        
        if let result = UserDefaults.standard.value(forKey: "coin"){
            
            saveCoins = result as! Int
        }   else {
            let tempCoin = Int(lv_1_Statistics["totalMineSweeped"]!)! + Int(lv_2_Statistics["totalMineSweeped"]!)! + Int(lv_3_Statistics["totalMineSweeped"]!)! + Int(lv_4_Statistics["totalMineSweeped"]!)!
            saveCoins = tempCoin
            UserDefaults.standard.set(tempCoin, forKey: "coin")
        }
        if let result = UserDefaults.standard.value(forKey: "gem"){
            saveGems = result as! Int

        }   else {
            saveGems = 0
            UserDefaults.standard.set(saveGems, forKey: "gem")
        }
        
        if let result = UserDefaults.standard.value(forKey: "powerUp1"){
            powerUp1 = result as! [String : Int];
        }   else {
            UserDefaults.standard.set(powerUp1, forKey: "powerUp1")
        }
        
        if let result = UserDefaults.standard.value(forKey: "powerUp2"){
            powerUp2 = result as! [String : Int];
        }   else {
            UserDefaults.standard.set(powerUp2, forKey: "powerUp2")
        }

        if let result = UserDefaults.standard.value(forKey: "powerUp3"){
            powerUp3 = result as! [String : Int];
        }   else {
            UserDefaults.standard.set(powerUp3, forKey: "powerUp3")
        }
        if let result = UserDefaults.standard.value(forKey: "dailyCheckIn"){
            dailyCheckIn = result as! [String : Int];
        }   else {
            UserDefaults.standard.set(dailyCheckIn, forKey: "dailyCheckIn")
        }

        


        print (lv_1_Statistics)
        print (lv_2_Statistics)
        print (lv_3_Statistics)
        print (lv_4_Statistics)
        
        
    }
    func winRecord(){
        var currentStatistics = getCurrentStatistics(level: currentLevel)
        let totalWin = Int(currentStatistics["totalWin"]!)!;
        let totalLose = Int(currentStatistics["totalLose"]!)!;
        let avgTime = Int(currentStatistics["averageTime"]!)!;
        let avgTimeWin = Int(currentStatistics["averageTimeWin"]!)!;
        let expPercent = Int(currentStatistics["explorationPercentage"]!)!;
        let totalGameFinished = totalWin + totalLose;
        let totalNumberOfBlocks = gameHeight * gameWidth;
        let cTime = self.timerCounter
        let percentageCompleted = ((checked * 100) / (totalNumberOfBlocks - totalMines));
        
        let longestGame = Int(currentStatistics["longestGame"]!)!
        let longestWin = Int(currentStatistics["longestWin"]!)!
        
        
        let newWin = totalWin + 1
        let newAvgTime = ((avgTime * totalGameFinished) + cTime) / (totalGameFinished + 1)
        let newAvgTimeWin = ((avgTimeWin * totalWin) + cTime) / (totalWin + 1)
        let newExpPercent = ((expPercent * totalGameFinished) + percentageCompleted) / (totalGameFinished + 1)
        let newChecked = Int(currentStatistics["totalChecked"]!)! + Int(self.checked)
        let newMineSweeped = Int(currentStatistics["totalMineSweeped"]!)! + Int(self.sweepCorrected)
        
        if(longestGame < cTime){
            updateSingleRecord(level: currentLevel, name: "longestGame", value: cTime as AnyObject)
        }
        if(longestWin < cTime){
            updateSingleRecord(level: currentLevel, name: "longestWin", value: cTime as AnyObject)
        }
        updateSingleRecord(level: currentLevel, name: "averageTime", value: newAvgTime as AnyObject)
        updateSingleRecord(level: currentLevel, name: "averageTimeWin", value: newAvgTimeWin as AnyObject)
        updateSingleRecord(level: currentLevel, name: "explorationPercentage", value: newExpPercent as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalWin", value: newWin as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalChecked", value: newChecked as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalMineSweeped", value: newMineSweeped as AnyObject)
        
        var cPlace = 11;
        
        for i in (0...9).reversed(){
            print("[SAVE] Checking record No. \(i+1)")
            let thisTimeRecord = Int(currentStatistics["\(i+1)_Record"]!)!;
            if(thisTimeRecord != 0){
                print("[SAVE] Record No. \(i+1): \(thisTimeRecord), this time: \(cTime)")
                if(thisTimeRecord < cTime){
                    print("[SAVE] Save to No. \(i+2)")
                    cPlace = i + 1
                    updateSingleRecord(level: currentLevel, name: "\(i+2)_Record", value: cTime as AnyObject)
                    updateSingleRecord(level: currentLevel, name: "\(i+2)_Date", value: getTimestamp() as AnyObject)
                    updateSingleRecord(level: currentLevel, name: "\(i+2)_Map", value: currentMap as AnyObject)
                    break;
                }   else if(i < 9){
                    print("[SAVE] Old No. \(i+1) move to No. \(i+2)")
                    updateSingleRecord(level: currentLevel, name: "\(i+2)_Record", value: thisTimeRecord as AnyObject)
                    updateSingleRecord(level: currentLevel, name: "\(i+2)_Date", value: currentStatistics["\(i+1)_Date"] as AnyObject)
                    updateSingleRecord(level: currentLevel, name: "\(i+2)_Map", value: currentMap as AnyObject)
                    
                    if(i == 0){
                        cPlace = i + 1
                        print("[SAVE] Save to No. \(i+i)")
                        updateSingleRecord(level: currentLevel, name: "\(i+1)_Record", value: cTime as AnyObject)
                        updateSingleRecord(level: currentLevel, name: "\(i+1)_Date", value: getTimestamp() as AnyObject)
                        updateSingleRecord(level: currentLevel, name: "\(i+1)_Map", value: currentMap as AnyObject)
                        
                    }

                }
            }   else if(i == 0){
                cPlace = i + 1
                print("[SAVE] Save to No. \(i+i)")
                updateSingleRecord(level: currentLevel, name: "\(i+1)_Record", value: cTime as AnyObject)
                updateSingleRecord(level: currentLevel, name: "\(i+1)_Date", value: getTimestamp() as AnyObject)
                updateSingleRecord(level: currentLevel, name: "\(i+1)_Map", value: currentMap as AnyObject)

            }
        }
        if(cPlace < 6){
            
        }
        
        saveRecord();

    }
    
    func loseRecord(){
        var currentStatistics = getCurrentStatistics(level: currentLevel)
                
        let totalWin = Int(currentStatistics["totalWin"]!)!;
        let totalLose = Int(currentStatistics["totalLose"]!)!;
        let avgTime = Int(currentStatistics["averageTime"]!)!;
        let avgTimeLose = Int(currentStatistics["averageTimeLose"]!)!;
        let expPercent = Int(currentStatistics["explorationPercentage"]!)!;
        let totalGameFinished = totalWin + totalLose;
        let totalNumberOfBlocks = gameHeight * gameWidth;
        let cTime = timerCounter
        let percentageCompleted = ((checked * 100) / (totalNumberOfBlocks - totalMines));
        
        let longestGame = Int(currentStatistics["longestGame"]!)!
        let longestLose = Int(currentStatistics["longestLose"]!)!
        let shortestLose = Int(currentStatistics["shortestLose"]!)!
        
        let newLose = totalLose + 1
        let newAvgTime = ((avgTime * totalGameFinished) + cTime) / (totalGameFinished + 1)
        let newAvgTimeLose = ((avgTimeLose * totalLose) + cTime) / (totalLose + 1)
        let newExpPercent = ((expPercent * totalGameFinished) + percentageCompleted) / (totalGameFinished + 1)
        let newChecked = Int(currentStatistics["totalChecked"]!)! + Int(self.checked)
        let newMineSweeped = Int(currentStatistics["totalMineSweeped"]!)! + Int(self.sweepCorrected)
        let newMineSweepedWrong = Int(currentStatistics["totalMineSweepedWrong"]!)! + Int(self.sweepNotCorrected)
        
        //Add Coin
        saveCoins = Int(self.sweepCorrected) + saveCoins;

        if(longestGame < cTime){
            updateSingleRecord(level: currentLevel, name: "longestGame", value: cTime as AnyObject)
        }
        
        if(longestLose < cTime){
            updateSingleRecord(level: currentLevel, name: "longestLose", value: cTime as AnyObject)
        }
        if(shortestLose != 0){
            if(shortestLose > cTime){
                updateSingleRecord(level: currentLevel, name: "shortestLose", value: cTime as AnyObject)
            }
        }
        
        updateSingleRecord(level: currentLevel, name: "averageTime", value: newAvgTime as AnyObject)
        updateSingleRecord(level: currentLevel, name: "averageTimeLose", value: newAvgTimeLose as AnyObject)
        updateSingleRecord(level: currentLevel, name: "explorationPercentage", value: newExpPercent as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalLose", value: newLose as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalChecked", value: newChecked as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalMineSweeped", value: newMineSweeped as AnyObject)
        updateSingleRecord(level: currentLevel, name: "totalMineSweepedWrong", value: newMineSweepedWrong as AnyObject)
        saveRecord();
        
        
        
    }
    
    func startRecord(){
        var currentStatistics = getCurrentStatistics(level: currentLevel)
        let totalGame = Int(currentStatistics["totalGame"]!)! + 1;
        updateSingleRecord(level: currentLevel, name: "totalGame", value: totalGame as AnyObject)
        saveRecord();
    }
    func getCurrentStatistics(level: Int) -> [String:String]{
        //print("[LEVEL_\(level)] Getting Statistics")
        var currentStatistics: [String:String] = [:];
        switch(level){
        case 1:
            currentStatistics = self.lv_1_Statistics;
            break;
        case 2:
            currentStatistics = self.lv_2_Statistics;
            break;
        case 3:
            currentStatistics = self.lv_3_Statistics;
            break;
        case 4:
            currentStatistics = self.lv_4_Statistics;
            break;
        default:
            break;
        }
        return currentStatistics;
    }
    
    func updateSingleRecord(level: Int, name: String, value: AnyObject){
        switch(level){
        case 1:
            if self.lv_1_Statistics[name] != nil{
                self.lv_1_Statistics[name] = "\(value)"
            }
            break;
        case 2:
            if self.lv_2_Statistics[name] != nil{
                self.lv_2_Statistics[name] = "\(value)"
            }
            break;
        case 3:
            if self.lv_3_Statistics[name] != nil{
                self.lv_3_Statistics[name] = "\(value)"
            }
            break;
        case 4:
            if self.lv_4_Statistics[name] != nil{
                self.lv_4_Statistics[name] = "\(value)"
            }
            break;
        default:
            break;
        }

        
        
        print("[UPDATE] Lv.\(level) \(name): \(value)");
        print()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.tableView {
            return 4
        }   else if tableView == self.dealsTableView {
            return 1
        }   else if tableView == self.currencyTableView {
            return 1
        }   else if tableView == self.abilitiesTableView {
            return 1
        }   else if tableView == self.passesTableView {
            return 1
        }   else   {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return 7
        }   else if tableView == self.dealsTableView {
            return 2
        }   else if tableView == self.currencyTableView {
            return 3
        }   else if tableView == self.abilitiesTableView {
            return 3
        }   else if tableView == self.passesTableView {
            return 2
        }   else   {
            return 3
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.tableView {
            switch (indexPath.row){
            case 0:
                return 60.0;
            case 6:
                return 180.0;
            default:
                return 50.0
            }
        }   else if tableView == self.dealsTableView {
            return 120.0
        }   else if tableView == self.currencyTableView {
            return 120.0
        }   else if tableView == self.abilitiesTableView {
            return 120.0
        }   else if tableView == self.passesTableView {
            return 120.0
        }   else   {
            return 120.0
        }
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == self.tableView) {
            switch (indexPath.row){
            case 0:
                let identfier = "lbTitleCell"
                let cell:leaderboardTitleableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identfier) as! leaderboardTitleableViewCell
                cell.selectionStyle = .none
                
                switch (indexPath.section){
                case 0:
                    cell.titleLabel.text = "Easy Mode"
                    break;
                case 1:
                    cell.titleLabel.text = "Medium Mode"
                    break;
                case 2:
                    cell.titleLabel.text = "Expert Mode"
                    break;
                case 3:
                    cell.titleLabel.text = "Crazy Mode"
                    break;
                default:
                    break;
                }
                return cell
            case 6:
                let identfier = "lbContentCell"
                let cell:leaderboardContentableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identfier) as! leaderboardContentableViewCell
                cell.selectionStyle = .none
                
                let currentStatistics = getCurrentStatistics(level: (indexPath.section + 1))
                
                print("\n\n//////////////////////////")
                print("        STATISTICS \(indexPath.section + 1)      ")
                print("//////////////////////////\n")
                print("1st Record: \(currentStatistics["1_Date"]!) - \(currentStatistics["1_Record"]!)s")
                print("2nd Record: \(currentStatistics["2_Date"]!) - \(currentStatistics["2_Record"]!)s")
                print("3rd Record: \(currentStatistics["3_Date"]!) - \(currentStatistics["3_Record"]!)s")
                print("4th Record: \(currentStatistics["4_Date"]!) - \(currentStatistics["4_Record"]!)s")
                print("5th Record: \(currentStatistics["5_Date"]!) - \(currentStatistics["5_Record"]!)s")
                
                print("Average Time: \(currentStatistics["averageTime"]!)")
                print("Average Win Time: \(currentStatistics["averageTimeWin"]!)")
                print("Average Lose Time: \(currentStatistics["averageTimeLose"]!)")
                print("Average Exploration Percentage: \(currentStatistics["explorationPercentage"]!)")
                print("Total Wins: \(currentStatistics["totalWin"]!)")
                print("Total Loses: \(currentStatistics["totalLose"]!)")
                print("Total Games: \(currentStatistics["totalGame"]!)")
                print("Longest Game: \(currentStatistics["longestGame"]!)s")
                print("Longest Win Game: \(currentStatistics["longestWin"]!)s")
                print("Longest Lose Game: \(currentStatistics["longestLose"]!)s")
                print("Shortest Lose Game: \(currentStatistics["shortestLose"]!)s")
                print("Total Checked Block: \(currentStatistics["totalChecked"]!)")
                print("Total Mine Sweeped: \(currentStatistics["totalMineSweeped"]!)")
                print("Total Mine Sweeped Wrong: \(currentStatistics["totalMineSweepedWrong"]!)")
                
                cell.lbContent.text = "Average Time:\nExploration Percentage:\nTotal Wins:\nTotal Loses:\nTotal Games:\nTotal Mine Sweeped:";
                cell.lbContentValue.text = "\(sec2Min(time: currentStatistics["averageTime"]!))\n\(currentStatistics["explorationPercentage"]!)%\n\(currentStatistics["totalWin"]!)\n\(currentStatistics["totalLose"]!)\n\(currentStatistics["totalGame"]!)\n\(currentStatistics["totalMineSweeped"]!)"
                return cell
                
            default:
                let identfier = "cell"
                let cell:leaderboardTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: identfier) as! leaderboardTableViewCell
                
                switch (indexPath.row){
                case 0:
                    
                    cell.cellBG.backgroundColor = UIColor.clear
                    break;
                case 1:
                    //let themeColor = UIColor(red: 227/255, green: 110/255, blue: 91/255, alpha: 1.0)
                    let themeColor = UIColor(red: 180/255, green: 56/255, blue: 59/255, alpha: 1.0)
                    cell.cellBG.backgroundColor = themeColor
                    cell.numberLabel.textColor = themeColor
                    break;
                case 2:
                    //let themeColor = UIColor(red: 197/255, green: 91/255, blue: 81/255, alpha: 1.0)
                    let themeColor = UIColor(red: 149/255, green: 52/255, blue: 65/255, alpha: 1.0)
                    cell.cellBG.backgroundColor = themeColor
                    cell.numberLabel.textColor = themeColor
                    break;
                case 3:
                    //let themeColor = UIColor(red: 190/255, green: 85/255, blue: 78/255, alpha: 1.0)
                    let themeColor = UIColor(red: 149/255, green: 58/255, blue: 86/255, alpha: 1.0)
                    cell.cellBG.backgroundColor = themeColor
                    cell.numberLabel.textColor = themeColor
                    break;
                case 4:
                    //let themeColor = UIColor(red: 186/255, green: 82/255, blue: 78/255, alpha: 1.0)
                    let themeColor = UIColor(red: 133/255, green: 58/255, blue: 99/255, alpha: 1.0)
                    cell.cellBG.backgroundColor = themeColor
                    cell.numberLabel.textColor = themeColor
                    break;
                case 5:
                    //let themeColor = UIColor(red: 155/255, green: 66/255, blue: 66/255, alpha: 1.0)
                    let themeColor = UIColor(red: 123/255, green: 62/255, blue: 116/255, alpha: 1.0)
                    cell.cellBG.backgroundColor = themeColor
                    cell.numberLabel.textColor = themeColor
                    break;
                case 6:
                    cell.cellBG.backgroundColor = UIColor.clear
                    break;
                default:
                    cell.cellBG.backgroundColor = UIColor.clear
                    break;
                }
                cell.selectionStyle = .none
                cell.numberLabel.text = "\(indexPath.row)"
                
                let currentStatistics = getCurrentStatistics(level: (indexPath.section + 1))
                
                if let currentRecordDate = currentStatistics["\(indexPath.row)_Date"] {
                    print("Loading \(indexPath.section + 1)-\(indexPath.row)")
                    if(currentRecordDate != "0"){
                        cell.dateLabel.text = self.timestamp2Date(timestamp: currentRecordDate)
                        cell.recordLabel.text = "\(String(describing: sec2Min(time: currentStatistics["\(indexPath.row)_Record"]!)))"
                    }   else{
                        cell.dateLabel.text = "N/A"
                        cell.recordLabel.text = "N/A"
                    }
                }
                
                
                
                return cell
            }

        }   else if tableView == self.dealsTableView {
            
            
            let identfier = "storeTbCell"
            let cell:storeElementTableViewCell = self.dealsTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
            cell.storeElementTitleConstraintsTop.constant = 35.0
            cell.storeElementBarContainer.isHidden = true;
            cell.storeElementButton.tag = indexPath.row
            cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromDealsTableView(sender:)), for: UIControlEvents.touchUpInside)
            
            switch (indexPath.row){
            case 0:
                cell.storeElementImage.image = UIImage(named: "gift_coin")
                cell.storeElementTitle.text = "Gift Coin By TT"
                cell.storeElementDescription.text = "Free coins from some loves you"
                cell.storeElementButton.setTitle("FREE", for: .normal)
                cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
                cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                break;
            case 1:
                cell.storeElementImage.image = UIImage(named: "gift_gem")
                cell.storeElementTitle.text = "Gift Gem By TT"
                cell.storeElementDescription.text = "Free gem from some loves you"
                cell.storeElementButton.setTitle("FREE", for: .normal)
                cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
                cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
                break;
            default:
                break;
            }
            let buttonRow = indexPath.row
            var giftName = ""
            
            if(buttonRow == 0){
                giftName = "Coin"
            }   else if(buttonRow == 1){
                giftName = "Gem"
            }
            let timeIntival = Int(getTimestamp())! - self.dailyCheckIn["lastClaim\(giftName)"]!
            
            if(timeIntival < 86400){
                cell.storeElementButton.setTitle("SOLD OUT", for: .normal)
            }

            
            return cell
            
            
        }   else if tableView == self.currencyTableView {
            
            
            let identfier = "storeTbCell"
            let cell:storeElementTableViewCell = self.currencyTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
            cell.storeElementTitleConstraintsTop.constant = 35.0
            cell.storeElementBarContainer.isHidden = true;
            cell.storeElementButton.tag = indexPath.row
            cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromCurrencyTableView(sender:)), for: UIControlEvents.touchUpInside)
            
            switch (indexPath.row){
            case 3:
                break;
            default:
                if(indexPath.row < 3){
                    cell.storeElementTitle.text = "\(String(describing: self.priceList["currency_\(indexPath.row + 1)_product"]!)) Coins"
                    
                    switch (self.priceList["currency_\(indexPath.row + 1)_price_type"]!){
                    case 1:
                        cell.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                        break;
                    case 2:
                        cell.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                        break;
                    default:
                        break;
                    }
                    cell.storeElementImage.image = UIImage(named: "moneyBag_\(indexPath.row)")
                    cell.storeElementButton.setTitle("\(self.priceList["currency_\(indexPath.row + 1)_price"]!)", for: .normal)
                    cell.storeElementDescription.text = "Use \(self.priceList["currency_\(indexPath.row + 1)_price"]!) gem to exchange \(String(describing: self.priceList["currency_\(indexPath.row + 1)_product"]!)) coins"

                }
                break;
            }
            return cell
            
            
        }   else if tableView == self.abilitiesTableView {
            
            
            let identfier = "storeTbCell"
            let cell:storeElementTableViewCell = self.abilitiesTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
            
            cell.storeElementButton.tag = indexPath.row
            cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromAblititiesTableView(sender:)), for: UIControlEvents.touchUpInside)
            
            
            var remaining = 0
            var name = ""
            
            switch (indexPath.row){
            case 0:
                if((self.powerUp1["level"]!) == 0){
                    cell.storeElementTitle.text = "Unlock Mines X-Ray"
                }   else    {
                    cell.storeElementTitle.text = "Mines X-Ray \(self.powerUp1Range[(self.powerUp1["level"]! + 1)])"
                }
                
                cell.storeElementDescription.text = "Expand Mines X-Ray Range"
                
                cell.storeElementImage.image = UIImage(named: "xray_lv");
                remaining =  powerUp1["level"]!
                name = "Ability_XRay_lv_";
                //cell.storeElementProgress.image = UIImage(named: "progress_long_\(String(describing: powerUp1["level"]!))");
                break;
            case 1:
                if((self.powerUp1["level"]!) == 0){
                    cell.storeElementTitle.text = "Unlock Crazy Sweeper"
                }   else    {
                    cell.storeElementTitle.text = "Crazy Sweeper \(self.powerUp2Range[(self.powerUp2["level"]! + 1)])"
                }

                
                cell.storeElementDescription.text = "Expand Crazy Click Range"
                cell.storeElementImage.image = UIImage(named: "crazy_lv");
                remaining =  powerUp2["level"]!
                name = "Ability_Sweeper_lv_";
                //cell.storeElementProgress.image = UIImage(named: "progress_long_\(String(describing: powerUp2["level"]!))");
                break;
            case 2:
                cell.storeElementTitle.text = "Mine Protector Time \(self.powerUp2TimeLimit[(self.powerUp2["time"]! + 1)])"
                cell.storeElementDescription.text = "Expand Crazy Click Time"
                cell.storeElementImage.image = UIImage(named: "crazy_time");
                remaining =  powerUp2["time"]!
                name = "Ability_Sweeper_time_";
                //cell.storeElementProgress.image = UIImage(named: "progress_long_\(String(describing: powerUp2["time"]!))");
                break;
                
            case 3:
                if((self.powerUp1["level"]!) == 0){
                    cell.storeElementTitle.text = "Unlock Mine Protector"
                }   else    {
                    cell.storeElementTitle.text = "Mine Protector\(self.powerUp2Range[(self.powerUp2["level"]! + 1)]) Upgrade"
                }
                
                cell.storeElementDescription.text = "Expand Mine Protector Usage"
                cell.storeElementImage.image = UIImage(named: "mine");
                remaining =  powerUp3["level"]!
                name = "Ability_Protector_lv_";
                //cell.storeElementProgress.image = UIImage(named: "progress_long_\(String(describing: powerUp3["level"]!))");
                break;

            default:
                break;
            }
            if(remaining >= 5){
                cell.storeElementButton.setTitle("SOLD OUT", for: .normal)
                cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
                cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            }   else{
                cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, -80.0, 0, 0)
                switch (self.priceList["\(name)\(remaining + 1)_type"]!){
                case 1:
                    cell.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                    break;
                case 2:
                    cell.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                    break;
                default:
                    break;
                }
                cell.storeElementButton.setTitle("\(self.priceList["\(name)\(remaining + 1)"]!)", for: .normal)

            }
            
            switch(remaining){
            case 1:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = true;
                cell.storeElementProgress_3.isHidden = true;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
                
            case 2:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = true;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
            case 3:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = false;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
            case 4:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = false;
                cell.storeElementProgress_4.isHidden = false;
                cell.storeElementProgress_5.isHidden = true;
                break;
            case 5:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = false;
                cell.storeElementProgress_4.isHidden = false;
                cell.storeElementProgress_5.isHidden = false;
                break;
            default:
                cell.storeElementProgress_1.isHidden = true;
                cell.storeElementProgress_2.isHidden = true;
                cell.storeElementProgress_3.isHidden = true;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
                
            }


            
            return cell
            
            
        }   else if tableView == self.passesTableView {
            
            
            let identfier = "storeTbCell"
            let cell:storeElementTableViewCell = self.passesTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
            
            cell.storeElementButton.tag = indexPath.row
            cell.storeElementButton.addTarget(self, action: #selector(self.buttonClickedFromPassesTableView(sender:)), for: UIControlEvents.touchUpInside)
            
            var remaining = 0
            var name = ""
            
            switch (indexPath.row){
            case 0:
                cell.storeElementTitle.text = "Mines X-Ray"
                cell.storeElementImage.image = UIImage(named: "xray_pass");
                cell.storeElementDescription.text = "Wanna see what's underground?"
                remaining =  powerUp1["remaining"]!
                name = "Passes_XRay";
                
                break;
            case 1:
                cell.storeElementTitle.text = "Crazy Sweeper"
                cell.storeElementImage.image = UIImage(named: "crazy_pass");
                cell.storeElementDescription.text = "Go CRAZY and click EVERYWHERE!"
                remaining =  powerUp2["remaining"]!
                name = "Passes_Sweeper";
                break;
            case 2:
                cell.storeElementTitle.text = "Mine Protector"
                cell.storeElementImage.image = UIImage(named: "mine");
                cell.storeElementDescription.text = "Never have to worry about SWEEP WRONG!"
                remaining =  powerUp3["remaining"]!
                name = "Passes_Protector";
                break;
            default:
                break;
            }
            
            
            if(remaining == 5){
                cell.storeElementButton.setTitle("SOLD OUT", for: .normal)
                cell.storeElementButton.setImage(UIImage(named:""), for: .normal)
                cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
            }   else{
                cell.storeElementButton.titleEdgeInsets = UIEdgeInsetsMake(0, -80.0, 0, 0)
                switch (self.priceList["\(name)_type"]!){
                case 1:
                    cell.storeElementButton.setImage(UIImage(named:"coin"), for: .normal)
                    break;
                case 2:
                    cell.storeElementButton.setImage(UIImage(named:"gem"), for: .normal)
                    break;
                default:
                    break;
                }
                cell.storeElementButton.setTitle("\(self.priceList["\(name)"]!)", for: .normal)
                
            }

            switch(remaining){
            case 1:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = true;
                cell.storeElementProgress_3.isHidden = true;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
                
            case 2:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = true;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
            case 3:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = false;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
            case 4:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = false;
                cell.storeElementProgress_4.isHidden = false;
                cell.storeElementProgress_5.isHidden = true;
                break;
            case 5:
                cell.storeElementProgress_1.isHidden = false;
                cell.storeElementProgress_2.isHidden = false;
                cell.storeElementProgress_3.isHidden = false;
                cell.storeElementProgress_4.isHidden = false;
                cell.storeElementProgress_5.isHidden = false;
                break;
            default:
                cell.storeElementProgress_1.isHidden = true;
                cell.storeElementProgress_2.isHidden = true;
                cell.storeElementProgress_3.isHidden = true;
                cell.storeElementProgress_4.isHidden = true;
                cell.storeElementProgress_5.isHidden = true;
                break;
                
            }

            return cell
            
            
        }   else   {
            
            
            let identfier = "storeTbCell"
            let cell:storeElementTableViewCell = self.abilitiesTableView.dequeueReusableCell(withIdentifier: identfier) as! storeElementTableViewCell
            return cell
            
            
        }

        
    }
    
    func buttonClickedFromPassesTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        
        switch (buttonRow){
        case 0:
            if((powerUp1["remaining"])! < 5){
                let priceName = "Passes_XRay"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
            
                if(deductFromMoney(price: price, type: priceType)){
                    let oldValue = self.powerUp1["remaining"]!
                    self.powerUp1["remaining"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }

            }   else{
                notifyUser("CAUTION", message: "5 is Enough, Man!")
            }
            
            break;
        case 1:
            if((powerUp2["remaining"])! < 5){
                let priceName = "Passes_Sweeper"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    let oldValue = self.powerUp2["remaining"]!
                    self.powerUp2["remaining"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                notifyUser("CAUTION", message: "5 is Enough, Man!")
            }
            break;
        case 2:
            if((powerUp3["remaining"])! < 5){
                let priceName = "Passes_Protector"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    let oldValue = self.powerUp3["remaining"]!
                    self.powerUp3["remaining"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                notifyUser("CAUTION", message: "5 is Enough, Man!")
            }
            break;
        default:
            break;
        }
        
        passesTableView.reloadData()

    }
    
    func buttonClickedFromAblititiesTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")

        switch (buttonRow){
        case 0:
            if((powerUp1["level"])! < 5){
                let oldValue = self.powerUp1["level"]!
                let priceName = "Ability_XRay_lv_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp1["level"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }
            
            break;
        case 1:
            
            if((powerUp2["level"])! < 5){
                let oldValue = self.powerUp2["level"]!
                let priceName = "Ability_Sweeper_lv_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp2["level"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }

            break;
        case 2:
            if((powerUp2["time"])! < 5){
                let oldValue = self.powerUp2["time"]!
                let priceName = "Ability_Sweeper_time_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp2["time"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }

            break;
        case 3:
            if((powerUp3["level"])! < 5){
                let oldValue = self.powerUp3["level"]!
                let priceName = "Ability_protector_lv_\(oldValue + 1)"
                let price = self.priceList["\(priceName)"]!
                let priceType = self.priceList["\(priceName)_type"]!
                
                if(deductFromMoney(price: price, type: priceType)){
                    self.powerUp3["level"] = oldValue + 1;
                    saveRecord()
                }   else    {
                    notifyUser("CAUTION", message: "Insufficient Fund")
                }
                
            }   else{
                notifyUser("CAUTION", message: "You CANNOT go up if you are already on the top! What do you say?")
            }
            break;

        default:
            break;
        }
        
        
        abilitiesTableView.reloadData()
    }
    func buttonClickedFromCurrencyTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        
        
        if(buttonRow < 3){
            let price = self.priceList["currency_\(buttonRow + 1)_price"]!
            let priceType = self.priceList["currency_\(buttonRow + 1)_price_type"]!
            let addPrice = (-1) * (self.priceList["currency_\(buttonRow + 1)_product"]!)
            let addPriceType = self.priceList["currency_\(buttonRow + 1)_product_type"]!
            if(deductFromMoney(price: price, type: priceType)){
                print("Adding Coins \(addPrice)");
                _ = deductFromMoney(price: addPrice, type: addPriceType)
                saveRecord()
            }   else    {
                notifyUser("CAUTION", message: "Insufficient Fund")
            }
        }
        currencyTableView.reloadData()
        
    }
    
    func buttonClickedFromDealsTableView(sender:UIButton) {
        
        let buttonRow = sender.tag
        print("\(buttonRow) Button Clicked")
        var giftName = ""
        
        if(buttonRow < 2){
            if(buttonRow == 0){
                giftName = "Coin"
            }   else if(buttonRow == 1){
                giftName = "Gem"
            }
            let timeIntival = Int(getTimestamp())! - self.dailyCheckIn["lastClaim\(giftName)"]!
            
            if(timeIntival > 86400){
                _ = deductFromMoney(price: ((-1) * self.dailyCheckIn["\(giftName)"]!), type: (buttonRow + 1))
                self.dailyCheckIn["lastClaim\(giftName)"] = Int(getTimestamp())!
                saveRecord();
            }   else{
                notifyUser("CAUTION", message: "Get more \(giftName) tomorrow!")
            }
            
        }
        dealsTableView.reloadData()
        
    }


    
    func deductFromMoney(price: Int, type: Int) -> Bool{
        switch(type){
        case 1:
            let newBlance = self.saveCoins - price
            if(newBlance >= 0){
                let oldValue = self.saveCoins;
                saveCoins = saveCoins - price
                self.coinStoreView.countFrom(CGFloat(oldValue), to: CGFloat(saveCoins), withDuration: 1.0)
                
            }   else{
                return false;
            }
            
            break;
        case 2:
            let newBlance = self.saveGems - price
            if(newBlance >= 0){
                
                let oldValue = self.saveGems;
                saveGems = saveGems - price
                self.gemStoreView.countFrom(CGFloat(oldValue), to: CGFloat(saveGems), withDuration: 1.0)
                
            }   else{
                return false;
            }
            break;
        default:
            return true;
            
        }
        return true
    }

    func progressDesplay(cell:storeElementTableViewCell, progress: Int) -> storeElementTableViewCell{
                return cell

    }
    
    func notifyUser(_ title: String, message: String) -> Void{
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    func executeJS(jsCode: String){
        mineWebView.stringByEvaluatingJavaScript(from: jsCode)
    }
    
}
extension ViewController : UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        jsContext = self.mineWebView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptMethod(), forKeyedSubscript: "callSwift" as NSCopying & NSObjectProtocol)
        
    }
}
class leaderboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var numberCircle: UIView!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
class leaderboardTitleableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
class leaderboardContentableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBG: UIView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var lbContentValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectBox.borderColors(UIColor(red: 0, green: 0, blue: 0, alpha: 0.1))
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}

