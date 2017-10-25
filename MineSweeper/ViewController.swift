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


class ViewController: UIViewController, GCHelperDelegate {
    
    
    
    
    
    
    ////////////////////////////////
    //////////GAME VARIABLES////////
    ////////////////////////////////
    
    var totalMines = 0;
    var gameWidth = 0;
    var gameHeight = 0;
    
    
    var currentMap = "";
    var ifChangeLevel = false;
    
    var PO_mode = "none";
    var game_mode = "normal";
    var gameStarted = false;
    var squareUsed = false;
    var protectorUsed = false;
    var correctorUsed = false
    var enablePowerUps = true;
    
    var timerCounter = 0;
    var timer = Timer()
    
    var timerProtectorCounter = 0;
    var remainingCorrector = 0
    var timerProtector = Timer()
    var timerProtectorFlag = false
    var totalProtectorTime = 500;
    
    var complementaryPassesAfterUnlock = 2
    var deviceID = ""
    
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
    ////////////STORE KIT///////////
    ////////////////////////////////
    
    
    
    let appBundleId = "SeraphTechnology.MineSweeper"
    let purchaseGem5Suffix = RegisteredPurchase.gem5
    let purchaseGem15Suffix = RegisteredPurchase.gem15
    
    
    ////////////////////////////////
    //////////LEVEL DESIGN//////////
    ////////////////////////////////
    
  
   
    
    
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
    
    
    //POWERUP 3
    @IBOutlet weak var powerUp3View: UIView!
    @IBOutlet weak var powerUp3Title: UILabel!
    @IBOutlet weak var powerUp3Description: UILabel!
    @IBOutlet weak var powerUp3Image: UIImageView!
    
    @IBOutlet weak var powerUp3ProgressBar: UIView!
    @IBOutlet weak var powerUp3ProgressBar_1: UIView!
    @IBOutlet weak var powerUp3ProgressBar_2: UIView!
    @IBOutlet weak var powerUp3ProgressBar_3: UIView!
    @IBOutlet weak var powerUp3ProgressBar_4: UIView!
    @IBOutlet weak var powerUp3ProgressBar_5: UIView!
    
