//
//  MuseumOverviewViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 18/03/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class MuseumOverviewViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    var coverImage:UIImage?
    var coverImageView: UIImageView?
    
    var logoLabel: UILabel?
    var subtitleLabel: UILabel?
    var descriptionLabel: UILabel?
    
    var exhibitThumbs = Array<TeaserThumbViewController>()
    var eventData = Dictionary<String, String>()

    
    // applicationModel
    let applicationModel = ApplicationData.sharedModel()
    
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
    var collectionView: UICollectionView?


    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        println("museum id")
        println(applicationModel.selectedMuseum?.museum_id)

        
        // add cover image
        coverImage = UIImage(named:"cover")
        coverImageView =  UIImageView(frame: CGRect(x: 0, y: 70, width: screenSize.width, height: 260))
        coverImageView!.image = coverImage
        coverImageView!.center = view.center
        
        let url = NSURL(string: ( applicationModel.selectedMuseum!.museum_cover))
        if((url) != nil && url != ""){
            let data = NSData(contentsOfURL: url!)
            if((data?.length) != nil){
                coverImageView?.image = UIImage(data: data!)
                coverImageView?.contentMode = .ScaleAspectFit
                coverImageView?.frame = CGRect(x: 0, y: 64, width: screenSize.width, height: 200)
                coverImageView?.contentMode = UIViewContentMode.ScaleToFill
            }
        }
        
        //scrollView.addSubview(subtitleLabel!)


        
        logoLabel = UILabel(frame: CGRect(x: 20, y: 160, width: 80, height: 60))
        logoLabel!.text = applicationModel.selectedMuseum?.museum_description
        logoLabel!.font = UIFont.boldSystemFontOfSize(22)
        logoLabel!.textColor = UIColor.whiteColor()
        logoLabel!.font =  UIFont (name: "AvenirNext-Medium", size: 18)
        logoLabel!.sizeToFit()
        
        
        subtitleLabel = UILabel(frame: CGRect(x: 20, y: 60, width: screenSize.width - 40, height: 100))
        subtitleLabel!.numberOfLines = 4
        subtitleLabel!.lineBreakMode = .ByWordWrapping
        subtitleLabel!.text = applicationModel.selectedMuseum?.museum_title
        subtitleLabel!.textColor = UIColor.whiteColor()
        subtitleLabel!.font =  UIFont (name: "AvenirNext-Medium", size: 36)
        
        
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: 240, width: screenSize.width - 40, height: 100))
        descriptionLabel!.numberOfLines = 3
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = applicationModel.selectedMuseum?.museum_description
        descriptionLabel!.font = UIFont (name: "HelveticaNeue-Light", size: 16)
        descriptionLabel!.textColor = UIColor()
        
        view.addSubview(coverImageView!)
        view.addSubview(logoLabel!)
        view.addSubview(subtitleLabel!)
        //scrollView!.addSubview(descriptionLabel!)
    
        
        var xPos:Int = 0
        var gap:Int = 20
        var counter:Int = 0
        
        // exhibit thumbs
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "beaconsDetected:", name:"BeaconsDetected", object: nil)

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
        layout.itemSize = CGSize(width: screenSize.width, height: 240)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 260, width: screenSize.width, height: screenSize.height - 260), collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicationModel.selectedMuseum!.exhibitData.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        var imageCaption:UIView = UIView()
            imageCaption.backgroundColor = UIColor.blackColor()
            imageCaption.frame = CGRect(x: 10, y: 130, width: cell.frame.width - 20, height: 110)
            imageCaption.alpha = 0.8
    
        var exhLabel:UILabel = UILabel()
            exhLabel.text = applicationModel.selectedMuseum!.exhibitData[indexPath.item].exhibit_title
            exhLabel.textColor = UIColor.whiteColor()
            exhLabel.frame = CGRect(x: 20, y: 125, width: cell.frame.width - 40, height: 70)
            exhLabel.numberOfLines = 2
        
        var exhTag:UILabel = UILabel()
            exhTag.text = "Bezoek nu!"
            exhTag.textColor = UIColor.whiteColor()
            exhTag.backgroundColor = applicationModel.UIColorFromRGB(0x242424)
            exhTag.frame = CGRect(x: 20, y: 210, width: cell.frame.width - 40, height: 40)
            exhTag.numberOfLines = 0
            exhTag.textColor = applicationModel.UIColorFromRGB(0x242424)
            exhTag.font =  UIFont (name: "DINAlternate-Bold", size: 16)
            exhTag.backgroundColor = applicationModel.UIColorFromRGB(0x25d3b8)
            exhTag.sizeToFit()
        
        var exhHours:UILabel = UILabel()
            exhHours.text = "ZA 17.01 2015 - ZO 20.03 2015"
            exhHours.textColor = UIColor.whiteColor()
            exhHours.frame = CGRect(x: 20, y: 180, width: cell.frame.width - 40, height: 40)
            exhHours.numberOfLines = 0
            exhHours.font =  UIFont (name: "HelveticaNeue-Light", size: 14)
            exhHours.backgroundColor = UIColor.clearColor()
            exhHours.sizeToFit()
        
    
        var image:UIImage?
        var imageView: UIImageView
            
            image = UIImage(named:"cover")
            imageView =  UIImageView(frame: CGRect(x: 10, y: 0, width: cell.frame.width - 20, height: 240))
            imageView.contentMode = UIViewContentMode.ScaleToFill
            imageView.image = image


            let url = NSURL(string: (applicationModel.selectedMuseum!.exhibitData[indexPath.item].exhibit_cover_image))
            if((url) != nil && url != ""){
                let data = NSData(contentsOfURL: url!)
                if((data?.length) != nil){
                    imageView.image = UIImage(data: data!)

                   // newImgThumb.contentMode = .ScaleAspectFit
                }
            }

            cell.addSubview(imageView)
            cell.addSubview(imageCaption)
            cell.addSubview(exhLabel)
            cell.addSubview(exhTag)
            cell.addSubview(exhHours)


        return cell
    }
    
    // touch
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        
        applicationModel.selectedExhibit = applicationModel.selectedMuseum?.exhibitData[indexPath.item]
        
        eventData["menu"] = "exhibit"
        NSNotificationCenter.defaultCenter().postNotificationName("MenuChangedHandler", object: nil, userInfo:  eventData)

    }
    
    
    /**
    * Beacons detected
    */
    func beaconsDetected(ns: NSNotification){
        
        
        // map the beacon to the exhibit
        //var myExhibit = locationServices.lastBeacon?.mercury_exhibit_id
        
        for exh in applicationModel.activeExhibits{
            // find the active exhibit (so corresponding to the nearest beacon)
            for item in self.exhibitThumbs {
                if(item.exhibitModel!.exhibit_id == exh.exhibit_id){
                    item.active = true
                    item.view.alpha = 1
                }
            }
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
