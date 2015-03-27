//
//  TeaserSubViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 21/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class TeaserSubViewController: UIViewController {


    var museumMapView: MKMapView?
    //var collectionView: UICollectionView?
    var filterBarDe: UIView?

    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let applicationModel = ApplicationData.sharedModel()

    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = applicationModel.UIColorFromRGB(0xeaeaea)
        
        createUI()
    }
    
    
    func createUI(){
        
        
        /*
        // add collectin
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 25, bottom: 20, right: 25)
        layout.itemSize = CGSize(width: screenSize.width-50, height: 120)
        collectionView = UICollectionView(frame: CGRect(x: 0, y:screenSize.height/2, width: screenSize.width, height: screenSize.height/2), collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(TeaserCollectionCell.self, forCellWithReuseIdentifier: "TeaserCollectionCell")
        collectionView!.backgroundColor = applicationModel.UIColorFromRGB(0xeaeaea)
        self.view.addSubview(collectionView!)
        */
        // museumproperties
        /*
        museumMapView = MKMapView()
        museumMapView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        museumMapView?.showsUserLocation = true
        view.addSubview(museumMapView!)
        */
        
        // Annotations
        var annotations:[MKPointAnnotation] = []
        
        // Loop counter
        var counter:Int = 1

        // filter bar
        var filterBorderWidth = CGFloat(2.0)
        var filterBorder = CALayer()
        filterBorder.borderColor = applicationModel.UIColorFromRGB(0xcbccc6).CGColor
        filterBorder.borderWidth = filterBorderWidth
        
        /*filterBarDe = UIView(frame: CGRect(x: 0, y: museumMapView!.frame.origin.y + museumMapView!.frame.height - 70, width: screenSize.width, height: 70))*/

        if let theSquareView = filterBarDe{
            
            filterBorder.frame = CGRect(x: 0, y: filterBarDe!.frame.size.height + filterBorderWidth - 72, width:  filterBarDe!.frame.size.width, height: filterBarDe!.frame.size.height)

            theSquareView.backgroundColor =  applicationModel.UIColorFromRGB(0xf2f2f0)
            theSquareView.layer.addSublayer(filterBorder)
            theSquareView.layer.masksToBounds = true
            
            view.addSubview(theSquareView)
        }
        
        
        


        // ipad layout update
        if(deviceFunctionService.deviceType == "ipad"){

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    */
   /* func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return applicationModel.museumData.count
    }*/

   // func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        /*let museum:MuseumModel = applicationModel.museumData[indexPath.item]

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TeaserCollectionCell", forIndexPath: indexPath) as TeaserCollectionCell
        cell.backgroundColor = UIColor.whiteColor()
        
        let url = NSURL(string: ( museum.museum_cover))
        if((url) != nil && url != ""){
            var thumbImageHolder = UIImageView(frame: CGRect(x: 10, y: 10, width: cell.frame.height - 20, height: cell.frame.height - 20 ))
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            if(data?.length != nil){
                thumbImageHolder.image = UIImage(data: data!)
                thumbImageHolder.contentMode = UIViewContentMode.ScaleToFill
            }else{
                thumbImageHolder.backgroundColor = UIColor.grayColor()
            }
            cell.addSubview(thumbImageHolder)
        }
            
        var subtitleLabel = UILabel(frame: CGRect(x: 130, y: 20, width: screenSize.width-20, height: 30))
            subtitleLabel.numberOfLines = 1
            subtitleLabel.lineBreakMode = .ByWordWrapping
            subtitleLabel.text = museum.museum_title
            subtitleLabel.font =  UIFont (name: "HelveticaNeue-Medium", size: 30)
            subtitleLabel.textColor = UIColor.blackColor()
            subtitleLabel.textAlignment = NSTextAlignment.Left
            cell.addSubview(subtitleLabel)
            
            
        var descriptionLabel = UILabel(frame: CGRect(x: 130, y: 40, width: screenSize.width-20, height: 60))
            descriptionLabel.numberOfLines = 2
            descriptionLabel.lineBreakMode = .ByWordWrapping
            descriptionLabel.text = museum.museum_description
            descriptionLabel.font =  UIFont (name: "HelveticaNeue-Light", size: 17)
            descriptionLabel.textColor = applicationModel.UIColorFromRGB(0x838383)
            descriptionLabel.textAlignment = NSTextAlignment.Left
            cell.addSubview(descriptionLabel)
    
            
        // open?
        var openView:UIView = UIView(frame: CGRect(x: cell.frame.width-200, y: 0, width: 100, height: 50))
            openView.backgroundColor = UIColor.whiteColor()
            cell.addSubview(openView)
            
        var openText = UILabel(frame: openView.bounds)
            openText.numberOfLines = 1
            openText.lineBreakMode = .ByWordWrapping
            openText.text = "Open"
            openText.font =  UIFont (name: "HelveticaNeue-Medium", size: 14)
            openText.textColor = UIColor.blackColor()
            openText.textAlignment = NSTextAlignment.Left
            openView.addSubview(openText)
            
            
        let twitterButtonImage = UIImage(named: "TweetIcon") as UIImage?
        var twitterButton = UIButton(frame: CGRect(x: cell.frame.width-200, y: 20, width: 100, height: 100))
            twitterButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            twitterButton.setTitle("", forState: UIControlState.Normal)
            twitterButton.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            twitterButton.setImage(twitterButtonImage, forState: .Normal)
            twitterButton.backgroundColor = UIColor.redColor()
            cell.addSubview(twitterButton)
            
        
        var locationLabel:UILabel = UILabel(frame: CGRect(x: 20, y: 30, width: screenSize.width-20, height: 30))
           // locationLabel.text = museum.museum_description

        return cell
            */
    }//
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


