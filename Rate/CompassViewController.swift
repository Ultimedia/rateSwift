//
//  CompassViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 27/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class CompassViewController: UIViewController {
    @IBOutlet weak var compasLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clearColor()
        
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