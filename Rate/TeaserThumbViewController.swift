//
//  TeaserThumbViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 26/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class TeaserThumbViewController: UIViewController {

    var exhibitModel:ExhibitModel?
    @IBOutlet weak var coverImage: UIImageView!
    var image:UIImage?
    var imageView: UIImageView?
    var subtitleLabel: UILabel?
    var active:Bool = false
    let applicationModel = ApplicationData.sharedModel()
    var eventData = Dictionary<String, String>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 5
        view.layer.borderColor = UIColor.whiteColor().CGColor
        
        subtitleLabel = UILabel(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
        subtitleLabel!.numberOfLines = 8
        subtitleLabel!.lineBreakMode = .ByWordWrapping
        subtitleLabel!.text = "Wij zoeken momenteel naar het dichtstbijzijnde museum"
        subtitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 18)
        subtitleLabel!.textColor = UIColor.blackColor()
        subtitleLabel!.text = exhibitModel?.exhibit_title
        subtitleLabel!.textAlignment = .Center;
        view.addSubview(subtitleLabel!)
        
        
        var button: UIButton = UIButton()
        button.setImage(UIImage(named: "cameraIconInactive"), forState: .Normal)
        button.frame = CGRectMake(0, 0, view.bounds.width, view.bounds.height)
        button.addTarget(self, action: "pushProfileToCamera:", forControlEvents: UIControlEvents.TouchUpInside)
        button.backgroundColor = UIColor.clearColor()
        view.addSubview(button)
    }
    
    
    func pushProfileToCamera(sender: AnyObject) {

        if(active){

            applicationModel.localExhibitSelected = true
            
            // now open the exhibit
            applicationModel.selectedExhibit = exhibitModel
        
            // change menu icon
            eventData["icon"] = "exhibit"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuIcon", object: nil, userInfo:  eventData)
            
            eventData["title"] = applicationModel.selectedExhibit?.exhibit_title
        
            NSNotificationCenter.defaultCenter().postNotificationName("SetTitle", object: nil, userInfo:  eventData)
            
            
            // now go to the exhibit because we clicked on it
            eventData["menu"] = "exhibit"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
            

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
