//
//  LoadingViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 27/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingSpinner.hidden = true
        
        println("in de loadng")
        SwiftSpinner.show("Data ophalen")
        
        view.backgroundColor = UIColor.blackColor()
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
    
    /**
    * Hide status bar
    */
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
