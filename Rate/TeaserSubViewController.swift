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

    @IBOutlet weak var museumMapView: MKMapView!
    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()
    let applicationModel = ApplicationData.sharedModel()

    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.whiteColor()
        
        createUI()
    }
    
    
    func createUI(){
        
        var counter = 1
        
        // lets add museums (museum overview table)
        for museum in applicationModel.museumData{
            
            var musuemT:TeaserMuseumTileController = TeaserMuseumTileController(nibName: "TeaserMuseumTileController", bundle: nil)
                musuemT.myMuseum = museum
            
                musuemT.view.frame = CGRect(x: 0, y:90,width: screenSize.width, height: 90)
            
            
            view.addSubview(musuemT.view)
            self.addChildViewController(musuemT)
            counter++
        }
        
        
        // ipad layout update
        if(deviceFunctionService.deviceType == "ipad"){
            museumMapView.frame = CGRect(x: 0, y: screenSize.height-(screenSize.height/2), width: screenSize.width, height: screenSize.height/2)
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
