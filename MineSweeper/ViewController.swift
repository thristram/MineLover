//
//  ViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 5/17/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
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


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    var iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
    var defaultKeyStore: UserDefaults? = UserDefaults.standard
    let iCloudTextKey = "iCloudText"
    let DefaultsTextKey = "DefaultsText"
    
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
    
    var timerCounter = 0;
    var timer = Timer()


    
    var ifReadLove = false;
    var jsContext : JSContext!
    
    
    
    
    

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

    
    
    @IBOutlet weak var mineWebView: UIWebView!
    @IBOutlet weak var pauseView: UIView!
    @IBOutlet weak var menuView: UIView!

    
    @IBOutlet weak var menuIcon: UIImageView!
    @IBOutlet weak var menuText1: UILabel!
    @IBOutlet weak var menuText2: UILabel!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var levelSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

   
    
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var powerUpButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var mineButton: UIButton!
    @IBOutlet weak var mainViewMineRemaining: UILabel!
    @IBOutlet weak var mainViewTimeLeft: UILabel!
    
    @IBOutlet weak var mainViewStatusBar: UIView!

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var powerUpMenu: UIView!
    
    @IBAction func powerUpPressed(_ sender: Any) {
        self.stopTimer();
        if(gameStarted){
            
            let alert = UIAlertController(title: "OOPS!", message: "Comming Soon!", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                // perhaps use action.title here
            })
            self.present(alert, animated: true)
 /*
            showPowerUpMenu()
             */
        }   else{
            let alert = UIAlertController(title: "OOPS!", message: "Power ups are avalible after game started", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                // perhaps use action.title here
            })
            self.present(alert, animated: true)
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
            
            if(PO_mode == "none"){
                
                if(!squareUsed){
                    PO_mode = "square"
                    squareUsed = true;
                    self.mineWebView.stringByEvaluatingJavaScript(from: "setPOSqaure()")
                }
                startTimer();
                hidePowerUpMenu()
                
                
                
                
            }
        }

    }
    @IBAction func powerUp2Click(_ sender: Any) {
        if(gameStarted){
            
            if(PO_mode == "none"){
                
                
                if(!protectorUsed){
                    PO_mode = "protector"
                    protectorUsed = true;
                    self.mineWebView.stringByEvaluatingJavaScript(from: "setPOProtector()")
                }
                startTimer();
                hidePowerUpMenu()
                
                
                
                
            }
        }
    }
    @IBAction func powerUpStoreClick(_ sender: Any) {
    }
    
    func hidePowerUpMenu(){
        self.powerUpMenu.alpha = 0.0
        self.mainViewStatusBar.alpha = 1.0
        self.powerUpMenu.isHidden = true
        
        
    }
    func showPowerUpMenu(){
        self.powerUpMenu.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.powerUpMenu.alpha = 1.0
            self.mainViewStatusBar.alpha = 0.0
            
        });
        
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

        
        
        //MENU
        menuView.isHidden = true;
        menuView.alpha = 0.0;
        tryAgainButton.layer.borderColor = UIColor.white.cgColor
        resumeButton.layer.borderColor = UIColor.white.cgColor
        levelSegmentControl.selectedSegmentIndex = 1;
        
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                self.versionLabel.text = "MineLover v\(version) Build \(build)"
            }
        }
        
        
        
        
        
        
        
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
        UserDefaults.standard.set(lv_1_Statistics, forKey: "lv_1_Statistics")
        UserDefaults.standard.set(lv_2_Statistics, forKey: "lv_2_Statistics")
        UserDefaults.standard.set(lv_3_Statistics, forKey: "lv_3_Statistics")
        UserDefaults.standard.set(lv_4_Statistics, forKey: "lv_4_Statistics")
        UserDefaults.standard.set(saveCoins, forKey: "coin")
        UserDefaults.standard.set(saveGems, forKey: "gem")

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
            UserDefaults.standard.set(saveGems, forKey: "coin")
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
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row){
        case 0:
            return 60.0;
        case 6:
            return 180.0;
        default:
            return 50.0
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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

