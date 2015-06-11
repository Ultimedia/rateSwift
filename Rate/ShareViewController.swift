//
//  ShareViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 3/06/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices


class ShareViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // camera
    var shareType:String?
    var titelLabel:UILabel?
    var roomLabel:UILabel?
    var inputText:UITextView?
    var submitButton:UIButton?
    var cameraButton:UIButton?
    var cameraView:UIView?

    var closeButton:UIButton?
    weak var picker : UIImagePickerController?
    var uploadedImage:UIImage?
    var imageSelected:Bool? = false;
    
    var socialModel:RoomSocialModel?
    var currentScrollPos:CGFloat! = 0;
    var selectedRoomId:Int = 0;
    
    var share:String?
    var data:String?
    var user_id:String?
    
    
    // Screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let applicationModel = ApplicationData.sharedModel()
    let dataServices = DataManager.dataManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(white: 1, alpha: 0.9);
        view.backgroundColor = applicationModel.UIColorFromRGB(0xd8d9d0);
        
        titelLabel = UILabel(frame: CGRect(x: 0, y: 20, width: screenSize.width, height: 40))
        titelLabel?.font =  UIFont(name: "Futura-Medium", size: 30)
        titelLabel?.textColor = applicationModel.UIColorFromRGB(0x242424)
        titelLabel?.text = "Deel jouw mening"
        titelLabel?.textAlignment = NSTextAlignment.Center;
        view.addSubview(titelLabel!)
    
        roomLabel = UILabel(frame: CGRect(x: 0, y: 55, width: screenSize.width, height: 40))
        roomLabel?.font =  UIFont(name: "Futura-Medium", size: 20)
        roomLabel?.textColor = applicationModel.UIColorFromRGB(0x242424)
        roomLabel?.text = "Ruimte 1"
        roomLabel?.textAlignment = NSTextAlignment.Center;
        view.addSubview(roomLabel!)
        
        inputText = UITextView(frame: CGRect(x: 50, y: 140, width: screenSize.width - 100, height: 200));
        inputText?.backgroundColor = UIColor.whiteColor()
        inputText?.delegate = self
        inputText?.layer.borderWidth = 5.0;
        inputText?.layer.borderColor = UIColor.grayColor().CGColor
        inputText?.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        
        submitButton = UIButton();
        submitButton!.frame = CGRect(x: 50, y: 200, width: screenSize.width - 100, height: 40)
        submitButton!.backgroundColor = applicationModel.UIColorFromRGB(0x21cdaf);
        submitButton!.addTarget(self, action: "submitData:", forControlEvents: .TouchUpInside)
        submitButton!.setTitleColor(applicationModel.UIColorFromRGB(0x222325), forState: .Normal)
        submitButton!.setTitle("Verstuur", forState: .Normal)
        
        cameraButton = UIButton();
        cameraButton!.frame = CGRect(x: 50, y: 200, width: screenSize.width - 100, height: 40)
        cameraButton!.backgroundColor = applicationModel.UIColorFromRGB(0x21cdaf);
        cameraButton!.addTarget(self, action: "doTake:", forControlEvents: .TouchUpInside)
        cameraButton!.setTitleColor(applicationModel.UIColorFromRGB(0x222325), forState: .Normal)
        cameraButton!.setTitle("Neem foto", forState: .Normal)
        
        
        cameraView = UIView();
        cameraView?.backgroundColor = UIColor.whiteColor()
        cameraView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 300)
        
        
        var closeImage = UIImage(named: "close-icon");
        closeButton = UIButton();
        closeButton!.frame = CGRect(x: screenSize.width - 40, y: 10, width: 30, height: 30)
        closeButton!.backgroundColor = UIColor.clearColor()
        closeButton!.addTarget(self, action: "closeView:", forControlEvents: .TouchUpInside)
        closeButton!.setTitleColor(applicationModel.UIColorFromRGB(0x222325), forState: .Normal)
        closeButton!.setBackgroundImage(closeImage, forState: UIControlState.Normal)
        
        self.view.addSubview(submitButton!)
        self.view.addSubview(closeButton!)
        
        self.determineStatus()
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "determineStatus",
            name: UIApplicationWillEnterForegroundNotification,
            object: nil)
        
    }
    
    func doTake (sender:AnyObject!) {
        let ok = UIImagePickerController.isSourceTypeAvailable(.Camera)
        if (!ok) {
            println("no camera")
            return
        }
        let desiredType = kUTTypeImage as! String
        // let desiredType = kUTTypeMovie
        let arr = UIImagePickerController.availableMediaTypesForSourceType(.Camera) as! [String]
        println(arr)
        if find(arr, desiredType) == nil {
            println("no capture")
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.mediaTypes = [desiredType]
        picker.delegate = self
        

        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextView!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        inputText!.resignFirstResponder()
        return true;
    }
    
    func closeView(sender:UIButton!){
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
            self.view.alpha = 0
            return
            }, completion: { finished in
                inputText!.resignFirstResponder()
        })

    }
    
    func setShareLayout(){
        
    }
   
    func submitData(sender: UIButton!) {
        
        UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
            self.view.alpha = 0
            return
            }, completion: { finished in
                self.inputText!.resignFirstResponder()
                self.applicationModel.socialPanel = false;

        })

        share = shareType!
        data = ""
        user_id = ""
        
        if(applicationModel.activeUser != nil){
            if(applicationModel.activeUser?.user_id != ""){
                user_id = applicationModel.activeUser!.user_id;
            }else{
                user_id = "0";
            }
        }

        
        switch(shareType!){
            case "Twitter":
    
            break;
            
            case "Facebook":
            
            break;
            
            case "Instagram":
            
            break;
            
            case "Text":
                // get text
                inputText!.resignFirstResponder()
                data = inputText!.text
                
                socialModel = RoomSocialModel(mercury_room_social_id: "0", mercury_room_id: String(selectedRoomId), mercury_room_social_type: share, mercury_room_social_data: data, mercury_user_id:"1")
                
                dataServices.postSocialData(socialModel!, dataObject: data!);
            break;
            
            case "Audio":
            
            break;
            
            case "Camera":
                
                socialModel = RoomSocialModel(mercury_room_social_id: "0", mercury_room_id: String(selectedRoomId), mercury_room_social_type: share, mercury_room_social_data: "", mercury_user_id:"1")

            
                upload(uploadedImage!)
                
            break;
            
            default:
            
            break;
            
        }
        
        
        
        
        
        //

    }
    

    func setShare(){
        

        // now get the room we're on
        for roomPos in applicationModel.roomPosition{
            if(CGFloat(currentScrollPos!) >= roomPos.mercury_room_start){
                if(roomPos.mercury_room_end >= CGFloat(currentScrollPos!)){
                    selectedRoomId = roomPos.mercury_room_id.toInt()!;
                }
            }
        }
        
        
        switch(shareType!){
        case "Twitter":
            
            break;
            
        case "Facebook":
            
            break;
            
        case "Instagram":
            
            break;
            
        case "Text":
            inputText = UITextView(frame: CGRect(x: 20, y: 110, width: screenSize.width - 40, height: 140));
            submitButton!.frame = CGRect(x: 20, y: inputText!.frame.origin.y + inputText!.frame.height + 10, width: screenSize.width - 40, height: 50)
            self.view.addSubview(inputText!)

            break;
            
        case "Audio":
            
            break;
            
        case "Camera":
            
            println("in de came")
            cameraView?.frame = CGRect(x: 20, y: 110, width: screenSize.width - 40, height: 240)

            cameraButton!.frame = CGRect(x: 20, y: cameraView!.frame.origin.y + cameraView!.frame.height + 20, width: screenSize.width - 40, height: 50)
 
            submitButton!.frame = CGRect(x: 20, y: cameraButton!.frame.origin.y + cameraButton!.frame.height + 10, width: screenSize.width - 40, height: 50)

            self.view.addSubview(cameraView!)
            self.view.addSubview(cameraButton!)

            break;
            
        default:
            break;
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            
            println("did finish picking")
            
            println(info[UIImagePickerControllerReferenceURL])
            let url = info[UIImagePickerControllerMediaURL] as? NSURL
            var im = info[UIImagePickerControllerOriginalImage] as? UIImage
            let edim = info[UIImagePickerControllerEditedImage] as? UIImage
            if edim != nil {
                im = edim
            }
            self.dismissViewControllerAnimated(true) {
                println("dimissing controller")
                
                
                let type = info[UIImagePickerControllerMediaType] as? String
                if type != nil {
                    switch type! {
                    case kUTTypeImage as! String:
                        if im != nil {
                            
                           self.uploadedImage = im;
                            self.showImage(im!)
                        }
                    case kUTTypeMovie as! String:
                        if url != nil {
                            //self.showMovie(url!)
                        }
                    default:break
                    }
                }
            }
    }
    
    
    func showImage(im:UIImage) {
        self.clearAll()
        let iv = UIImageView(image:im)
        imageSelected = true;
        
        iv.contentMode = .ScaleAspectFit
        iv.frame = self.cameraView!.bounds
        self.cameraView!.addSubview(iv)
    }
    
    func clearAll() {
        if self.childViewControllers.count > 0 {
            let av = self.childViewControllers[0] as! AVPlayerViewController
            av.willMoveToParentViewController(nil)
            av.view.removeFromSuperview()
            av.removeFromParentViewController()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func determineStatus() -> Bool {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: nil)
            return false
        case .Restricted:
            return false
        case .Denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Wouldn't you like to authorize this app " +
                "to use the camera?",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(
                title: "No", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(
                title: "OK", style: .Default, handler: {
                    _ in
                    let url = NSURL(string:UIApplicationOpenSettingsURLString)!
                    UIApplication.sharedApplication().openURL(url)
            }))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    func upload(image:UIImage){
        
        var imageData:NSData = UIImageJPEGRepresentation(image, 0.1)
        var uploadUrl = "http://ultimedia.biz/museumtracker/cms/services/webservices/services/uploadfile.php"
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0), { () -> Void in
            SRWebClient.POST(uploadUrl)
                .data(imageData, fieldName:"userfile", data:["days":"1","title":"Swift-SRWebClient","caption":"Uploaded via Swift-SRWebClient (https://github.com/sraj/Swift-SRWebClient)"])
                .send({(response:AnyObject!, status:Int) -> Void in
                    //process success response
                    
                    
                    
                    println(self.socialModel);
                    println(response);
                    self.dataServices.postSocialData(self.socialModel!, dataObject: response! as! String);

                    
                    },failure:{(error:NSError!) -> Void in
                        //process failure response
                })
            
        })
        
        
        
             
    }
}
