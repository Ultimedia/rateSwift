//
//  CameraInputViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 9/12/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import MobileCoreServices

class CameraInputViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var pictureButton: UIView!
    @IBOutlet weak var fotoFrameButton: UIImageView!
    
    var beenHereBefore = false
    var controller: UIImagePickerController?
    
    
    var cameraUI: UIImagePickerController! = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // take a picture
    @IBAction func takePictureButton(sender: AnyObject) {
        self.presentCamera()
    }
    
    
    func presentCamera()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            
            cameraUI = UIImagePickerController()
            cameraUI.delegate = self
            cameraUI.sourceType = UIImagePickerControllerSourceType.Camera;
            cameraUI.mediaTypes = [kUTTypeImage]
            cameraUI.allowsEditing = false
            
            self.presentViewController(cameraUI, animated: true, completion: nil)
        }
        else
        {
            // error msg
        }
    }
    
    
    func imagePickerControllerDidCancel(picker:UIImagePickerController)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /*
    func imagePickerController(picker:UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary)
    {
        if(picker.sourceType == UIImagePickerControllerSourceType.Camera)
        {
            // Access the uncropped image from info dictionary
            var imageToSave: UIImage = info.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
            var imageToSave1: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage //same but with different way
            
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            
            // preview image
            fotoFrameButton.image = imageToSave
            
            
            self.savedImageAlert()
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }*/
    
    
    
    
    func savedImageAlert()
    {
        var alert:UIAlertView = UIAlertView()
        alert.title = "Saved!"
        alert.message = "Your picture was saved to Camera Roll"
        alert.delegate = self
        alert.addButtonWithTitle("Ok")
        alert.show()
    }
}
