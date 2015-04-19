//
//  SocialToolbarViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 17/04/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class SocialToolbarViewController: UIViewController {

    var twitterButton:UIButton?
    var facebookButton:UIButton?
    var instagramButton:UIButton?
    
    var textButton:UIButton?
    var cameraButton:UIButton?
    var audiButton:UIButton?
    
    let applicationModel = ApplicationData.sharedModel()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.whiteColor()
        
        
        // Buttons
        var twitterIcon:UIImage = UIImage(named: "social-twitter")!
        twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        twitterButton!.setTitle("", forState: UIControlState.Normal)
        twitterButton!.frame = CGRectMake(20, 20, 80, 80)
        twitterButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        twitterButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        twitterButton!.setImage(twitterIcon, forState: UIControlState.Normal)
        

        var facebookIcon:UIImage = UIImage(named: "social-facebook")!
        facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        facebookButton!.setTitle("", forState: UIControlState.Normal)
        facebookButton!.frame = CGRectMake(120, 20, 80, 80)
        facebookButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        facebookButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        facebookButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        facebookButton!.setImage(facebookIcon, forState: UIControlState.Normal)

        
        
        var instagramIcon:UIImage = UIImage(named: "social-instagram")!
        instagramButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        instagramButton!.setTitle("", forState: UIControlState.Normal)
        instagramButton!.frame = CGRectMake(220, 20, 80, 80)
        instagramButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        instagramButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        instagramButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        instagramButton!.setImage(instagramIcon, forState: UIControlState.Normal)
        
        
        
        var writeIcon:UIImage = UIImage(named: "social-write")!
        textButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        textButton!.setTitle("", forState: UIControlState.Normal)
        textButton!.frame = CGRectMake(screenSize.width - 300, 20, 80, 80)
        textButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        textButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        textButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        textButton!.setImage(writeIcon, forState: UIControlState.Normal)
        

        var audiImage:UIImage = UIImage(named: "social-mic")!
        audiButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        audiButton!.setTitle("", forState: UIControlState.Normal)
        audiButton!.frame = CGRectMake(screenSize.width - 200, 20, 80, 80)
        audiButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        audiButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        audiButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        audiButton!.setImage(audiImage, forState: UIControlState.Normal)
        
        
        
        var cameraIcon:UIImage = UIImage(named: "social-cam")!
        cameraButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        cameraButton!.setTitle("", forState: UIControlState.Normal)
        cameraButton!.frame = CGRectMake(screenSize.width - 100, 20, 80, 80)
        cameraButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        cameraButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cameraButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        cameraButton!.setImage(cameraIcon, forState: UIControlState.Normal)
        
        
        
        // if mobile
        if(deviceFunctionService.deviceType == "ipad"){

        
        }else{

            // iphone layout
            
        }
        
        
        
        view.addSubview(twitterButton!)
        view.addSubview(facebookButton!)
        view.addSubview(instagramButton!)
        
        view.addSubview(textButton!)
        view.addSubview(audiButton!)
        view.addSubview(cameraButton!)

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
