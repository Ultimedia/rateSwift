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
    var socialModel:RoomSocialModel?
    var socialTitle:UILabel?
    var socialIcon:UIImage?
    var socialIconImageView:UIImageView?
    
    
    var itemWidth:CGFloat?
    var itemHeight:CGFloat?
    
    var mediaImageView:UIImageView?
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xc6823a)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createView(){
        socialTitle = UILabel()
        socialTitle!.frame = CGRect(x: 0, y: 0, width: itemWidth!, height: itemHeight!)
        socialTitle!.textAlignment = NSTextAlignment.Center
        socialTitle!.text = socialModel?.mercury_room_social_data
        socialTitle!.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        socialTitle!.textColor = UIColor.whiteColor()
        socialTitle!.numberOfLines = 8

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleGestureTouch:"))
        
        let colourArray = [0x25d3b8, 0xc6823a, 0x643cc8, 0xa4833e]
        let randomIndex = Int(arc4random_uniform(UInt32(colourArray.count)))
        var colour = UInt(colourArray[randomIndex])
        
        if(applicationModel.socialPopup == true){
            view.backgroundColor = applicationModel.activeSocialItemColor
        }else{
            view.backgroundColor = applicationModel.UIColorFromRGB(colour)
        }
        
        mediaImageView =  UIImageView(frame:  CGRect(x: 0, y: 0, width: itemWidth!, height: itemHeight!))
        mediaImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.socialIconImageView = UIImageView()
        self.socialIconImageView?.backgroundColor = UIColor.clearColor();
        
        switch(socialModel!.mercury_room_social_type){
        case "Text":
            socialIcon = UIImage(named: "social-write")
            socialIconImageView?.image = socialIcon;
            
        self.view.addSubview(self.socialIconImageView!)
            
            view.addSubview(socialTitle!)

            
            break;
            
        case "Camera":
            view.backgroundColor = applicationModel.UIColorFromRGB(0xe5e6de)


            
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.imagePath + socialModel!.mercury_room_social_data)!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    self.image = UIImage(data: data)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mediaImageView?.backgroundColor = UIColor.blackColor()
                        self.mediaImageView?.frame = CGRect(x: 0, y: 0, width:
                            self.itemWidth!, height: self.itemHeight!)
                        self.mediaImageView?.backgroundColor = self.applicationModel.UIColorFromRGB(0xe5e6de)
                       
                        let imageMask1 = UIImage(named: "ImageMask1")
                        self.image = self.image?.scale(CGSizeMake(self.itemWidth!, self.itemHeight!))
                        
                        self.image = self.image?.mask(imageMask1!)
                        self.mediaImageView?.image = self.image;
                        self.view.addSubview(self.mediaImageView!)
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })

            
            
        break;
            
        case "Instagram":
            
            socialIcon = UIImage(named: "social-instagram")
            socialIconImageView?.image = socialIcon

            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: socialModel!.mercury_room_social_data)!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // add cover image
                        self.mediaImageView?.backgroundColor = UIColor.blackColor()
                        self.mediaImageView?.frame = CGRect(x: 0, y: 0, width: self.itemWidth!, height: self.itemHeight!)
                        self.mediaImageView?.image = UIImage(data: data!)
                        self.view.addSubview(self.mediaImageView!)
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        
            break;
            
        case "Twitter":
            socialIcon = UIImage(named: "social-twitter")
            view.addSubview(socialTitle!)
            break;
            
        default:
            println("default")
            break;
        }
        
        

//        socialIconImageView?.alpha = 0.4
        
        
//        self.socialIconImageView = UIImageView(frame: CGRect(x: (self.itemWidth! / 2), y: self.itemHeight! / 2, width: self.socialIcon!.size.width, height:self.socialIcon!.size.height))


    }
    
    

    func createFullView(){
        socialTitle = UILabel()
        socialTitle!.frame = CGRect(x: 0, y: 0, width: itemWidth!, height: itemHeight!)
        socialTitle!.textAlignment = NSTextAlignment.Center
        socialTitle!.text = socialModel?.mercury_room_social_data
        socialTitle!.font =  UIFont (name: "DINAlternate-Bold", size: 30)
        socialTitle!.textColor = UIColor.whiteColor()
        socialTitle!.numberOfLines = 8
        
        
        let colourArray = [0x25d3b8, 0xc6823a, 0x643cc8, 0xa4833e]
        let randomIndex = Int(arc4random_uniform(UInt32(colourArray.count)))
        var colour = UInt(colourArray[randomIndex])
        
        if(applicationModel.socialPopup == true){
            view.backgroundColor = applicationModel.activeSocialItemColor
        }else{
            view.backgroundColor = applicationModel.UIColorFromRGB(colour)
        }
        
        mediaImageView =  UIImageView(frame:  CGRect(x: 0, y: 0, width: itemWidth!, height: itemHeight!))
        mediaImageView!.contentMode = UIViewContentMode.ScaleToFill
        
        
        
        
        switch(socialModel!.mercury_room_social_type){
        case "Camera":
            view.backgroundColor = applicationModel.UIColorFromRGB(0xe5e6de)
            
            
            
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.imagePath + socialModel!.mercury_room_social_data)!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    self.image = UIImage(data: data)
                    
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.mediaImageView?.backgroundColor = UIColor.blackColor()
                        self.mediaImageView?.frame = CGRect(x: 0, y: 0, width:
                            self.itemWidth!, height: self.itemHeight!)
                        self.mediaImageView?.backgroundColor = self.applicationModel.UIColorFromRGB(0xe5e6de)
                        
                        let imageMask1 = UIImage(named: "ImageMask1")
                        self.image = self.image?.scale(CGSizeMake(self.itemWidth!, self.itemHeight!))
                        
                        self.image = self.image?.mask(imageMask1!)
                        self.mediaImageView?.image = self.image;
                        self.view.addSubview(self.mediaImageView!)
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        break;
            
        case "Text":
            socialIcon = UIImage(named: "social-instagram")
            view.addSubview(socialTitle!)

        break;
            
        case "Instagram":
            
            
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.imagePath + socialModel!.mercury_room_social_data)!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // add cover image
                        self.mediaImageView?.backgroundColor = UIColor.blackColor()
                        self.mediaImageView?.frame = CGRect(x: 0, y: 0, width: self.itemWidth!, height: self.itemHeight!)
                        self.mediaImageView?.image = UIImage(data: data!)
                        self.view.addSubview(self.mediaImageView!)
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
            break;
            
        case "Twitter":
            socialIcon = UIImage(named: "social-twitter")
            view.addSubview(socialTitle!)
            break;
            
        default:
            println("default")
            break;
        }
        

        
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
