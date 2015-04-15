//
//  MediaTileViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 20/01/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit
import MediaPlayer


class MediaTileViewController: UIViewController {

    var mediaModel:RoomMediaModel?
    var quoteLabel:UILabel?
    var mediaImageView: UIImageView?
    var moviePlayer:MPMoviePlayerController!
    var descriptionLabel: UILabel?

    var viewWidth:Int? = 0
    var viewHeight:Int? = 0
    var viewWidthFloat:CGFloat? = 0
    var viewHeightFloat:CGFloat? = 0

    
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationModel = ApplicationData.sharedModel()

        quoteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!))
        quoteLabel!.numberOfLines = 5
        quoteLabel!.lineBreakMode = .ByWordWrapping
        quoteLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        quoteLabel!.textColor = UIColor.blackColor()
        quoteLabel!.textAlignment = NSTextAlignment.Center
        
        mediaImageView =  UIImageView(frame:  CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!))
        mediaImageView!.contentMode = UIViewContentMode.ScaleToFill
        
        descriptionLabel = UILabel(frame: CGRect(x: 0, y: viewHeight! / 2, width: viewWidth!, height: viewHeight! / 2))
        descriptionLabel!.numberOfLines = 4
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.textAlignment = NSTextAlignment.Center

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xffeca1)
        
        
        switch(mediaModel!.mercury_room_media_type){
            case "image":
            // add cover image
            let url = NSURL(string: (mediaModel!.mercury_room_media_url))
            if((url) != nil && url != ""){
                view.addSubview(mediaImageView!)
                
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                
                if(data?.length > 0){
                    mediaImageView!.image = UIImage(data: data!)
                }
            }
            quoteLabel!.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            quoteLabel!.text = mediaModel?.mercury_room_media_caption
            quoteLabel!.textColor = UIColor.whiteColor()
            quoteLabel!.font =  UIFont(name: "Futura-Medium", size: 23)
            quoteLabel!.alpha = 0.9
            quoteLabel!.textAlignment = NSTextAlignment.Center
            quoteLabel!.frame = CGRect(x: 10, y: viewHeight! - 40, width: viewWidth! - 20, height: 40)
            view.addSubview(quoteLabel!)
            
            // quoteframe
            var quoteFrame:UIView = UIView()
                quoteFrame.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            //view.addSubview(quoteFrame)

            
            break;
            
        case "editiorial":
            let url = NSURL(string: ( mediaModel!.mercury_room_media_url))
            if((url) != nil && url != ""){
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                if(data?.length > 0){
                    mediaImageView?.frame = CGRect(x: viewWidth! / 2, y: 0, width: viewWidth! / 2, height: viewHeight!)
                    mediaImageView?.image = UIImage(data: data!)
             
                }
            }
            
            view.backgroundColor = UIColor.whiteColor()
            
            
            var editLabel:UILabel = UILabel()
                editLabel.frame = CGRect(x: 10, y: 10, width: viewWidth! / 2 - 20, height: 50)
                editLabel.textColor = UIColor.blackColor()
                editLabel.text = "Harelbeke"
                editLabel.font =  UIFont(name: "Helvetica-Light", size: 25)
                editLabel.sizeToFit()
                view.addSubview(editLabel)
            
            var authorLabel:UILabel = UILabel()
                authorLabel.frame = CGRect(x: 10, y: editLabel.frame.origin.y + editLabel.frame.height + 10, width: view.frame.width, height: 50)
                authorLabel.textColor = UIColor.blackColor()
                authorLabel.text = "Maarten Bressinck".uppercaseString
                authorLabel.sizeToFit()
                view.addSubview(authorLabel)
            
            var editText:UILabel = UILabel()
                editText.frame = CGRect(x: 10, y: authorLabel.frame.origin.y + authorLabel.frame.height + 10, width: view.frame.width, height: 300)
                editText.textColor = UIColor.blackColor()
                editText.text = "Maarten Bressinck"
                editText.font =  UIFont(name: "Helvetica-Light", size: 14)
                editText.sizeToFit()
                view.addSubview(editText)
            
            
            if(deviceFunctionService.deviceType != "ipad"){
                println("hondjes")
                
                mediaImageView?.frame = CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight! / 2)
                editText.frame = CGRect(x: 10, y: authorLabel.frame.origin.y + editText.frame.height + 10, width: view.frame.width, height: CGFloat(viewHeight! / 2))

            }else{
                
            }
            
            view.addSubview(mediaImageView!)

            
            descriptionLabel!.text = mediaModel?.mercury_room_media_caption
            view.addSubview(descriptionLabel!)
            break;
            
        case "video":
            
            var url:NSURL = NSURL(string: "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v")!
                moviePlayer = MPMoviePlayerController(contentURL: url)
                moviePlayer.view.frame = CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!)
                view.addSubview(moviePlayer.view)

                moviePlayer.fullscreen = false
                moviePlayer.controlStyle = MPMovieControlStyle.Embedded
                moviePlayer.play()
            break;
            
        case "quote":
            let url = NSURL(string: ( mediaModel!.mercury_room_media_url))
            if((url) != nil && url != ""){
                let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                if(data?.length > 0){
                    mediaImageView?.frame = CGRect(x: 0, y: 0, width: viewWidth!, height: viewHeight!)
                    mediaImageView?.image = UIImage(data: data!)
                    view.addSubview(mediaImageView!)
                    
                    println("adding image")
                }else{
                    println("ben hierrrr")

                }
            }
          
            
            // TYPE 1 (DEFAULT)
            var quoteBack:UIView = UIView()
                quoteBack.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
                quoteBack.frame = CGRect(x: 20, y: ((viewHeight! / 100) * 40) - 20, width: viewWidth! - 40, height: (viewHeight! / 100) * 60)
                quoteBack.alpha = 0.9
                view.addSubview(quoteBack)
            
            var authorLabel:UILabel = UILabel()
                authorLabel.backgroundColor = applicationModel.UIColorFromRGB(0x222222)
                authorLabel.frame = CGRect(x:(authorLabel.frame.width / 2), y: quoteBack.frame.origin.y - 20, width: CGFloat(400), height: 70)
                authorLabel.text = "Steve Jobs"
                authorLabel.sizeToFit()
                authorLabel.frame.origin.x = (CGFloat(viewWidth!) / 2) - (authorLabel.frame.width / 2)
                authorLabel.textAlignment = NSTextAlignment.Center
                authorLabel.textColor = UIColor.whiteColor()
                authorLabel.text = mediaModel!.mercury_room_media_caption.uppercaseString
                authorLabel.font =  UIFont(name: "AvenirNext-DemiBold", size: 20)
            
                view.addSubview(authorLabel)
            
                quoteLabel!.text = mediaModel?.mercury_room_media_caption
                quoteLabel!.textColor = UIColor.whiteColor()
                quoteLabel!.font =  UIFont(name: "Futura-Medium", size: 23)
                quoteLabel!.textAlignment = NSTextAlignment.Center
                quoteLabel!.frame = CGRect(x: 10, y: 10, width: quoteBack.frame.width - 20, height: quoteBack.frame.height - 20)
                
            
                quoteBack.addSubview(quoteLabel!)
            
            // TYPE 2
            
            break;
        default:
            println("charli")
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
