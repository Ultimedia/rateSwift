//
//  ExhibitFeedbackScreenViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 28/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitFeedbackScreenViewController: UIViewController {

    // UI elements
    var exhibitModel:ExhibitModel?
    var overviewTitleLabel:UILabel?
    var descriptionLabel: UILabel?
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI(){
        // subtitle
        overviewTitleLabel = UILabel(frame: CGRect(x:0, y: 80, width: screenSize.width, height: 100))
        overviewTitleLabel!.numberOfLines = 3
        overviewTitleLabel!.lineBreakMode = .ByWordWrapping
        overviewTitleLabel!.text = exhibitModel?.outroviewInfo_Dutch
        overviewTitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        overviewTitleLabel!.textColor = UIColor.blackColor()
        overviewTitleLabel!.textAlignment = NSTextAlignment.Center
        
        
        // description
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width, height: screenSize.height - 200))
        descriptionLabel!.numberOfLines = 8
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = exhibitModel?.outroviewTitle_Dutch
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.sizeToFit()
        descriptionLabel!.textAlignment = NSTextAlignment.Center
        
        
        // ipad layout update
        if(deviceFunctionService.deviceType == "ipad"){
            descriptionLabel?.frame = CGRect(x: (screenSize.width/2)-200, y: 40, width: 400, height: 300)
        }
        
        
        view.addSubview(overviewTitleLabel!)
        view.addSubview(descriptionLabel!)
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
