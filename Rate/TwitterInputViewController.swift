//
//  TwitterInputViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 9/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class TwitterInputViewController: UIViewController {

    var textField:UITextField?
    @IBOutlet weak var twitterInput: UITextField!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var twitterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set twitterlabel
        twitterLabel.text = twitterLabel.text! + " heloo"
        
        // Do any additional setup after loading the view.
        createUI()
    }
    
    func createUI(){
 
        // 385
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tweetButton(sender: AnyObject) {
        println("sending tweet")
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
