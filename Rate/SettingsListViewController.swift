//
//  SettingsListViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 12/05/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class SettingsListViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    var infoLabel:UILabel?
    
    @IBOutlet weak var `switch`: UISwitch!
    @IBAction func segmentAction(sender: AnyObject) {
        
    }
    @IBAction func switchSelected(sender: AnyObject) {
        println("j")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
