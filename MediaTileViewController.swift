//
//  MediaTileViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 20/01/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit
//import YouTubePlayer


class MediaTileViewController: UIViewController, PlayerDelegate {
    
    var mediaModel:RoomMediaModel?
    var quoteLabel:UILabel?
    var mediaImageView: UIImageView?
 //   var videoPlayer:YouTubePlayerView?
    var descriptionLabel: UILabel?
    let applicationModel = ApplicationData.sharedModel()
    
    var viewWidth:Int? = 0
    var viewHeight:Int? = 0
    var viewWidthFloat:CGFloat? = 0
    var viewHeightFloat:CGFloat? = 0
    var ViewControllerVideoPath:String?

    var player:Player?

    var infoNumber:String? = ""
    
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    
    var guidedColor:UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
    }
    
    func createView(){
        
        if(deviceFunctionService.deviceType != "ipad" &&  applicationModel.mediaPopup){
            
            viewWidth = Int(screenSize.width - 40)
            viewHeight = Int(screenSize.height - 120)
        }
        
        // colour style
        switch infoNumber! {
        case "1":
            guidedColor = applicationModel.UIColorFromRGB(0x25d3b8)
            break;
            
        case "2":
            guidedColor = applicationModel.UIColorFromRGB(0xF78228)
            break;
            
        default:
            guidedColor = applicationModel.UIColorFromRGB(0xF78228)
        }
        
        quoteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!))
        quoteLabel!.numberOfLines = 5
        quoteLabel!.lineBreakMode = .ByWordWrapping
        quoteLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        quoteLabel!.textColor = UIColor.clearColor()
        quoteLabel!.textAlignment = NSTextAlignment.Center
        
        mediaImageView =  UIImageView(frame:  CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!))
        mediaImageView!.contentMode = UIViewContentMode.ScaleAspectFill
        
        mediaImageView!.clipsToBounds = true

        mediaImageView!.backgroundColor = UIColor.clearColor()
        descriptionLabel = UILabel(frame: CGRect(x: 0, y: viewHeight! / 2, width: viewWidth!, height: viewHeight! / 2))
    
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.textAlignment = NSTextAlignment.Center

        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clearColor()
        
        switch(mediaModel!.mercury_room_media_type){
        case "image":
            
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.imagePath + mediaModel!.mercury_room_media_url)!)
            
            SwiftSpinner.show("Afbeelding Laden")

            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // add cover image
                        self.mediaImageView!.image = UIImage(data: data!)
                        
                        SwiftSpinner.hide()

                        // just a ribbon with the type
                        var typeLabel:UILabel = UILabel()
                        typeLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)
                        typeLabel.textColor = UIColor.blackColor()
                        typeLabel.text = "AFBEELDING"
                        typeLabel.textColor = self.applicationModel.UIColorFromRGB(0xFFFFFF)
                        typeLabel.font =  UIFont (name: "DINAlternate-Bold", size: 12)
                        typeLabel.backgroundColor = self.applicationModel.UIColorFromRGB(0x222222)
                        typeLabel.sizeToFit()
                        typeLabel.textAlignment = NSTextAlignment.Center
                

                        if(self.deviceFunctionService.deviceType != "ipad"){
                            self.mediaImageView!.frame = CGRect(x: 0, y: 0, width: self.viewWidth!, height: self.viewHeight!)
                            
                            typeLabel.frame = CGRect(x: 0, y: 10, width: 90, height: 30)

                        }else{
                            
                        }
                        
                        self.view.addSubview(typeLabel)
                        
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
            
            
            quoteLabel!.backgroundColor = guidedColor
            
            quoteLabel!.text = mediaModel?.mercury_room_media_caption
            quoteLabel!.textColor = UIColor.whiteColor()
            quoteLabel!.font =  UIFont(name: "Futura-Medium", size: 23)
            quoteLabel!.alpha = 0.9
            quoteLabel!.textAlignment = NSTextAlignment.Center
            quoteLabel!.frame = CGRect(x: 10, y: viewHeight! - 60, width: viewWidth! - 20, height: 40)
            
            println(mediaModel?.mercury_room_media_caption)
            
            view.addSubview(mediaImageView!)

            if(mediaModel?.mercury_room_media_caption != ""){
                view.addSubview(quoteLabel!)

            }
            
            
            // quoteframe
            var quoteFrame:UIView = UIView()
            quoteFrame.backgroundColor = guidedColor
            
            break;
            
        case "editorial":
            
            
            let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.imagePath + mediaModel!.mercury_room_media_url)!)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    let image = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        // add cover image
                        self.mediaImageView?.frame = CGRect(x: self.viewWidth! / 2, y: 0, width: self.viewWidth! / 2, height: self.viewHeight!)
                        
                        if(self.deviceFunctionService.deviceType != "ipad"){
                            self.mediaImageView!.frame = CGRect(x: 0, y: 0, width: self.viewWidth!, height: self.viewHeight! / 2)
                            self.mediaImageView!.contentMode = .ScaleAspectFit
                            self.mediaImageView!.backgroundColor = UIColor.clearColor()
                        }
                        
                        self.mediaImageView?.image = UIImage(data: data!)
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
            
            
            var backView:UIView = UIView()
            backView.frame = CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!)
            backView.backgroundColor = UIColor.whiteColor()
            view.addSubview(backView)
            
            var editLabel:UILabel = UILabel()
            editLabel.frame = CGRect(x: 10, y: 10, width: viewWidth! / 2 - 20, height: 50)
            editLabel.textColor = UIColor.blackColor()
            editLabel.text = ""
            editLabel.font =  UIFont(name: "Helvetica-Light", size: 25)
            editLabel.sizeToFit()
            view.addSubview(editLabel)
            
            
            // just a ribbon with the type
            var authorLabel:UILabel = UILabel()
            authorLabel.frame = CGRect(x: 10, y: 30, width: view.frame.width, height: 30)
            authorLabel.textColor = UIColor.blackColor()
            authorLabel.text = "EDITORIAL"
            authorLabel.font = UIFont.boldSystemFontOfSize(33)
            authorLabel.textColor = applicationModel.UIColorFromRGB(0x242424)
            authorLabel.font =  UIFont (name: "DINAlternate-Bold", size: 16)
            authorLabel.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            authorLabel.sizeToFit()
            authorLabel.textAlignment = NSTextAlignment.Center
            
            
            // author
            var editText:UILabel = UILabel()
            editText.frame = CGRect(x: 10, y: authorLabel.frame.origin.y + authorLabel.frame.height + 10, width: view.frame.width, height: 300)
            editText.textColor = UIColor.blackColor()
            editText.text = mediaModel?.mercury_room_author
            editText.font =  UIFont(name: "Helvetica-Light", size: 12)
            editText.sizeToFit()
            
        

            
            view.addSubview(editText)
            
            if(deviceFunctionService.deviceType != "ipad"){
                
                authorLabel.frame = CGRect(x: 0, y: 10, width: 85, height: 30)
                
                authorLabel.textColor = self.applicationModel.UIColorFromRGB(0xFFFFFF)
                authorLabel.font =  UIFont (name: "DINAlternate-Bold", size: 12)
                authorLabel.backgroundColor = self.applicationModel.UIColorFromRGB(0x222222)
                
                mediaImageView?.frame = CGRect(x: 10, y: 0, width: viewWidth! - 20, height: viewHeight! / 2)
                mediaImageView?.contentMode = .ScaleAspectFit
                
                editText.frame = CGRect(x: 10, y: viewHeight! - 30, width: 200, height: 20)
                editText.backgroundColor = UIColor.clearColor()
                
                descriptionLabel?.frame = CGRect(x: 10, y: viewHeight! / 2 + 10, width: viewWidth!, height: viewHeight! / 2)
                descriptionLabel!.textAlignment = NSTextAlignment.Left
                descriptionLabel!.text = mediaModel?.mercury_room_media_caption

                descriptionLabel!.numberOfLines = 0
                descriptionLabel?.backgroundColor = UIColor.clearColor()
                descriptionLabel!.sizeToFit()

            }else{
                descriptionLabel?.frame = CGRect(x: 10, y: 140, width: viewWidth! / 2, height: viewHeight! - 140)
                descriptionLabel!.textAlignment = NSTextAlignment.Left
                
            }
            
            view.addSubview(mediaImageView!)
            view.addSubview(authorLabel)
            view.addSubview(editText)
            
            
            view.addSubview(descriptionLabel!)
            break;
            
        case "video":
            player = Player()
            player!.delegate = self
            player!.view.frame = CGRect(x: 0, y:0 , width: viewWidth!, height: viewHeight!)
            
            addChildViewController(player!)
            view.addSubview(player!.view)
            player!.didMoveToParentViewController(self)
            
            player!.path = mediaModel?.mercury_room_media_caption
            player!.playbackLoops = true

            break;
            
        case "quote":
            let url = NSURL(string: (applicationModel.imagePath + mediaModel!.mercury_room_media_url))
            if((url) != nil && url != ""){
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                if(data?.length > 0){
                    mediaImageView?.frame = CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!)
                    mediaImageView?.image = UIImage(data: data!)
                    view.addSubview(mediaImageView!)
                    
                }else{
                    
                }
            }
            
            // TYPE 1 (DEFAULT)
            var quoteBack:UIView = UIView()
            quoteBack.backgroundColor = guidedColor!
            quoteBack.frame = CGRect(x: 20, y: ((viewHeight! / 100) * 40) - 20, width: viewWidth! - 40, height: (viewHeight! / 100) * 60)
            quoteBack.alpha = 0.9
            view.addSubview(quoteBack)
            
            var authorLabel:UILabel = UILabel()
            authorLabel.text = mediaModel!.mercury_room_media_caption.uppercaseString
            authorLabel.frame.origin.x = (CGFloat(viewWidth!) / 2) - (authorLabel.frame.width / 2)
            authorLabel.textAlignment = NSTextAlignment.Center
            authorLabel.textColor = UIColor.whiteColor()
            authorLabel.text = mediaModel?.mercury_room_media_caption
            authorLabel.numberOfLines = 4
            authorLabel.font =  UIFont(name: "AvenirNext-DemiBold", size: 20)
            
            view.addSubview(authorLabel)
            
            authorLabel.frame = CGRect(x:10, y: 100, width: CGFloat(viewWidth!) - 20, height: 100)
            authorLabel.frame = quoteBack.frame
            
            
            // just a ribbon with the type
            var typeLabel:UILabel = UILabel()
            typeLabel.frame = CGRect(x: 10, y: 30, width: view.frame.width, height: 30)
            typeLabel.textColor = UIColor.blackColor()
            typeLabel.text = "QUOTE"
            typeLabel.font = UIFont.boldSystemFontOfSize(33)
            typeLabel.textColor = applicationModel.UIColorFromRGB(0x242424)
            typeLabel.font =  UIFont (name: "DINAlternate-Bold", size: 12)
            typeLabel.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            typeLabel.sizeToFit()
            typeLabel.backgroundColor = self.applicationModel.UIColorFromRGB(0x222222)
            typeLabel.textColor = self.applicationModel.UIColorFromRGB(0xFFFFFF)

            typeLabel.textAlignment = NSTextAlignment.Center

            
            if(deviceFunctionService.deviceType != "ipad"){
                
                typeLabel.frame = CGRect(x: 0, y: 10, width: 70, height: 30)

            }else{

            }
            
            
            /*
            quoteLabel!.text = "heeeeeeelooooo"
            quoteLabel!.textColor = UIColor.whiteColor()
            quoteLabel!.font =  UIFont(name: "Futura-Medium", size: 23)
            quoteLabel!.textAlignment = NSTextAlignment.Center
            quoteLabel!.frame = CGRect(x: 10, y: 10, width: viewWidth! - 20, height: viewHeight! - 20)
            quoteLabel!.numberOfLines = 6
            
            quoteBack.addSubview(quoteLabel!)*/
            
            // TYPE 2
            
            view.addSubview(typeLabel)
            
            break;
        default:
            println("charli")
        }
        
    }
    
    
    
    func highlightElement(sender:UIButton!){
        
        println("jaaa")
        
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
    
    // MARK: PlayerDelegate
    
    func playerReady(player: Player) {
    }
    
    func playerPlaybackStateDidChange(player: Player) {
    }
    
    func playerBufferingStateDidChange(player: Player) {
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
    }
    
    func playerPlaybackDidEnd(player: Player) {
    }
    
}
