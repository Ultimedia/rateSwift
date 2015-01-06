//
//  ExhibitOverviewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 28/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitOverviewController: UIViewController {

    var exhibitModel:ExhibitModel? = nil
    var overviewTitleLabel:UILabel?
    var descriptionLabel: UILabel?
    
    var pageIndex : Int = 0
    var titleText : String = ""
    var imageFile : String = ""
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let roomViewData = Array<OverviewTileViewController>()
    let applicationData = ApplicationData.sharedModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
    * Draw the user-interface
    */
    func createUI(){
        
        view.backgroundColor = UIColor.whiteColor()
        
        // subtitle
        overviewTitleLabel = UILabel(frame: CGRect(x:0, y: 80, width: screenSize.width, height: 100))
        overviewTitleLabel!.numberOfLines = 3
        overviewTitleLabel!.lineBreakMode = .ByWordWrapping
        overviewTitleLabel!.text = exhibitModel?.overviewTitle_Dutch
        overviewTitleLabel!.font =  UIFont (name: "HelveticaNeue-Light", size: 23)
        overviewTitleLabel!.textColor = UIColor.blackColor()
        overviewTitleLabel!.textAlignment = NSTextAlignment.Center
        
        
        // description
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width, height: screenSize.height - 200))
        descriptionLabel!.numberOfLines = 8
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = exhibitModel?.overviewInfo_Dutch
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.sizeToFit()
        descriptionLabel!.textAlignment = NSTextAlignment.Center
    
        // ipad layout update
        if(deviceFunctionService.deviceType == "ipad"){
            descriptionLabel?.frame = CGRect(x: (screenSize.width/2)-200, y: 40, width: 400, height: 300)
        }
        
        view.addSubview(overviewTitleLabel!)
        view.addSubview(descriptionLabel!)
    
        drawOverView()
    }
    
    /**
    * Draw overview grid
    */
    func drawOverView(){
        var myExhibit = applicationData.museumData[0].exhibitData[0].roomData
        var iconWidth:Int = 140
        var iconHeight:Int = 140
        var spacing:Int = 10
        var roomCount = myExhibit.count
        var numberOfRows:Int = roomCount
        var numberOfColumns:Int = 4
        var counter = 0
        
        
        var overviewFrame:UIView = UIView()
            overviewFrame.frame = CGRect(x: 50, y: 250, width: screenSize.width-100, height: 700)
            view.addSubview(overviewFrame)
    
        
        for var i = 0; i < numberOfRows; ++i {
            for var j = 0; j<numberOfColumns; j++ {
    
                if(counter < roomCount){
                    var t:UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
                    t.frame = CGRect(x: j*(iconWidth + spacing), y: (i*(iconWidth+spacing)+iconWidth)-140, width: iconWidth, height: iconHeight)
                    
                    if(myExhibit[counter].mercury_room_type == "intro"){
                        t.backgroundColor = UIColor.yellowColor()
                    }else{
                        t.backgroundColor = UIColor.redColor()
                    }
                    
                    overviewFrame.addSubview(t)
                    t.addTarget(self, action: "overviewAction:", forControlEvents: UIControlEvents.TouchUpInside)

                    var viewLabel:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: iconWidth, height: iconHeight))
                        viewLabel.text = myExhibit[counter].mercury_room_title
                        viewLabel.textAlignment = NSTextAlignment.Center
                    t.addSubview(viewLabel)

                }
                
                counter++
            }
        }
    }
    
    
    /**
    * Create the UI
    */
    func overviewAction(sender:UIButton!)
    {
        println("hello")
    }
    
}
