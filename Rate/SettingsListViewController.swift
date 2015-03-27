//
//  SettingsListViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 9/03/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class SettingsListViewController: UIViewController {

    var infoLabel:UILabel?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 80)
        

        // Do any additional setup after loading the view.
        
        infoLabel = UILabel()
        infoLabel?.frame = CGRect(x: 10, y: 10, width: screenSize.width, height: 60)
        infoLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 30)
        infoLabel?.text = "test"
        infoLabel?.textColor = UIColor.blackColor()
        infoLabel?.textAlignment = .Left;
        view.addSubview(infoLabel!)
        
        
        /*

        // add settings
        var notificationEnabled:UIView = UIView()
        notificationEnabled.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 80)
        notificationEnabled.backgroundColor = applicationModel.UIColorFromRGB(0xf6f0f0)
        scrollView?.addSubview(notificationEnabled)
        
        
        var facebookEnabled:UIView = UIView()
        facebookEnabled.frame = CGRect(x: 0, y: 81, width: screenSize.width, height: 80)
        facebookEnabled.backgroundColor = applicationModel.UIColorFromRGB(0xf6f0f0)
        scrollView?.addSubview(facebookEnabled)
        
        var twitterEnabled:UIView = UIView()
        twitterEnabled.frame = CGRect(x: 0, y: 162, width: screenSize.width, height: 80)
        twitterEnabled.backgroundColor = applicationModel.UIColorFromRGB(0xf6f0f0)
        scrollView?.addSubview(twitterEnabled)
        */
        
        // Initialize
        let items = ["Aan", "Uit"]
        let customSC = UISegmentedControl(items: items)
        customSC.selectedSegmentIndex = 0
        
        // Set up Frame and SegmentedControl
        
        // Style the Segmented Control
        customSC.layer.cornerRadius = 5.0  // Don't let background bleed
        customSC.backgroundColor = UIColor.blackColor()
        customSC.tintColor = UIColor.whiteColor()
        customSC.frame = CGRect(x: screenSize.width - customSC.frame.width - 10, y: 20, width: 80, height: 40)
        
        // Add target action method
        customSC.addTarget(self, action: "changeColor:", forControlEvents: .ValueChanged)
        
        // Add this custom Segmented Control to our view
        self.view.addSubview(customSC)
    }
    
    func changeColor(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 1:
            self.view.backgroundColor = UIColor.greenColor()
        case 2:
            self.view.backgroundColor = UIColor.blueColor()
        default:
            self.view.backgroundColor = UIColor.purpleColor()
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