    @IBOutlet weak var powerUp3Lock: UIImageView!
    @IBOutlet weak var powerUp3Status: UILabel!
    
    

    
    ////////////////////////////////
    //////////SCREENSIZE UI/////////
    ////////////////////////////////
    var storePriceButtonTitleOffset = -80.0
    

    
    @IBAction func storePauseViewPressed(_ sender: Any) {
        showStoreView()
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
        self.showMenu()
    }
    @IBAction func minePress(_ sender: Any) {
        let _self = self;
        
        if(self.PO_mode == "protector"){
            
            self.topMineChangeAnimation(to: "crazy");
            
        }   else if(PO_mode == "corrector"){
            
            if(self.game_mode == "sweep"){
                
                game_mode = "normal";
                self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
                
                if(self.remainingCorrector > 0){
                    
                    self.topMineChangeAnimation(to: "corrector_\(self.remainingCorrector)");
                    
                }   else    {
                    
                    self.topMineChangeAnimation(to: "mine")
                    
                }
                
            }   else    {
                
                game_mode = "sweep";
                self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeSweep()");
                
                if(self.remainingCorrector > 0){
                    
                    self.topMineChangeAnimation(to: "heartCorrector_\(self.remainingCorrector)")
                    
                }   else    {
                    
                    self.topMineChangeAnimation(to: "heart")
                    
                }
                
            }
            
        }   else if(self.game_mode == "sweep"){
            game_mode = "normal";
            _self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
            self.topMineChangeAnimation(to: "mine")

        }   else{
            game_mode = "sweep"
            self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeSweep()")
            self.topMineChangeAnimation(to: "heart")

            
        }
    }
    func topMineChangeAnimation(to: String){
        UIView.animate(withDuration: 0.3, animations: {
            self.mineButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01);
            
        }, completion: { (finished: Bool) in
            self.mineButton.setImage(UIImage(named: to), for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.mineButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3);
                
            }, completion: { (finished: Bool) in
                
                
                UIView.animate(withDuration: 0.15, animations: {
                    self.mineButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
                    
                });
            });
        });
    }
    
   
    
    
    
    @IBAction func closePowerUpView(_ sender: Any) {
        hidePowerUpMenu()
        
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
                        hidePowerUpMenu()
                    }
                }   else    {
                    print("X-Ray pass is \(String(describing: powerUp1["remaining"])) which is < 0")
                    self.storeSegmentControl.selectedSegmentIndex = 3
                    self.switchToStorePasses()
                    showStoreView();
                }
            }   else{
                self.storeSegmentControl.selectedSegmentIndex = 2
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
                        
                        hidePowerUpMenu()
                
                    }
                }   else    {
                    print("Protector Pass is \(String(describing: powerUp1["remaining"])) which is < 0")
                    self.switchToStorePasses()
                    self.storeSegmentControl.selectedSegmentIndex = 3
                    showStoreView();
                }
            }   else{
                self.storeSegmentControl.selectedSegmentIndex = 2
                self.switchToStoreAbility()
                showStoreView();
            }
        }
    }
    @IBAction func powerUp3Click(_ sender: Any) {
        if(gameStarted){
            if((powerUp3["level"]!) > 0){
                if(powerUp3["remaining"]! > 0){
                    if(PO_mode == "none"){
                        
                        if(!correctorUsed){
                            powerUp3["remaining"]! -= 1
                            saveRecord()
                            self.disablePowerUp3();
                            /*POWERUP3 PROGRESS*/
                            PO_mode = "corrector"
                            correctorUsed = true;
                            let powerUpLevel = powerUp3["level"]!
                            self.mineWebView.stringByEvaluatingJavaScript(from: "setPOCorrector(\(powerUpLevel))")
                        }
                        
                        hidePowerUpMenu()
                        
                    }
                }   else    {
                    print("Corrector Pass is \(String(describing: powerUp3["remaining"]!)) which is < 0")
                    self.switchToStorePasses()
                    self.storeSegmentControl.selectedSegmentIndex = 3
                    showStoreView();
                }
            }   else{
                self.storeSegmentControl.selectedSegmentIndex = 2
                self.switchToStoreAbility()
                showStoreView();
            }
        }
    }

    @IBAction func multiPlayerPressed(_ sender: Any) {
        self.executeJS(jsCode: "constructMapsGC(8, 13, 20)")
        self.GCifCollaborationGame = true;
        GCHelper.sharedInstance.findMatchWithMinPlayers(2, maxPlayers: 2, viewController: self, delegate: self)
    }
    @IBAction func powerUpStoreClick(_ sender: Any) {
        showStoreView();
    }
    
    func hidePowerUpMenu(){
        self.powerUpMenu.alpha = 0.0
        self.mainViewStatusBar.alpha = 1.0
        self.powerUpMenu.isHidden = true
        checkStartTimer()
        
    }
    func showPowerUpMenu(){
        updatePowerUpText()
        stopTimer();
        self.powerUpMenu.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.powerUpMenu.alpha = 1.0
            self.mainViewStatusBar.alpha = 0.0
            
        });
        
    }
    
    
    func updatePowerUpText(){
        
        var powerUp1BarElements: [UIView] = [self.powerUp1ProgressBar_1, self.powerUp1ProgressBar_2, self.powerUp1ProgressBar_3, self.powerUp1ProgressBar_4, self.powerUp1ProgressBar_5]
        var powerUp2BarElements: [UIView] = [self.powerUp2ProgressBar_1, self.powerUp2ProgressBar_2, self.powerUp2ProgressBar_3, self.powerUp2ProgressBar_4, self.powerUp2ProgressBar_5]
        var powerUp3BarElements: [UIView] = [self.powerUp3ProgressBar_1, self.powerUp3ProgressBar_2, self.powerUp3ProgressBar_3, self.powerUp3ProgressBar_4, self.powerUp3ProgressBar_5]
        
        self.powerUp1Description.text = "Detect any mines\nwithin \(self.powerUp1Range[self.powerUp1["level"]!]) range"
        self.powerUp2Description.text = "Click anywhere inside a\nin \(self.powerUp2Range[self.powerUp2["level"]!]) block within \(self.powerUp2TimeLimit[powerUp2["time"]!])"
        if((self.powerUp2["level"]!) == 5){
            self.powerUp2Description.text = "Click anywhere\nwithin \(self.powerUp2TimeLimit[self.powerUp2["time"]!])"
        }
        if((self.powerUp3["level"]!) == 1){
            self.powerUp3Description.text = "Correct your fist \nwrong sweeps"
        }   else{
            self.powerUp3Description.text = "Correct your fist \(self.powerUp3Range[self.powerUp3["level"]!])\nwrong sweeps"
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
            }   else if(self.PO_mode == "square"){
                self.powerUp1Status.isHidden = false
                self.powerUp1Status.text = "POWER UP IN-USE"
                self.disablePowerUp1();
            }   else if(squareUsed)   {
                self.powerUp1Status.isHidden = false
                self.powerUp1Status.text = "POWER UP USED"
                self.disablePowerUp1();
            }   else if(self.PO_mode != "none"){
                self.powerUp1Status.isHidden = false
                self.powerUp1Status.text = "OTHER POWER UP IN-USE"
                self.disablePowerUp1();
            }   else   {
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
            }   else if(self.PO_mode == "protector"){
                self.powerUp2Status.isHidden = false
                self.powerUp2Status.text = "POWER UP IN-USE"
                self.disablePowerUp2();
            }   else if(protectorUsed)   {
                self.powerUp2Status.isHidden = false
                self.powerUp2Status.text = "POWER UP USED"
                self.disablePowerUp2();
            }   else if(self.PO_mode != "none"){
                self.powerUp2Status.isHidden = false
                self.powerUp2Status.text = "OTHER POWER UP IN-USE"
                self.disablePowerUp2();
            }   else   {
                self.powerUp2Status.isHidden = true;
                self.enablePowerUp2();
            }
        }
        
        if((self.powerUp3["level"]!) < 1){
            self.powerUp3Description.text = "Sweep Corrector\nUnlock Power Up in Store"
            self.powerUp3Lock.isHidden = false;
            self.powerUp3Status.isHidden = true
            disablePowerUp3()
        }   else{
            
            self.powerUp3Lock.isHidden = true
            if(powerUp3["remaining"]! < 1){
                self.powerUp3Status.isHidden = false
                self.powerUp3Status.text = "NO PASSES LEFT"
                self.disablePowerUp3();
            }   else if(self.PO_mode == "corrector"){
                self.powerUp3Status.isHidden = false
                self.powerUp3Status.text = "POWER UP IN-USE"
                self.disablePowerUp1();
            }   else if(correctorUsed)   {
                self.powerUp3Status.isHidden = false
                self.powerUp3Status.text = "POWER UP USED"
                self.disablePowerUp3();
            }   else if(self.PO_mode != "none"){
                self.powerUp3Status.isHidden = false
                self.powerUp3Status.text = "OTHER POWER UP IN-USE"
                self.disablePowerUp3();
            }   else   {
                self.powerUp3Status.isHidden = true;
                self.enablePowerUp3();
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
            if(i <= (powerUp3["remaining"]!)){
                powerUp3BarElements[i-1].isHidden = false;
            }   else{
                powerUp3BarElements[i-1].isHidden = true;
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
    func disablePowerUp3(){
        self.powerUp3Image.alpha = 0.5
        self.powerUp3Title.alpha = 0.5
        self.powerUp3Description.alpha = 0.5
        self.powerUp3ProgressBar.alpha = 0.5
        self.powerUp3Status.alpha = 0.5
    }
    func enablePowerUp3(){
        //self.powerUp2View.alpha = 1.0;
        self.powerUp3Image.alpha = 1.0
        self.powerUp3Title.alpha = 1.0
        self.powerUp3Description.alpha = 1.0
        self.powerUp3ProgressBar.alpha = 1.0
        self.powerUp3Status.alpha = 1.0
    }

    func startNewGame(){
        self.mineWebView.scalesPageToFit = true;
        
        MinesLover.initNewGame()
        let currentLevel = MinesLover.getCurrentLevel()
       
        correctorUsed = false;
        self.remainingCorrector = Int(self.powerUp3Number[powerUp3["level"]!])
        
        self.mineWebView.scrollView.isScrollEnabled = MinesLover.getISScrollEnabled()
        
        self.totalMines = MinesLover.getCurrentLevel().mines
        self.mineWebView.stringByEvaluatingJavaScript(from: "stopCorrector()");
        if(ifChangeLevel){
            constructGame()
        }   else    {
            resetGame()
            mineWebView.stringByEvaluatingJavaScript(from: "restartGame()")
        }
        
        
        self.mainViewMineRemaining.text = formatMineDisplay(mineInput: currentLevel.mines)


        resetTimer();
        self.mainViewTimeLeft.text = "0:00";

    }
    
    
    //Subscribe/Listen for the events
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.deviceID = UIDevice.current.identifierForVendor!.uuidString
        self.updateConstraints();

        //RECORD
        
        getRecord()
        

        self.remainingCorrector = Int(self.powerUp3Number[powerUp3["level"]!])
        
        
        
        //Mine View
        mineWebView.scrollView.isMultipleTouchEnabled = false;
        
        
        loadHTML()
        //JS Bridge
        NotificationCenter.default.addObserver(self, selector: #selector(self.handelJSEvent(_:)), name: NSNotification.Name(rawValue: "javascriptEvent"), object: nil)
        jsContext = self.mineWebView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptMethod(), forKeyedSubscript: "callSwift" as NSCopying & NSObjectProtocol)

        self.mainViewMineRemaining.text = formatMineDisplay(mineInput: MinesLover.getCurrentLevel().mines)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Resume Button Pressed
        if(MinesLover.isGameWined){
            self.pauseButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        }   else if(MinesLover.isGameOvered){
            self.pauseButton.setImage(UIImage(named: "back_arrow"), for: .normal)
        }   else{
            self.pauseButton.setImage(UIImage(named: "icon_pause"), for: .normal)
            checkStartTimer()
        }
        //New Game Button Pressed
        if MinesLover.newGame{
            self.pauseButton.setImage(UIImage(named: "icon_pause"), for: .normal)
            if(self.game_mode == "sweep"){
                self.topMineChangeAnimation(to: "heart")
            }   else{
                self.topMineChangeAnimation(to: "mine")
            }
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
    func resetGame(){
    
        self.PO_mode = "none";
        self.gameStarted = false;
        self.squareUsed = false;
        self.protectorUsed = false;
        self.correctorUsed = false
        



    }
    /*
     
     MENU
     
     */

    
    
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
    
    func showProtectCountDownView(){
        self.stopTimer()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GemView") as! GemViewController
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.pageTitle = "READY?"
        vc.pageDescription = "You may click anywhere\nmarked in blue!"
        vc.resumeGemViewButton.setTitle("START CLICK", for: .normal)
        vc.gemImage.image = UIImage(named: "number_3")
        vc.resumeGemViewButton.isHidden = true;
        
        self.present(vc, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.mainViewStatusBar.alpha = 0.0
        }, completion: { (finished: Bool) in
            let when = DispatchTime.now();
            
            DispatchQueue.main.asyncAfter(deadline: when + 3.5) {
                self.executeJS(jsCode: "startPOProtector()")
                self.topMineChangeAnimation(to: "crazy")
                self.startProtectorTimer(timeInput: (self.powerUp2TimeLimitInt[self.powerUp2["time"]!] * 100))
            }
            
        });

        
        
        
        
    }
    func showMenu(){
        self.stopTimer();
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuView") as! MenuViewController
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    func showGemView(){
        self.stopTimer()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GemView") as! GemViewController
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.pageTitle = "You got a GEM!"
        vc.pageDescription = "You may use the GEM to purchase Power-Ups\nor Upgrade Power-Ups"
        vc.resumeGemViewButton.setTitle("RESUME", for: .normal)
        vc.gemImage.image = UIImage(named: "number_3")
        vc.resumeGemViewButton.isHidden = false
        
        
        
    }
    
    /*
     
     JS BRIDGE
     
     */
    func constructGame(){
        resetGame()
        let JSConstructGame = MinesLover.getCurrentLevel().constructMapJS()
        mineWebView.stringByEvaluatingJavaScript(from: JSConstructGame)
        game_mode = "normal";
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
        print (JSConstructGame)

    }
    func constructGameFromMap(map:String){
        resetGame()
        let JSConstructGame = MinesLover.getCurrentLevel().constructMapJS(map: map)
        mineWebView.stringByEvaluatingJavaScript(from: JSConstructGame)
        game_mode = "normal";
        self.mineWebView.stringByEvaluatingJavaScript(from: "setGameModeNormal()");
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
            self.resetGame()
            loseRecord()
            MinesLover.gameOver()
            MinesLover.checked = Int(value)!;
            self.showMenu()
            break;
        case "win":
            self.stopTimer();
            winRecord()
            self.resetGame()
            MinesLover.gameWin()
            self.showMenu()
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
            MinesLover.sweepCorrected = Int(value)!;
            break;
        case "sweepNotCorrected":
            MinesLover.sweepNotCorrected = Int(value)!;
            break;
        case "checked":
            MinesLover.checked = Int(value)!;
            break;
        case "sweeped":
            MinesLover.sweeped = Int(value)!;
            self.mainViewMineRemaining.text = formatMineDisplay(mineInput: MinesLover.getMinesRemaining())
            break;
        case "currentMap":
            MinesLover.currentMap = value;
            break;
        case "readLove":
            _self.ifReadLove = true;
            let defaults = UserDefaults.standard
            defaults.set("1", forKey: "ifReadLove")
            
            break;
        case "stopProtector":
            self.PO_mode = "none"
            if(self.game_mode == "sweep"){
                self.topMineChangeAnimation(to: "heart")
            }   else{
                self.topMineChangeAnimation(to: "mine")
            }
            
            break;
        case "stopSquare":
            self.PO_mode = "none"
            break;
        case "stopSquareSelection":
            if(self.game_mode == "sweep"){
                self.topMineChangeAnimation(to: "heart")
            }   else{
                self.topMineChangeAnimation(to: "mine")
            }

            break;
        case "startSquare":
            self.topMineChangeAnimation(to: "xray")
            break;
        case "gemDetected":
            _self.saveGems = _self.saveGems + Int(value)!;
            saveRecord();
            showGemView();
            break;
        case "protectorReady":
            self.showProtectCountDownView()
            break;
        case "correctStart":
            self.remainingCorrector = Int(self.powerUp3Number[self.powerUp3["level"]!])
            if(self.game_mode == "sweep"){
                self.topMineChangeAnimation(to: "heartCorrector_\(self.remainingCorrector)")
            }   else{
                self.topMineChangeAnimation(to: "corrector_\(self.remainingCorrector)");
            }

            break;
        case "correctActivated":
            self.remainingCorrector = Int(value)!
            print("icon Changed")
            print(self.game_mode)
            print(self.remainingCorrector )
            if(self.remainingCorrector > 0){
                
                if(self.game_mode == "sweep"){
                    self.topMineChangeAnimation(to: "heartCorrector_\(self.remainingCorrector)")
                }   else{
                    self.topMineChangeAnimation(to: "corrector_\(self.remainingCorrector)");
                }
                
            }   else{
                self.PO_mode = "none"
                if(self.game_mode == "sweep"){
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
    
    func startProtectorTimer(timeInput: Int){
        totalProtectorTime = timeInput
        timerProtector.invalidate()
        timerProtectorCounter = totalProtectorTime
        timerProtectorFlag = true;
        timerProtector = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerProtectorAction), userInfo: nil, repeats: true)
    }
    func stopProtectorTimer(){
        timerProtector.invalidate() // just in case this button is tapped multiple times
        timerProtectorCounter = 0
        timerProtectorFlag = false
        timerProtectorCounter = totalProtectorTime
    }
    func checkStartTimer(){
        if((!(self.isGameWined || self.isGameOvered))){
            if(self.storeView.isHidden && self.powerUpMenu.isHidden && self.menuView.isHidden && self.gemView.isHidden){
                startTimer();
            }
        }
    }
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
    func timerProtectorAction(){
        if(timerProtectorCounter == 0){
            stopProtectorTimer()
            stopPOProtector()
        }   else    {
            timerProtectorCounter -= 1
            
            let min = timerProtectorCounter / 100;
            let sec = timerProtectorCounter % 100;
            if(timerProtectorFlag){
                if(sec < 10){
                    self.mainViewTimeLeft.text = "\(min):0\(sec)"
                }   else{
                    self.mainViewTimeLeft.text = "\(min):\(sec)"
                }
            }
        }
        
    }
    func timerAction() {
        timerCounter += 1
        
        let min = timerCounter / 60;
        let sec = timerCounter % 60;
        if(!timerProtectorFlag){
            if(sec < 10){
                self.mainViewTimeLeft.text = "\(min):0\(sec)"
            }   else{
                self.mainViewTimeLeft.text = "\(min):\(sec)"
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
        compareRecord()

        self.updateStoreText()

        self.updatePowerUpText()
    }
    
    
    
    
    
    func getRecord() {
        getLocalRecord()
        compareRecord()
    
    }
    func compareRecord(){
        
        if let localResult = UserDefaults.standard.value(forKey: "localRecordLastModified"){
            
            self.localRecordLastModified = Int(localResult as! String)!
            if let iCloudResult = iCloudKeyStore?.string(forKey: "iCloudRecordLastModified"){
                self.iCloudRecordLastModified = Int(iCloudResult)!
                
                print("localModify = \(self.localRecordLastModified) iCloudModify = \(self.iCloudRecordLastModified)")
                
                if(self.iCloudRecordLastModified > self.localRecordLastModified){
                    getiCloudRecord()
                }
                
            }
        }

    }
    
    

    
    
    func startRecord(){
        var currentStatistics = getCurrentStatistics(level: MinesLover.currentLevel)
        let totalGame = Int(currentStatistics["totalGame"]!)! + 1;
        updateSingleRecord(level: MinesLover.currentLevel, name: "totalGame", value: totalGame as AnyObject)
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
    

    
    
    func progressDesplay(cell:storeElementTableViewCell, progress: Int) -> storeElementTableViewCell{
        return cell

    }
    
    
    func executeJS(jsCode: String){
        mineWebView.stringByEvaluatingJavaScript(from: jsCode)
    }
    
    func updateConstraints(){
        switch(MinesLover.screenSize()){
        case "5":
            self.storePriceButtonTitleOffset = -127.0
            break;
        case "7":
            self.storePriceButtonTitleOffset = -127.0
            break;
        case "7+":
            self.storePriceButtonTitleOffset = -80.0
            break;
        default:
            self.storePriceButtonTitleOffset = -127.0
            break;
        }

    }
    
    var opponentID = "";
    func sendMatchData(data: String){
        let newData = "\(data)+udid=\(self.deviceID)"
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
            if(parsedUDID != deviceID){
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
                self.hideMenu()
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
                self.hideMenu()
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
        showMatchView()
    }
    func matchEnded() {
    }
    
    func startMatchCountDown(){
        UIView.animate(withDuration: 0.5, animations: {
            self.gemView.alpha = 1.0
            self.mainViewStatusBar.alpha = 0.0
        }, completion: { (finished: Bool) in
            
            let when = DispatchTime.now();
            DispatchQueue.main.asyncAfter(deadline: when + 3) {
                self.gemImage.image = UIImage(named: "number_2")
            }
            DispatchQueue.main.asyncAfter(deadline: when + 4) {
                self.gemImage.image = UIImage(named: "number_1")
            }
            DispatchQueue.main.asyncAfter(deadline: when + 5) {
                self.hideGemView()
                
            }
            self.startTimer()
        });

    }
    func showMatchView(){
        self.stopTimer()
        self.gemView.isHidden = false;
        self.coinGemViewLabel.text = "\(self.saveCoins)";
        self.gemImage.image = UIImage(named: "competition")
        self.gemTitle.text = "Initializing"
        self.gemDescription.text = "Connecting with your opponent\nPlease wait......"
        
        self.resumeGemViewButton.isHidden = true;
        self.gemView.alpha = 1.0
        self.mainViewStatusBar.alpha = 0.0

       

    }
    
    
    


    
}
extension viewController : UIWebViewDelegate {
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        jsContext = self.mineWebView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
        jsContext?.setObject(JavaScriptMethod(), forKeyedSubscript: "callSwift" as NSCopying & NSObjectProtocol)
        
    }
    
    
}

