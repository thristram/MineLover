//
//  ViewController.swift
//  MineSweeper
//
//  Created by Fangchen Li on 5/17/17.
//  Copyright © 2017 Fangchen Li. All rights reserved.
//

import UIKit
import JavaScriptCore
import GameKit
import StoreKit


class MineSweeperViewController: UIViewController, GCHelperDelegate, UIWebViewDelegate {
    
    
    ////////////////////////////////
    //////////GAME VARIABLES////////
    ////////////////////////////////
    
    var timer = Timer()
    
    ////////////////////////////////
    ///////////GAME CENTER//////////
    ////////////////////////////////

    var GCMapInitNumber = 0
    var GCifConstructMap = false;
    var GCMap = "";
    var GCifCollaborationGame = false;
    
    
    var ifReadLove = false;
    var jsContext : JSContext!
    

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
    @IBOutlet weak var mineButton: SpringButton!
    @IBOutlet weak var statusBarHeight: NSLayoutConstraint!
    
    //MAIN WEBVIEW
    @IBOutlet weak var mineWebView: UIWebView!

    
    @IBAction func powerUpPressed(_ sender: Any) {
        self.stopTimer();
        if MinesLover.gameState == .inPorgress{
            
            if(MinesLover.enablePowerUps){
                showPowerUpMenu()
            }   else   {
                self.notifyUser("CAUTION", message: "Comming Soon!")
            }
        }   else{
            self.notifyUser("CAUTION", message: "Power ups are avalible after game started")
        }
    }
    
    
    @IBAction func pausePressed(_ sender: Any) {
        self.showMenu()
    }
    @IBAction func minePress(_ sender: Any) {

        if MinesLover.powerUpMode == .crazySweeper{
            
            self.topMineChangeAnimation(to: "sweeper");
            
        }   else if MinesLover.powerUpMode == .protector{
            
            if MinesLover.gameMode == .sweep{
                
                MinesLover.gameMode = .normal
                self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
                
                if MinesLover.getPowerUpRemainingFunctions(type: .protector) > 0{
                    
                    self.topMineChangeAnimation(to: "corrector_\(MinesLover.getPowerUpRemainingFunctions(type: .protector))");
                    
                }   else    {
                    
                    self.topMineChangeAnimation(to: "mine")
                    
                }
                
            }   else    {
                
                MinesLover.gameMode = .sweep
                self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeSweep()");
                
                if MinesLover.getPowerUpRemainingFunctions(type: .protector) > 0{
                    
                    self.topMineChangeAnimation(to: "heartCorrector_\(MinesLover.getPowerUpRemainingFunctions(type: .protector))")
                    
                }   else    {
                    
                    self.topMineChangeAnimation(to: "heart")
                    
                }
                
            }
            
        }   else if(MinesLover.gameMode == .sweep){
            MinesLover.gameMode = .normal
            self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
            self.topMineChangeAnimation(to: "mine")

        }   else{
            MinesLover.gameMode = .sweep
            self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeSweep()")
            self.topMineChangeAnimation(to: "heart")

            
        }
    }
    func topMineChangeAnimation(to: String){
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.mineButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);

        }, completion: { (finished: Bool) in
            self.mineButton.setImage(UIImage(named: to), for: .normal)
            
            UIView.animate(withDuration: 0.9, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveLinear, animations: {
                self.mineButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            }, completion: nil)
            
//            UIView.animate(withDuration: 0.3, animations: {
//                self.mineButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
//
//            }, completion: { (finished: Bool) in
//
//
//                UIView.animate(withDuration: 0.15, animations: {
//                    self.mineButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
//
//                });
//            });
        });
    }
    
  
    @IBAction func multiPlayerPressed(_ sender: Any) {
        self.executeJS(jsCode: "constructMapsGC(8, 13, 20)")
        self.GCifCollaborationGame = true;
        GCHelper.sharedInstance.findMatchWithMinPlayers(2, maxPlayers: 2, viewController: self, delegate: self)
    }
    
    func showPowerUpMenu(){
        self.stopTimer();
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "powerup") as! PowerUpViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    func setGemSystem(){
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGemProbabiliy(\(MinesLover.gemProbability))")
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGemContentLimit(\(MinesLover.gemContentlimit))")
    }
    
    func startNewGame(){
        self.mineWebView.scalesPageToFit = true;
        
        MinesLover.initNewGame()
        self.mineWebView.scrollView.isScrollEnabled = MinesLover.getISScrollEnabled()
        
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()")
        self.mineWebView.stringByEvaluatingJavaScript(from: "stopCorrector()")
        self.setGemSystem()
        
        if MinesLover.isLevelChanged{
            constructGame()
            MinesLover.isLevelChanged = false
        }   else    {
            self.mineWebView.stringByEvaluatingJavaScript(from: "restartGame()")
        }
        
        
        self.mainViewMineRemaining.text = MinesLover.publicMethods.formatMineDisplay(mineInput: MinesLover.getCurrentLevel().mines)


        self.resetTimer();
        self.mainViewTimeLeft.text = "0:00";

    }
    
    
    //Subscribe/Listen for the events
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Mine View
        mineWebView.scrollView.isMultipleTouchEnabled = false;
        
        
        loadHTML()
        //JS Bridge
        NotificationCenter.default.addObserver(self, selector: #selector(self.handelJSEvent(_:)), name: NSNotification.Name(rawValue: "javascriptEvent"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.menuDidConfig(_:)), name: NSNotification.Name(rawValue: "menuDidConfig"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startPowerUps(_:)), name: NSNotification.Name(rawValue: "powerUpStart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.inactivityDetected(_:)), name: NSNotification.Name(rawValue: "inactivityActive"), object: nil)
        jsContext = self.mineWebView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptMethod(), forKeyedSubscript: "callSwift" as NSCopying & NSObjectProtocol)

        self.mainViewMineRemaining.text = MinesLover.publicMethods.formatMineDisplay(mineInput: MinesLover.getCurrentLevel().mines)
        
        //520 Special
        
        let defaults = UserDefaults.standard
        if let stringOne = defaults.string(forKey: "ifReadLove") {
            if(stringOne == "1"){
                self.ifReadLove = true
            }// Some String Value
        }
        
        if(ifReadLove == true){
            mineWebView.stringByEvaluatingJavaScript(from: "readLove()");
        }
        
        self.statusBarHeight.constant = CGFloat(MinesLover.UIElements["statusBarHeight"]!)
        
    }
    func inactivityDetected(_ notification: NSNotification){
        MinesLover.hintSystem.resetHintTime()
//        self.showPowerUpMenu()
    }
    func menuDidConfig(_ notification: NSNotification){
        self.mineSweeperDidShow()
    }
    func startPowerUps(_ notification: NSNotification){
        switch MinesLover.powerUpMode{
        case .xray:
            self.mineWebView.stringByEvaluatingJavaScript(from: "setPOSqaure(\(MinesLover.powerUps[.xray]!.currentLevel))")
            break
        case .crazySweeper:
            self.mineWebView.stringByEvaluatingJavaScript(from: "setPOProtector(\(MinesLover.powerUps[.crazySweeper]!.currentLevel), \(MinesLover.powerUps[.crazySweeper]!.currentSecondaryLevel))")
            break
        case .protector:
            self.mineWebView.stringByEvaluatingJavaScript(from: "setPOCorrector(\(MinesLover.powerUps[.protector]!.currentLevel))")
            break
        default:
            break
        }
    }
    func mineSweeperDidShow(){
        //New Game Button Pressed
        if MinesLover.newGame{
            self.startNewGame()
            if MinesLover.gameMode == .sweep {
                self.topMineChangeAnimation(to: "heart")
            }   else{
                self.topMineChangeAnimation(to: "mine")
            }
        }
        self.changeTopBarRightIcon()
        self.checkStartTimer()
        
    }
    func changeTopBarRightIcon(){
        switch MinesLover.gameState{
        case .win:
            self.pauseButton.setImage(UIImage(named: "back_arrow"), for: .normal)
            break
        case .lose:
            self.pauseButton.setImage(UIImage(named: "back_arrow"), for: .normal)
            break
        case .pendingStart:
            self.pauseButton.setImage(UIImage(named: "icon_pause"), for: .normal)
            break
        case .inPorgress:
            self.pauseButton.setImage(UIImage(named: "icon_pause"), for: .normal)
            break
        }
    }
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mineSweeperDidShow()
        
        
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
            self.showMenu()
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

    /*
     
     MENU
     
     */

    
    func showProtectCountDownView(){
        self.stopTimer()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GemView") as! GemViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.openAs = .creazySweeperCountdown
        
        let timeProtectorCounter = MinesLover.powerUps[.crazySweeper]!.remainingFunctios
        let min = timeProtectorCounter / 100;
        let sec = timeProtectorCounter % 100;
        if(sec < 10){
            self.mainViewTimeLeft.text = "\(min):0\(sec)"
        }   else{
            self.mainViewTimeLeft.text = "\(min):\(sec)"
        }
        
        self.present(vc, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.5, animations: {
            //self.mainViewStatusBar.alpha = 0.0
        }, completion: { (finished: Bool) in
            let when = DispatchTime.now();
            
            DispatchQueue.main.asyncAfter(deadline: when + 3.5) {
                self.executeJS(jsCode: "startPOProtector()")
                self.topMineChangeAnimation(to: "sweeper")
                MinesLover.timerMode = .crazySweeper
                self.checkStartTimer()
            }
            
        });

        
        
        
        
    }
    func showMenu(){
        self.stopTimer();
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuView") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    func showGemView(openAs: GemViewFunctions = .gemFound){
        self.stopTimer()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GemView") as! GemViewController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.openAs = openAs
        self.present(vc, animated: true, completion: nil)
        
    }
    
    /*
     
     JS BRIDGE
     
     */
    func constructGame(){
        let JSConstructGame = MinesLover.getCurrentLevel().constructMapJS()
        mineWebView.stringByEvaluatingJavaScript(from: JSConstructGame)
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
        print (JSConstructGame)

    }
    func constructGameFromMap(map:String){
        let JSConstructGame = MinesLover.getCurrentLevel().constructMapJS(map: map)
        mineWebView.stringByEvaluatingJavaScript(from: JSConstructGame)
        MinesLover.gameMode = .normal
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
        print (JSConstructGame)
        
    }

    func handelJSReceivedData(method: String, value: String){

        switch (method){
        case "gameInit":
            print("webLoad Ready")
            self.constructGame()
            self.setGemSystem()
            break;
        case "console":
            print (value);
            break;
        case "mines":
            
            break;
        case "gameStart":
            MinesLover.gameState = .inPorgress
            MinesLover.getCurrentLevel().record.startRecord()
            self.startTimer();
            
            break;
        case "gameStop":
            print("Game Stopped")

            break;
        case "gameover":
            self.stopTimer()
            MinesLover.checked = Int(value)!
            MinesLover.gameOver()
            self.changeTopBarRightIcon()
            self.showMenu()
            break;
        case "win":
            self.stopTimer()
            MinesLover.gameWin()
            self.changeTopBarRightIcon()
            self.showMenu()
            break;
        case "gameTotalMines":
            print("Total Mines Constructed is: \(value)")
            break;
        case "gameWidth":
            print("Game Width is: \(value)")
            break;
        case "gameHeight":
            print("Game Height is: \(value)")
            break;
        case "sweepCorrected":
            MinesLover.sweepCorrected = Int(value)!;
            break;
        case "sweepNotCorrected":
            MinesLover.sweepNotCorrected = Int(value)!;
            break;
        case "checked":
            MinesLover.hintSystem.resetHintTime()
            MinesLover.checked = Int(value)!;
            break;
        case "sweeped":
            MinesLover.hintSystem.resetHintTime()
            MinesLover.sweeped = Int(value)!;
            self.mainViewMineRemaining.text = MinesLover.publicMethods.formatMineDisplay(mineInput: MinesLover.getMinesRemaining())
            break;
        case "currentMap":
            MinesLover.currentMap = value;
            break;
        case "readLove":
            self.ifReadLove = true;
            let defaults = UserDefaults.standard
            defaults.set("1", forKey: "ifReadLove")
            
            break;
        case "stopProtector":
            MinesLover.powerUpMode = .none
            MinesLover.timerMode = .normal
            if MinesLover.gameMode == .sweep {
                self.topMineChangeAnimation(to: "heart")
            }   else{
                self.topMineChangeAnimation(to: "mine")
            }
            
            break;
        case "stopSquare":
            MinesLover.powerUpMode = .none
            break;
        case "stopSquareSelection":
            if MinesLover.gameMode == .sweep {
                self.topMineChangeAnimation(to: "heart")
            }   else{
                self.topMineChangeAnimation(to: "mine")
            }

            break;
        case "startSquare":
            self.topMineChangeAnimation(to: "xray")
            break;
        case "gemDetected":
            MinesLover.setGems(gems: (MinesLover.Gems + Int(value)!))
            MinesLover.record.saveRecord();
            self.showGemView(openAs: .gemFound);
            break;
        case "protectorReady":
            self.showProtectCountDownView()
            break;
        case "correctStart":

            if MinesLover.gameMode == .sweep {
                self.topMineChangeAnimation(to: "heartCorrector_\(MinesLover.getPowerUpRemainingFunctions(type: .protector))")
            }   else{
                self.topMineChangeAnimation(to: "corrector_\(MinesLover.getPowerUpRemainingFunctions(type: .protector))");
            }

            break;
        case "correctActivated":
            MinesLover.setPowerUpRemainingFunctions(type: .protector, value: Int(value)!)
            print("icon Changed")
            print(MinesLover.gameMode)
            print(MinesLover.getPowerUpRemainingFunctions(type: .protector) )
            if MinesLover.getPowerUpRemainingFunctions(type: .protector) > 0{
                
                if MinesLover.gameMode == .sweep {
                    self.topMineChangeAnimation(to: "heartCorrector_\(MinesLover.getPowerUpRemainingFunctions(type: .protector))")
                }   else{
                    self.topMineChangeAnimation(to: "corrector_\(MinesLover.getPowerUpRemainingFunctions(type: .protector))");
                }
                
            }   else{
                MinesLover.powerUpMode = .none
                if MinesLover.gameMode == .sweep {
                    self.topMineChangeAnimation(to: "heart")
                }   else{
                    self.topMineChangeAnimation(to: "mine")
                }
            }
            
            break;
        case "GCMap":
            self.GCMap = value
            print("Swift received map: \(value)")

            break;
        case "GCsweepMine":
            if(GCifCollaborationGame){
                sendMatchData(data: "GCsweepMine=\(value)")
            }
            break;
        case "GCcheckMine":
            if(GCifCollaborationGame){
                sendMatchData(data: "GCcheckMine=\(value)")
            }
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
    func stopPOProtector(){
        self.executeJS(jsCode: "stopPOProtector()")
    }
    
    /*
     
     TIMER
     
     */
    
    func checkStartTimer(){
        switch MinesLover.gameState{
        case .win:
            break
        case .lose:
            break
        case .pendingStart:
            break
        case .inPorgress:
            self.startTimer()
            break
        }
        
    }
    func startTimer(){
        timer.invalidate() // just in case this button is tapped multiple times
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    func stopTimer(){
        timer.invalidate() // just in case this button is tapped multiple times
        
    }
    func resetTimer(){
        timer.invalidate() // just in case this button is tapped multiple times
        MinesLover.timerCounter = 0
        
    }
    
    func timerAction() {

        let timeCounter = MinesLover.incTimer()
        
        switch MinesLover.timerMode{
        case .normal:
            MinesLover.hintSystem.hintTimeCountdown()
            let min = (timeCounter / 100) / 60;
            let sec = (timeCounter / 100) % 60;
            if(sec < 10){
                self.mainViewTimeLeft.text = "\(min):0\(sec)"
            }   else{
                self.mainViewTimeLeft.text = "\(min):\(sec)"
            }
        case .crazySweeper:
            var timeProtectorCounter = MinesLover.powerUps[.crazySweeper]!.remainingFunctios
            if(timeProtectorCounter == 0){
                if MinesLover.powerUpMode == .crazySweeper{
                    MinesLover.timerMode = .normal
                    stopPOProtector()
                }
            }   else    {
                timeProtectorCounter -= 1
                MinesLover.powerUps[.crazySweeper]!.remainingFunctios = timeProtectorCounter
                
                let min = timeProtectorCounter / 100;
                let sec = timeProtectorCounter % 100;
                if(sec < 10){
                    self.mainViewTimeLeft.text = "\(min):0\(sec)"
                }   else{
                    self.mainViewTimeLeft.text = "\(min):\(sec)"
                }
            }
            
            
        }
        
        
       
    }

    
    
    /*
 
     STORAGE SETUP
     
     */
    
    
    
    func keyValueStoreDidChange(_ notification: NSNotification) {
        /*
        if let savedString = iCloudKeyStore?.string(forKey: iCloudTextKey) {
            print("String Saved: \(savedString)")
        }
         */
        print("Record Updated from iCloud")

    }
    
    
    

 
    
    func executeJS(jsCode: String){
        mineWebView.stringByEvaluatingJavaScript(from: jsCode)
    }
    

    
    var opponentID = "";
    func sendMatchData(data: String){
        let newData = "\(data)+udid=\(MinesLover.deviceID)"
        let matchData = newData.data(using: .utf8)
        do {
            try GCHelper.sharedInstance.match.sendData(toAllPlayers: matchData!, with: GKMatchSendDataMode.reliable)
        } catch _ {
            
        }
    }
    
    
    /// Method called when the device received data about the match from another device in the match.
    func match(_ match: GKMatch, didReceiveData: Data, fromPlayer: String) {
        //self.executeJS(jsCode: "constructMinesGC(8, 13, 20)")
        
        self.opponentID = fromPlayer
        let dataString = String(data: didReceiveData, encoding: String.Encoding.utf8) as String!
        if let raw = dataString{
            print("RAW MESSAGE RECEIVED: \(raw)")
            let strArray = raw.components(separatedBy: "+udid=")
            let parsedUDID = strArray[1]
            if(parsedUDID != MinesLover.deviceID){
                let commands = strArray[0].components(separatedBy: "&")
                if commands.count > 0{
                    for (_, val) in commands.enumerated() {
                        let command = val.components(separatedBy: "=")
                        self.handelGCCommands(command: command[0], value: command[1])
                        
                    }
                }

            }
            
        }

    }
    
    func handelGCCommands(command: String, value: String){
        switch (command){
            case "maps":
                print("GC Match: Received Map Data \(value)")
                self.constructGameFromMap(map: value);
                self.sendMatchData(data: "opponentReady=1")
                self.startMatchCountDown()
                
                break;
            case "mapInit":
                if(Int(value)! > GCMapInitNumber){
                    print("GC Match: Using Local Map Data")
                    print("GC Match: Sending Map Data")
                    self.GCifConstructMap = true
                    self.sendMatchData(data: "maps=\(self.GCMap)")
                    self.constructGameFromMap(map: self.GCMap);
                    
                    
                    
                }   else if(Int(value) == GCMapInitNumber)    {
                    print("GC Match: re-Sending Map Data")
                    sendMapInitVal()
                }
                break;
            case "time":
                break;
            case "opponentReady":
//                self.hideMenu()
                self.startMatchCountDown()
                break;
            case "gameoverWin":
                break;
            case "gameoverLose":
                break;
            case "abrot":
                break;
            case "remaining":
                break;
            case "GCcheckMine":
                let coord = value.components(separatedBy: "-")
                self.executeJS(jsCode: "checkMine(\(coord[0]), \(coord[1]),true)")
                break;
            case "GCsweepMine":
                let coord = value.components(separatedBy: "-")
                self.executeJS(jsCode: "sweepMine(\(coord[0]), \(coord[1]),true)")
                break;
        
            default:
                break;
        }
    }
    func sendMapInitVal(){
        GCMapInitNumber = Int(arc4random_uniform(500))
        sendMatchData(data: "mapInit=\(self.GCMapInitNumber)")
    }
    /// Method called when a match has been initiated.
    func matchStarted() {
        print("match start")
        sendMapInitVal()
        self.showGemView(openAs: .multiplerMatch)
    }
    func matchEnded() {
    }
    
    func startMatchCountDown(){
//        UIView.animate(withDuration: 0.5, animations: {
//            self.gemView.alpha = 1.0
//            self.mainViewStatusBar.alpha = 0.0
//        }, completion: { (finished: Bool) in
//
//            let when = DispatchTime.now();
//            DispatchQueue.main.asyncAfter(deadline: when + 3) {
//                self.gemImage.image = UIImage(named: "number_2")
//            }
//            DispatchQueue.main.asyncAfter(deadline: when + 4) {
//                self.gemImage.image = UIImage(named: "number_1")
//            }
//            DispatchQueue.main.asyncAfter(deadline: when + 5) {
//                self.hideGemView()
//
//            }
//            self.startTimer()
//        });

    }
 
    
    
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        jsContext = self.mineWebView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptMethod(), forKeyedSubscript: "callSwift" as NSCopying & NSObjectProtocol)
        
    }

    
}

