//
//  MenuViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 20/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {



    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds


    var helpLabel:UIButton?
    var settingsLabel:UILabel?
    var collectionLabel:UILabel?
    var closeLabel:UIButton?

    
    var eventData = Dictionary<String, String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
        
        view.backgroundColor = UIColor.clearColor()

    }
    
    
    /**
    * Handle navigation
    */
    func menuChangedHandler(notification: NSNotification){
        
    }

    
    /**
    * Menu Buttons
    */
    @IBAction func currentExhibitView(sender: AnyObject) {
        changeMenu("exhibit")
    }
    
    @IBAction func startView(sender: AnyObject) {
        changeMenu("teaser")
    }
    
    @IBAction func closeMenu(sender: AnyObject) {
    
        
        UIView.animateWithDuration(0.5, animations: {
            
            // for the x-position I entered 320-50 (width of screen - width of the square)
            // if you want, you could just enter 270
            // but I prefer to enter the math as a reminder of what's happenings
            self.view.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: self.screenSize.height)
            self.view.alpha = 0
            },
            
            completion: { finished in if(finished) {
                self.dismissViewControllerAnimated(false, completion: nil)
            }
        })


    }
    
    @IBAction func showHelpView(sender: AnyObject) {
        changeMenu("help")
    }
    
    @IBAction func showSettings(sender: AnyObject) {
        changeMenu("settings")
    }
    
    @IBAction func showFavoritesView(sender: AnyObject) {
        changeMenu("favourites")
    }

    
    func changeMenu(targetPage:String){
        
        eventData["menu"] = targetPage
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    
    /** 
    * Create UI
    */
    func createUI(){
        
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