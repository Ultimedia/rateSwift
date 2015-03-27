//
//  MuseumListComponentViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 16/02/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class MuseumListComponentViewController: UIViewController {

    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    var musuemTitle:String?
    var myCount:Int?
    
    @IBOutlet weak var listCount: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var buttonTouch: UIButton!
    
    var distanceField: UILabel!
    var liner:UIImageView?
    var titleField:UILabel?
    var museumModel:MuseumModel?
    var activeDot:UIView?
    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.clearColor()
 
        
        titleLabel.text = musuemTitle
        liner = UIImageView(frame: CGRect(x: 0, y: view.frame.height-1, width: view.frame.width, height: 1))
        liner?.backgroundColor = UIColor.whiteColor()
        
        
        titleLabel.hidden = true
        distanceLabel.hidden = true
        
        titleField = UILabel()
        titleField!.frame = CGRect(x: 65, y: 23, width: screenSize.width, height: 50)
        titleField!.numberOfLines = 0
        titleField!.lineBreakMode = .ByWordWrapping
        titleField!.font =  UIFont (name: "AvenirNext-Medium", size: 34)
        titleField!.textColor = UIColor.whiteColor()
        titleField!.textAlignment = NSTextAlignment.Left
        titleField!.text = musuemTitle
        view.addSubview(titleField!)
        
        distanceField = UILabel()
        distanceField!.frame = CGRect(x: 10, y: 23, width: view.frame.width - 20, height: 50)
        distanceField!.numberOfLines = 0
        distanceField!.lineBreakMode = .ByWordWrapping
        distanceField!.font =  UIFont (name: "AvenirNext-UltraLight", size: 34)
        distanceField!.textColor = UIColor.whiteColor()
        distanceField!.textAlignment = NSTextAlignment.Right
        distanceField!.text = "100"
        view.addSubview(distanceField!)
        
        activeDot = UIView()
        activeDot!.frame = CGRect(x: screenSize.width - 20, y: 10, width: 12, height: 12)
        activeDot?.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
        activeDot?.hidden = true
        activeDot?.layer.cornerRadius = 10
        view.addSubview(activeDot!)
        
        // if mobile
        if(deviceFunctionService.deviceType == "ipad"){
            
        }else{
            
            view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 80 )
            
            distanceLabel.frame = CGRectMake( 100, 200, distanceLabel.frame.size.width, distanceLabel.frame.size.height ); // set new position exactly
            
            //line.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 10)
            
        }
        
        view.addSubview(liner!)
        
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
