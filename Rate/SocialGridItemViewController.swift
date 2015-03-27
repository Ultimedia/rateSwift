//
//  SocialGridItemViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 27/03/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class SocialGridItemViewController: UIViewController {

    var viewHeight:Int = 100
    var viewWidth:Int = 100
    
    let applicationModel = ApplicationData.sharedModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xc6823a)
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
