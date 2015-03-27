//
//  InfoPanelViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 6/02/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class InfoPanelViewController: UIViewController {

    var infoText: UILabel?
    @IBOutlet weak var infoTitle: UILabel!
    @IBOutlet weak var infoSubtitle: UILabel!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    // Location Services
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xdbdcd4)

        
        //- infoTitle.frame.width - infoTitle.frame.origin.y
        
        infoText = UILabel(frame: CGRectMake(infoTitle.frame.origin.x + infoTitle.frame.width + 10, 0, screenSize.width - infoTitle.frame.origin.x - infoTitle.frame.width - 20, view.frame.height))
        infoText?.textAlignment = NSTextAlignment.Left
        infoText?.numberOfLines = 4
        infoText!.font =  UIFont (name: "Avenir-Light", size: 18)

        self.view.addSubview(infoText!)
        
        
        // if mobile
        if(deviceFunctionService.deviceType == "ipad"){

            
            infoText?.text = "Deze applicatie gaat automatisch opzoek naar musea in de buurt. Wanneer je in een museum bent uit onderstaande lijst gaat deze je begeleiden bij het bezoek."

        }else{
            infoText?.frame = CGRectMake(infoTitle.frame.origin.x + infoTitle.frame.width, 0, screenSize.width - infoTitle.frame.origin.x - infoTitle.frame.width, view.frame.height)
            
            infoText?.text = "Deze applicatie gaat automatisch opzoek naar musea in jouw buurt."

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
