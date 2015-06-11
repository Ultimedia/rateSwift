//
//  ManualLoginViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 24/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ManualLoginViewController: UIViewController {

    var eventData = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signOnButton(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("ShowMenuButton", object: nil, userInfo:  eventData)

        
        eventData["menu"] = "teaser"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        self.dismissViewControllerAnimated(false, completion: nil)
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
