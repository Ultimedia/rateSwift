//
//  ExhibitFeedbackScreenViewController.swift
//  Rate
//
//  Created by Maarten Bressinck on 28/11/14.
//  Copyright (c) 2014 Maarten Bressinck. All rights reserved.
//

import UIKit

class ExhibitFeedbackScreenViewController: UIViewController, FloatRatingViewDelegate {

    // UI elements
    var exhibitModel:ExhibitModel?
    var overviewTitleLabel:UILabel?
    var descriptionLabel: UILabel?
    var feedbackSlider:UISlider?
    
    var ratingSegmentedControl: UISegmentedControl!
    var floatRatingView: FloatRatingView!
    var liveLabel: UILabel!
    var updatedLabel: UILabel!
    var scoreLabel:UILabel!
    var inputText:UITextView?
    var submitButton:UIButton?

    // screen size
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let applicationModel = ApplicationData.sharedModel()
    let dataServices = DataManager.dataManager()
    
    // Singleton Models
    let deviceFunctionService = DeviceFunctionServices.deviceFunctionServices()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createUI(){
    
        view.backgroundColor = UIColor.whiteColor()
        
        floatRatingView = FloatRatingView();
        self.floatRatingView.frame = CGRect(x: 75, y: 116, width: screenSize.width - 150, height: 40);
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.delegate = self
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false

        
        scoreLabel = UILabel()
        scoreLabel.text = "";
        scoreLabel.frame = CGRect(x: 0, y: floatRatingView.frame.origin.y + 50, width: screenSize.width, height: 40)
        scoreLabel.textAlignment = NSTextAlignment.Center
        scoreLabel.font = UIFont(name: "Avenir-Book", size: 14)
    
        
        // subtitle
        overviewTitleLabel = UILabel(frame: CGRect(x:0, y: 40, width: screenSize.width, height: 30))
        overviewTitleLabel!.numberOfLines = 1
        overviewTitleLabel!.lineBreakMode = .ByWordWrapping
        overviewTitleLabel!.text = "Einde"
        overviewTitleLabel!.font = UIFont (name: "Avenir-Book", size: 35)
        overviewTitleLabel!.textColor = UIColor.blackColor()
        overviewTitleLabel!.textAlignment = NSTextAlignment.Center
        
    
        // description
        descriptionLabel = UILabel(frame: CGRect(x: 20, y: overviewTitleLabel!.frame.origin.y + overviewTitleLabel!.frame.height + 15, width: screenSize.width - 40, height: 20))
        descriptionLabel!.numberOfLines = 1
        descriptionLabel!.lineBreakMode = .ByWordWrapping
        descriptionLabel!.text = "Wat vond je van deze tentoonstelling?"
        descriptionLabel!.font = UIFont (name: "Avenir-Book", size: 18)
        descriptionLabel!.textColor = UIColor.blackColor()
        descriptionLabel!.textAlignment = NSTextAlignment.Center
        
        // ipad layout update
        if(deviceFunctionService.deviceType == "ipad"){
            descriptionLabel?.frame = CGRect(x: (screenSize.width/2)-200, y: 40, width: 400, height: 300)
        }
        
        inputText = UITextView(frame: CGRect(x: 40, y: scoreLabel.frame.origin.y + 50, width: screenSize.width - 80, height: 140));
        inputText?.backgroundColor = UIColor.whiteColor()
        inputText?.layer.borderWidth = 1.0;
        inputText?.layer.borderColor = UIColor.grayColor().CGColor
        inputText?.font =  UIFont (name: "DINAlternate-Bold", size: 18)
        
        
        submitButton = UIButton();
        submitButton!.frame = CGRect(x: 40, y: inputText!.frame.origin.y + inputText!.frame.height + 10, width: screenSize.width - 80, height: 50)
        submitButton!.backgroundColor = applicationModel.UIColorFromRGB(0x21cdaf);
        submitButton!.addTarget(self, action: "submitData:", forControlEvents: .TouchUpInside)
        submitButton!.setTitleColor(applicationModel.UIColorFromRGB(0x222325), forState: .Normal)
        submitButton!.setTitle("Verstuur", forState: .Normal)
        
        view.addSubview(overviewTitleLabel!)
        view.addSubview(descriptionLabel!)
        view.addSubview(floatRatingView!)
        view.addSubview(scoreLabel!)
        view.addSubview(inputText!)
        view.addSubview(submitButton!)

    }
    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(ratingView: FloatRatingView, isUpdating rating:Float) {
        self.scoreLabel.text = NSString(format: "%.2f", self.floatRatingView.rating * 2) as String + " /10";
    }
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        self.scoreLabel.text = NSString(format: "%.2f", self.floatRatingView.rating * 2) as String + " /10";
    }
    
    func submitData(sender: UIButton!) {
        

        // get text
        inputText!.resignFirstResponder()
        
        var feedbackModel:FeedbackModel = FeedbackModel(feedback_score: NSString(format: "%.2f", self.floatRatingView.rating * 2) as String, feedback_text: inputText?.text, exhibit_id: applicationModel.selectedExhibit?.exhibit_id, user_id: "0")
        
        dataServices.postFeedback(feedbackModel);
        
        createOverlay();
    }
    
    
    func createOverlay(){
        
        NSNotificationCenter.defaultCenter().postNotificationName("CloseExhibit", object: nil, userInfo:  nil)

        

    }

}
