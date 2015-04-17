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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.whiteColor()
        
        
        // Buttons
        var twitterIcon:UIImage = UIImage(named: "social-twitter")!
    
        twitterButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        twitterButton!.setTitle("", forState: UIControlState.Normal)
        twitterButton!.frame = CGRectMake(20, 0, 80, 80)
        twitterButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        twitterButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        twitterButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        twitterButton!.setImage(twitterIcon, forState: UIControlState.Normal)
        

        facebookButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        facebookButton!.setTitle("Comment", forState: UIControlState.Normal)
        twitterButton!.frame = CGRectMake(120, 0, 80, 80)
        facebookButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        facebookButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        facebookButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        
        cameraButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        cameraButton!.setTitle("Comment", forState: UIControlState.Normal)
        cameraButton!.frame = CGRectMake(220, 0, 80, 80)
        cameraButton!.addTarget(self, action: "showCommentPanel:", forControlEvents: UIControlEvents.TouchUpInside)
        cameraButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cameraButton!.backgroundColor = applicationModel.UIColorFromRGB(0x653dc9)
        
        view.addSubview(twitterButton!)
        view.addSubview(facebookButton!)
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
