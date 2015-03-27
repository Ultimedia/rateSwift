//
//  WelcomeViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 21/01/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    let applicationModel = ApplicationData.sharedModel()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let locationServices = LocationSevices.locationServices()


    var logoLabel: UILabel?
    var subtitleLabel: UILabel?
    var connectionLabel: UILabel?
    
    var beaconButton:UIButton?
    var wifiButton:UIButton?
    var locationButton:UIButton?
    var bluetoothButton:UIButton?
    var dataButton:UIButton?

    var borderTop:UIView?
    var borderBottom:UIView?
    
    var readyButton:UIButton?
    var eventData = Dictionary<String, String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        
        createUI()
        
        updateConnection()
    }

    
    // draw the user-interface
    func createUI(){
        
        var eventData = Dictionary<String, String>()
        NSNotificationCenter.defaultCenter().postNotificationName("HideBar", object: nil, userInfo:  nil)
        

        logoLabel = UILabel(frame: CGRect(x: 0, y: 80, width: screenSize.width, height: 60))
        logoLabel!.text = "Error."
        logoLabel!.font = UIFont.boldSystemFontOfSize(44)
        logoLabel!.textColor = applicationModel.UIColorFromRGB(0x222222)
        logoLabel!.font =  UIFont (name: "Futura-Medium", size: 60)
        logoLabel?.textAlignment = NSTextAlignment.Center

        
        // line height
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 12
        
        var attrString = NSMutableAttributedString(string: "Om de applicatie te gebruiken moet jouw toestel aan volgende voorwaarden voldoen")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        
        subtitleLabel = UILabel(frame: CGRect(x: 40, y: logoLabel!.frame.origin.y + logoLabel!.frame.height + 20, width: screenSize.width - 80, height: 100))
        subtitleLabel!.numberOfLines = 3
        subtitleLabel!.text = ""
        subtitleLabel!.font =  UIFont (name: "Georgia-Italic", size: 23)
        subtitleLabel!.textColor = applicationModel.UIColorFromRGB(0x222222)
        subtitleLabel?.attributedText = attrString
        
        
        borderTop = UIView(frame: CGRect(x: subtitleLabel!.frame.origin.x, y: subtitleLabel!.frame.origin.y, width: subtitleLabel!.frame.width, height: 1))
        borderTop?.backgroundColor = applicationModel.UIColorFromRGB(0x222222)

      
        borderBottom = UIView(frame: CGRect(x: subtitleLabel!.frame.origin.x, y: subtitleLabel!.frame.origin.y + subtitleLabel!.frame.height, width: subtitleLabel!.frame.width, height: 1))
        borderBottom?.backgroundColor = applicationModel.UIColorFromRGB(0x222222)
        
        
        
        connectionLabel = UILabel(frame: CGRect(x: 40, y: subtitleLabel!.frame.origin.y + subtitleLabel!.frame.height + 40, width: screenSize.width - 80, height: 30))
        connectionLabel!.numberOfLines = 3
        connectionLabel!.text = "Sta volgende verbindingen toe"
        connectionLabel!.font =  UIFont (name: "Futura-Medium", size: 20)
        connectionLabel!.textColor = applicationModel.UIColorFromRGB(0x222222)
        connectionLabel!.textAlignment = NSTextAlignment.Center

        
        // connection buttons
        var buttonWidth = (subtitleLabel!.frame.width / 3)

        
        beaconButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        beaconButton!.setTitle("Bluetooth", forState: UIControlState.Normal)
        beaconButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        beaconButton!.frame = CGRectMake(connectionLabel!.frame.origin.x, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 20, buttonWidth-6.6, buttonWidth)
        beaconButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        beaconButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        beaconButton!.tag = 1
        beaconButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 20)

        
        locationButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        locationButton!.setTitle("Locatie", forState: UIControlState.Normal)
        locationButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        locationButton!.frame = CGRectMake(beaconButton!.frame.width + beaconButton!.frame.origin.x + 10, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 20, buttonWidth - 6.6, buttonWidth)
        locationButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        locationButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        locationButton?.tag = 2
        locationButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 20)

        
        dataButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        dataButton!.setTitle("Data", forState: UIControlState.Normal)
        dataButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        dataButton!.frame = CGRectMake(locationButton!.frame.width + locationButton!.frame.origin.x + 10, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 20, buttonWidth - 6.6, buttonWidth)
        dataButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        dataButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        dataButton?.tag = 3
        dataButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 20)

        
        readyButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        readyButton!.setTitle("CONTROLEER VERBINDING", forState: UIControlState.Normal)
        readyButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        readyButton!.frame = CGRectMake(40, screenSize.height-100, screenSize.width - 80, 60)
        readyButton!.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        readyButton?.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        readyButton!.layer.borderWidth = 3
        readyButton!.layer.borderColor = UIColor.whiteColor().CGColor
        readyButton?.tag = 4
        readyButton?.titleLabel?.textColor = UIColor.whiteColor()
        readyButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 20)
        
        // alternative layout for old iphones
        if(screenSize.width < 375 && screenSize.height < 667){

            // iphone 4S
            if(screenSize.height == 480.0){
                println("iphone 4s")
                logoLabel!.frame = CGRect(x: 0, y: 40, width: screenSize.width, height: 60)
                
                subtitleLabel!.frame = CGRect(x: 40, y: logoLabel!.frame.origin.y + logoLabel!.frame.height + 20, width: screenSize.width - 80, height: 100)

                
                borderTop?.frame = CGRect(x: subtitleLabel!.frame.origin.x, y: subtitleLabel!.frame.origin.y, width: subtitleLabel!.frame.width, height: 1)
                
                borderBottom?.frame = CGRect(x: subtitleLabel!.frame.origin.x, y: subtitleLabel!.frame.origin.y + subtitleLabel!.frame.height, width: subtitleLabel!.frame.width, height: 1)
                
                connectionLabel?.frame = CGRect(x: 40, y: subtitleLabel!.frame.origin.y + subtitleLabel!.frame.height + 15, width: screenSize.width - 80, height: 30)
                connectionLabel!.font =  UIFont (name: "Futura-Medium", size: 16)

                
                beaconButton!.frame = CGRectMake(subtitleLabel!.frame.origin.x, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 5, buttonWidth - 6.6, buttonWidth)
                beaconButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 14)

            
                locationButton!.frame = CGRectMake(beaconButton!.frame.width + beaconButton!.frame.origin.x + 10, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 5, buttonWidth - 6.6, buttonWidth)
                locationButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 16)

                
                dataButton!.frame = CGRectMake(locationButton!.frame.width + locationButton!.frame.origin.x + 10, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 5, buttonWidth - 6.6, buttonWidth)
                dataButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 16)
                
                
            }else{
                println("iphone 5s")
                connectionLabel!.font =  UIFont (name: "Futura-Medium", size: 16)
                dataButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 16)
                locationButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 16)
                beaconButton?.titleLabel?.font = UIFont (name: "Futura-Medium", size: 14)

            }
            
            
            
            // hide menu
        }
        
        
        
        // alternative layout for ipad
        if(deviceFunctionService.deviceType == "ipad"){
            
            logoLabel!.frame = CGRect(x: 0, y: 200, width: screenSize.width, height: 60)
            logoLabel!.font = UIFont.boldSystemFontOfSize(70)

            subtitleLabel!.frame = CGRect(x: 200, y: logoLabel!.frame.origin.y + logoLabel!.frame.height + 40, width: screenSize.width - 400, height: 100)
            subtitleLabel!.textAlignment = NSTextAlignment.Center
            
            borderTop!.frame = CGRect(x: subtitleLabel!.frame.origin.x, y: subtitleLabel!.frame.origin.y, width: subtitleLabel!.frame.width, height: 1)
            
            borderBottom!.frame = CGRect(x: subtitleLabel!.frame.origin.x, y: subtitleLabel!.frame.origin.y + subtitleLabel!.frame.height, width: subtitleLabel!.frame.width, height: 1)


            connectionLabel!.frame = CGRect(x: 40, y: subtitleLabel!.frame.origin.y + subtitleLabel!.frame.height + 60, width: screenSize.width - 80, height: 30)

            buttonWidth = (subtitleLabel!.frame.width / 3)
            
            
            readyButton!.frame = CGRectMake(subtitleLabel!.frame.origin.x, screenSize.height-280, subtitleLabel!.frame.width, 60)
            
            beaconButton!.frame = CGRectMake(subtitleLabel!.frame.origin.x, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 20, buttonWidth - 6.6, buttonWidth)

            locationButton!.frame = CGRectMake(beaconButton!.frame.width + beaconButton!.frame.origin.x + 10, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 20, buttonWidth - 6.6, buttonWidth)

            dataButton!.frame = CGRectMake(locationButton!.frame.width + locationButton!.frame.origin.x + 10, connectionLabel!.frame.origin.y + connectionLabel!.frame.height + 20, buttonWidth - 6.6, buttonWidth)
        }
        
        view.addSubview(logoLabel!)
        view.addSubview(subtitleLabel!)
        view.addSubview(borderTop!)
        view.addSubview(borderBottom!)
        view.addSubview(connectionLabel!)
        view.addSubview(beaconButton!)
        view.addSubview(locationButton!)
        view.addSubview(dataButton!)
        view.addSubview(readyButton!)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionUpdateHandler:", name:"BluetoothOnline", object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionUpdateHandler:", name:"BluetoothOffline", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionUpdateHandler:", name:"LocationPermissionFalse", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionUpdateHandler:", name:"LocationPermissionTrue", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionUpdateHandler:", name:"DataConnectionOffline", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "connectionUpdateHandler:", name:"DataConnectionOnline", object: nil)

    }

    func updateConnection(){
        
        if(applicationModel.bluetooth){
            beaconButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        }else{
            beaconButton?.backgroundColor = UIColor.grayColor()
        }
        
        
        if(applicationModel.location){
            locationButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        }else{
            locationButton?.backgroundColor = UIColor.grayColor()
        }
        
        
        if(applicationModel.networkConnection){
            dataButton?.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        }else{
            dataButton?.backgroundColor = UIColor.grayColor()
        }
        
        if(applicationModel.bluetooth && applicationModel.location && applicationModel.networkConnection){
            
            
            if(applicationModel.lastPage != applicationModel.currentTarget){
            
                eventData["menu"] = applicationModel.lastPage
            NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
            }
        }
    
    }
    
    
    func connectionUpdateHandler(notification: NSNotification){
        updateConnection()
    }
    
    
    /**
    * Create the UI
    */
    func buttonAction(sender:UIButton!)
    {
        // scroll to point
        switch(sender.tag){
        case 1:
            println("check bluetooth")
            
            eventData["errorString"] = "Schakel Bluetooth in"
            NSNotificationCenter.defaultCenter().postNotificationName("ErrorDialog", object: nil, userInfo:  eventData)
            
            break;
            
        case 2:
            println("check location")
            locationServices.initLocationServices()
            
            if(applicationModel.location == false){
                
                eventData["errorString"] = "Ga naar Instellingen > Privacy en sta locatievoorzieningen voor deze applicatie toe"
                NSNotificationCenter.defaultCenter().postNotificationName("ErrorDialog", object: nil, userInfo:  eventData)
            }
            
            break;
            
        case 3:
            println("check data")

            break;
            
        case 4:
            println("ready")

            if(applicationModel.bluetooth && applicationModel.location && applicationModel.networkConnection){
            
                if(applicationModel.lastPage != applicationModel.currentTarget){
                    
                    eventData["menu"] = applicationModel.lastPage
                    NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
                }else{
                    var error:String = ""
                    
                    if(!applicationModel.bluetooth){
                        error += "bluetooth,"
                    }
                    if(!applicationModel.location){
                        error += "locatie toegang,"
                    }
                    if(!applicationModel.networkConnection){
                        error += "data"
                    }
                    
                    eventData["errorString"] = error
                    NSNotificationCenter.defaultCenter().postNotificationName("ErrorDialog", object: nil, userInfo:  eventData)

                }
                
                
            }else{
                
            }
                
            break;
            
        default:
            
            println("none")
        }
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
