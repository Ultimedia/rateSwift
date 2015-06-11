//
//  MuseumOverviewViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 18/03/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class MuseumOverviewViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var imageCache = NSMutableDictionary()
    
    
    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var coverImage:UIImage?
    var coverImageView: UIImageView?
    
    var logoLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    var exhibitThumbs = Array<TeaserThumbViewController>()
    var eventData = Dictionary<String, String>()
    
    var infoView:UIView?
    var infoViewTranspa:UIView?
    var readButton:UIButton?
    
    var cells = Array<UICollectionViewCell>()
    let locationServices = LocationSevices.locationServices()

    var beaconPanel:UIView?
    var beaconPanelOpen:Bool = false
    var beaconPanelAdded:Bool = false
    var beaconText:UILabel?
    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
    var collectionView: UICollectionView?
    var scrollView:UIScrollView?

    // Location Services
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xddded6)
        
        self.coverImageView =  UIImageView(frame: CGRect(x: 0, y: 64, width: self.screenSize.width, height: 400))
        self.coverImageView!.backgroundColor = UIColor.blackColor()

        logoLabel = UILabel(frame: CGRect(x: 20, y: 140, width: 110, height: 30))
        logoLabel!.text = applicationModel.selectedMuseum?.museum_description
        logoLabel!.text = "MUSEUM"
        logoLabel!.font = UIFont.boldSystemFontOfSize(33)
        logoLabel!.textColor = UIColor.blackColor()
        logoLabel!.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        logoLabel!.backgroundColor = applicationModel.UIColorFromRGB(0xc6823a)
        logoLabel!.textAlignment = NSTextAlignment.Center
        
        
        subtitleLabel = UILabel(frame: CGRect(x: 20, y: logoLabel!.frame.origin.y + logoLabel!.frame.height + 20, width: screenSize.width - 40, height:40))
        subtitleLabel!.numberOfLines = 4
        subtitleLabel!.lineBreakMode = .ByWordWrapping
        subtitleLabel!.text = applicationModel.selectedMuseum?.museum_title
        subtitleLabel!.textColor = applicationModel.UIColorFromRGB(0xFFFFFF)
        subtitleLabel!.font =  UIFont (name: "Futura-Medium", size: 50)
        
        
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: subtitleLabel!.frame.height + subtitleLabel!.frame.origin.y + 20, width: screenSize.width / 2 + 60, height: 70))
        descriptionLabel!.numberOfLines = 0
        descriptionLabel!.text = "Netwerk / centrum voor hedendaagse kunst Houtkaai 15 9300 Aalst"
        descriptionLabel!.font = UIFont (name: "Futura-Medium", size: 24)
        descriptionLabel!.textColor = UIColor.whiteColor()
        
        
        // infobox
        infoView = UIView()
        infoView!.frame = CGRect(x: 0, y: 470, width: screenSize.width, height: 120)
        infoView!.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        infoView!.alpha = 1
        
        infoViewTranspa = UIView()
        infoViewTranspa!.frame = CGRect(x: 0, y: 68, width: screenSize.width, height: 400)
        infoViewTranspa!.backgroundColor = applicationModel.UIColorFromRGB(0x5225d3)
        infoViewTranspa!.alpha = 0.4
        
        
        readButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
        readButton!.titleLabel?.font =  UIFont(name: "Futura-Medium", size: 20)
        readButton!.setTitle("Tickets & Info", forState: UIControlState.Normal)
        readButton!.addTarget(self, action: "readMore:", forControlEvents: UIControlEvents.TouchUpInside)
        readButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        readButton!.backgroundColor = UIColor.whiteColor()
        readButton!.frame = CGRectMake((screenSize.width / 2) - (190 / 2), infoView!.frame.origin.y + 25, 190, 70)
        readButton!.layer.borderColor = UIColor.whiteColor().CGColor
        readButton!.layer.borderWidth = 2
        readButton!.backgroundColor = UIColor.clearColor()
        
        
        var infoNumber:UILabel = UILabel(frame: CGRect(x: 80, y: 20, width: 100, height: 100))
        infoNumber.frame = CGRect(x: 20, y: 10, width: 100, height: 100)
        infoNumber.text = ""
        infoNumber.textAlignment = NSTextAlignment.Left
        infoNumber.numberOfLines = 1
        infoNumber.sizeToFit()
        infoNumber.font =  UIFont (name: "AvenirNext-Medium", size: 30)
        infoNumber.sizeToFit()
        infoNumber.textColor = UIColor.whiteColor()
        infoView!.addSubview(infoNumber)
        
        
        // The image isn't cached, download the img data
        // We should perform this in a background thread
        SwiftSpinner.show(applicationModel.selectedMuseum!.museum_title + " data ophalen")

        
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: applicationModel.selectedMuseum!.museum_cover)!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                let image = UIImage(data: data)

                dispatch_async(dispatch_get_main_queue(), {
                    // add cover image
                    
                    self.coverImageView!.image = image
                    self.coverImageView?.contentMode = .ScaleAspectFit
                    self.coverImageView?.contentMode = UIViewContentMode.ScaleToFill

                    self.view.addSubview(self.coverImageView!)
                    self.view.addSubview(self.infoViewTranspa!)
                    self.view.addSubview(self.infoView!)
                    self.view.addSubview(self.logoLabel!)
                    self.view.addSubview(self.subtitleLabel!)
                    self.view.addSubview(self.descriptionLabel!)
                    self.view.addSubview(self.readButton!)
                    
                    SwiftSpinner.hide()
                    
                    if(self.deviceFunctionService.deviceType != "ipad"){
                        
                        self.coverImageView!.frame = CGRect(x: 0, y: 64, width: self.screenSize.width, height: 230)
                        
                        self.infoView!.frame = CGRect(x: 0, y: 64, width: self.screenSize.width, height: 230)
                        self.infoView!.alpha = 0.8
                        
                        self.infoViewTranspa!.frame = CGRect(x: 0, y: 200, width: self.screenSize.width, height: 100)
                        self.infoViewTranspa!.backgroundColor = self.applicationModel.UIColorFromRGB(0xe9eae2)
                        self.infoViewTranspa!.alpha = 0
                        
                        self.readButton!.frame = CGRect(x: 20, y: self.infoViewTranspa!.frame.origin.y + 20, width: 145, height: 45)
 
                        self.logoLabel!.frame = CGRect(x: 20, y: 100, width: self.screenSize.width - 40, height: 30)
                        self.logoLabel!.textAlignment = NSTextAlignment.Center
                        self.logoLabel!.alpha = 0
                        
                        self.subtitleLabel!.frame = CGRect(x: 20, y: 78, width: self.screenSize.width - 40, height: 60)
                        
                        self.descriptionLabel!.frame =  CGRect(x: 20, y: self.subtitleLabel!.frame.origin.y + 58, width: self.screenSize.width - 40, height: 70)
                        
                        self.descriptionLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping
                        self.descriptionLabel!.font = UIFont (name: "Futura-Medium", size: 18)
                    }
                })
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
        
        
        var xPos:Int = 0
        var gap:Int = 20
        var counter:Int = 0
        
        // exhibit thumbs
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconsDetected:", name:"BeaconsDetected", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconStatus:", name:"BeaconStatus", object: nil)
        
        if(deviceFunctionService.deviceType == "ipad"){

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
                layout.itemSize = CGSize(width: (screenSize.width / 2) - 40, height: 240)
                layout.minimumInteritemSpacing = 5

            collectionView = UICollectionView(frame: CGRect(x: 10, y: 65 + 400 + 120, width: screenSize.width - 20, height: (screenSize.height) - 65 - 400 - 120), collectionViewLayout: layout)
            collectionView!.dataSource = self
            collectionView!.delegate = self
            collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
            collectionView!.backgroundColor = applicationModel.UIColorFromRGB(0xddded6)
            self.view.addSubview(collectionView!)
            
        }else{


            scrollView = UIScrollView()
            scrollView?.frame = CGRect(x: 0, y: 280, width: screenSize.width, height: screenSize.height - 280)
            scrollView?.contentSize = CGSize(width: screenSize.width, height: CGFloat(applicationModel.selectedMuseum!.exhibitData.count) * (240 + 30))
            scrollView?.backgroundColor = applicationModel.UIColorFromRGB(0xddded6)
            self.view.addSubview(scrollView!)
            
            var yPos:Int = 10
            var counter:Int = 0
            
            // add thumbs
            for exhit in applicationModel.selectedMuseum!.exhibitData{
                
                
                var exView:UIViewController = UIViewController()
                    exView.view.frame = CGRect(x: 10, y: yPos, width: Int(screenSize.width - 20), height: 240)
                
                var imageCaption:UIView = UIView()
                    imageCaption.backgroundColor = UIColor.blackColor()
                    imageCaption.frame = CGRect(x: 0, y: 130, width: screenSize.width - 20, height: 110)
                    imageCaption.alpha = 0.8
                
                
                var exhLabel:UILabel = UILabel()
                    exhLabel.text = exhit.exhibit_title
                    exhLabel.textColor = UIColor.whiteColor()
                    exhLabel.frame = CGRect(x: 10, y: 125, width: screenSize.width - 40, height: 70)
                    exhLabel.numberOfLines = 2
                
                
                var exhTag:UILabel = UILabel()
                exhTag.text = "Bezoek nu!"
                exhTag.textColor = UIColor.whiteColor()
                exhTag.backgroundColor = applicationModel.UIColorFromRGB(0x242424)
                exhTag.frame = CGRect(x: 10, y: 210, width: 90, height: 24)
                exhTag.numberOfLines = 0
                exhTag.textColor = applicationModel.UIColorFromRGB(0x242424)
                exhTag.font =  UIFont (name: "DINAlternate-Bold", size: 16)
                exhTag.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
                exhTag.textAlignment = NSTextAlignment.Center

                
                var exhHours:UILabel = UILabel()
                exhHours.text = exhit.exhibit_opening_hours
                exhHours.textColor = UIColor.whiteColor()
                exhHours.frame = CGRect(x: 10, y: 180, width: screenSize.width - 40, height: 40)
                exhHours.numberOfLines = 0
                exhHours.font =  UIFont (name: "HelveticaNeue-Light", size: 14)
                exhHours.backgroundColor = UIColor.clearColor()
                exhHours.sizeToFit()
                
                
                var image:UIImage?
                var imageView: UIImageView
                
                image = UIImage(named:"cover")
                imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: screenSize.width - 20, height: 240))
                imageView.contentMode = UIViewContentMode.ScaleToFill
                imageView.backgroundColor = UIColor.whiteColor()
                
                if(exhit.exhibit_cover_image != ""){
                
                    var requestURL = NSURL(string: applicationModel.imagePath + exhit.exhibit_cover_image)
                    var request: NSURLRequest = NSURLRequest(URL: requestURL!)
                    
                    let mainQueue = NSOperationQueue.mainQueue()
                    NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                        if error == nil {
                                                
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            // add cover image
                            imageView.image = UIImage(data: data!)

                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
                    
                }
                
                var viewBTN:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: Int(screenSize.width - 20), height: 240))
                    viewBTN.backgroundColor = UIColor.clearColor()
                    viewBTN.addTarget(self, action: "openMuseum:", forControlEvents: UIControlEvents.TouchUpInside)
                    viewBTN.tag = counter
                
                
                exView.view.addSubview(imageView)
                exView.view.addSubview(imageCaption)
                exView.view.addSubview(exhLabel)
                exView.view.addSubview(exhTag)
                exView.view.addSubview(exhHours)
                exView.view.addSubview(viewBTN)
                exView.view.backgroundColor = UIColor.whiteColor()
                
                counter++
                yPos = yPos + 240 + 20
                
                scrollView?.addSubview(exView.view)
                
            }

        }
    }
    
    func openMuseum(sender:UIButton){
        applicationModel.selectedExhibit = applicationModel.selectedMuseum!.exhibitData[sender.tag]
        applicationModel.selectedExhibitIndex = sender.tag
        eventData["menu"] = "exhibit"
        
        SwiftSpinner.show(applicationModel.selectedExhibit!.exhibit_title + " data ophalen")
    NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
    }
    
    func readMore(send:UIButton){
        
        UIApplication.sharedApplication().openURL(NSURL(string: applicationModel.selectedMuseum!.museum_website)!)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicationModel.selectedMuseum!.exhibitData.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
            cell.backgroundColor = UIColor.clearColor()
            cell.tag = applicationModel.selectedMuseum!.exhibitData[indexPath.item].exhibit_id.toInt()!
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        var imageCaption:UIView = UIView()
            imageCaption.backgroundColor = UIColor.blackColor()
            imageCaption.frame = CGRect(x: 10, y: 150, width: cell.frame.width - 20, height: 110)
            imageCaption.alpha = 0.8
    
        
        var exhLabel:UILabel = UILabel()
            exhLabel.text = applicationModel.selectedMuseum!.exhibitData[indexPath.item].exhibit_title
            exhLabel.textColor = UIColor.whiteColor()
            exhLabel.frame = CGRect(x: 20, y: 145, width: cell.frame.width - 40, height: 70)
            exhLabel.numberOfLines = 2
        

        var exhTag:UILabel = UILabel()
            exhTag.text = "Bezoek nu!"
            exhTag.textColor = UIColor.whiteColor()
            exhTag.backgroundColor = applicationModel.UIColorFromRGB(0x242424)
            exhTag.frame = CGRect(x: 20, y: 230, width: 90, height: 24)
            exhTag.numberOfLines = 0
            exhTag.textColor = applicationModel.UIColorFromRGB(0x242424)
            exhTag.font =  UIFont (name: "DINAlternate-Bold", size: 16)
            exhTag.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            exhTag.textAlignment = NSTextAlignment.Center
        
        var exhHours:UILabel = UILabel()
            exhHours.text = applicationModel.selectedMuseum!.exhibitData[indexPath.item].exhibit_title
            exhHours.textColor = UIColor.whiteColor()
            exhHours.frame = CGRect(x: 20, y: 200, width: cell.frame.width - 40, height: 40)
            exhHours.numberOfLines = 0
            exhHours.font =  UIFont (name: "HelveticaNeue-Light", size: 14)
            exhHours.backgroundColor = UIColor.clearColor()
            exhHours.sizeToFit()
        
    
        var image:UIImage?
        var imageView: UIImageView
            
            image = UIImage(named:"cover")
            imageView =  UIImageView(frame: CGRect(x: 10, y: 20, width: cell.frame.width - 20, height: 240))
            imageView.contentMode = UIViewContentMode.ScaleToFill
            imageView.image = image


            let url = NSURL(string: (applicationModel.selectedMuseum!.exhibitData[indexPath.item].exhibit_cover_image))
            if((url) != nil && url != ""){
                let data = NSData(contentsOfURL: url!)
                if((data?.length) != nil){
                    imageView.image = UIImage(data: data!)
                }
            }

            cell.addSubview(imageView)
            cell.addSubview(imageCaption)
            cell.addSubview(exhLabel)
            cell.addSubview(exhTag)
            cell.addSubview(exhHours)
    
            cells.append(cell)

        return cell
    }
    
    // touch
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        applicationModel.selectedExhibit = applicationModel.selectedMuseum?.exhibitData[indexPath.item]
        applicationModel.collectionViewIndex = indexPath.item;
        
        eventData["menu"] = "exhibit"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)
    }
    
    
    func beaconStatus(ns:NSNotification){
        
        if(beaconPanelAdded != true){
            beaconPanel = UIView()
            beaconPanel?.alpha = 0.7
            beaconPanel?.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: 60)
            beaconPanel?.backgroundColor = UIColor.whiteColor()
            
            view.addSubview(beaconPanel!)
            beaconPanelAdded = true
            
            beaconText = UILabel()
            beaconText?.frame = CGRect(x: 0, y: 10, width: screenSize.width, height: 30)
            
            if(locationServices.closestBeacon != nil){
            
                beaconText?.text = "beacon ID" + String(stringInterpolationSegment: locationServices.closestBeacon!.minor)
        
            }
            
        
            beaconText?.textAlignment = NSTextAlignment.Center
            beaconText?.textColor = UIColor.blackColor()
            beaconPanel?.addSubview(beaconText!)
        }
        
        if(beaconPanelOpen == false){
            
            UIView.animateWithDuration(0.4, delay: 0, options: nil, animations: {
                self.beaconPanel?.frame = CGRect(x: 0, y: self.screenSize.height - 60, width: self.screenSize.width, height: 60)

                
                return
                }, completion: { finished in
                    self.beaconPanelOpen = true
            })
            
        }else{
            
            UIView.animateWithDuration(0.4, delay: 0.2, options: nil, animations: {
                self.beaconPanel?.frame = CGRect(x: 0, y: self.screenSize.height, width: self.screenSize.width, height: 60)

                
                
                return
                }, completion: { finished in
                    self.beaconPanelOpen = false
            })
        }
        
    }
    
    /**
    * Beacons detected
    */
    func beaconsDetected(ns: NSNotification){
        
        if(beaconPanelAdded != true){
            beaconText?.text = "beacon ID" + String(stringInterpolationSegment: locationServices.closestBeacon!.minor)
        }
        
        // map the beacon to the exhibit
        var myExhibit = applicationModel.nearestExhibit?.exhibit_id
        
    
        // add beacon
        for cell in cells{
            // find the active exhibit (so corresponding to the nearest beacon)
           
            
            if(cell.tag == myExhibit?.toInt()){

                var beaconIndicator:UILabel = UILabel()
                beaconIndicator.text = "Beacons gevonden"
                beaconIndicator.textColor = UIColor.whiteColor()
                beaconIndicator.frame = CGRect(x: 120, y: 230, width: 140, height: 24)
                beaconIndicator.numberOfLines = 0
                beaconIndicator.textColor = applicationModel.UIColorFromRGB(0x242424)
                beaconIndicator.font =  UIFont (name: "DINAlternate-Bold", size: 16)
                beaconIndicator.backgroundColor = applicationModel.UIColorFromRGB(0xc6823a)
                beaconIndicator.textAlignment = NSTextAlignment.Center
                cell.addSubview(beaconIndicator)
                
            }
            
        }
        
        
        
        /*for item in self.exhibitThumbs {
        if(item.exhibitModel!.exhibit_id == exh.exhibit_id){
        item.active = true
        item.view.hidden = true
        }else{
        item.view.alpha = 0
        }
        }*/
        
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
