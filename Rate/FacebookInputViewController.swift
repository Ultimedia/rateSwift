//
//  FacebookInputViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 9/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class FacebookInputViewController: UIViewController {
    @IBOutlet weak var facebookStatusLabel: UILabel!
    @IBOutlet weak var facebookInputText: UITextField!
    @IBOutlet weak var facebookPostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButton(sender: AnyObject) {
        
        println("plaats op facebook")
    
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
