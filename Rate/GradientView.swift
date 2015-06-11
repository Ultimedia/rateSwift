//
//  GradientView.swift
//  Rate
//
//  Created by Maarten Bressinck on 6/01/15.
//  Copyright (c) 2015 Maarten Bressinck. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override func drawRect(rect: CGRect) {
        // 1
        var currentContext = UIGraphicsGetCurrentContext()
        
        // 2
        CGContextSaveGState(currentContext);
        
        // 3
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // 4
        var startColor = UIColor.blackColor();
        var startColorComponents = CGColorGetComponents(startColor.CGColor)
        var endColor = UIColor.clearColor();
        var endColorComponents = CGColorGetComponents(endColor.CGColor)
        
        // 5
        var colorComponents
        = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
        
        // 6
        var locations:[CGFloat] = [0.0, 1.0]
        
        // 7
        var gradient = CGGradientCreateWithColorComponents(colorSpace,&colorComponents,&locations,2)
        
        var startPoint = CGPointMake(0, self.bounds.height)
        var endPoint = CGPointMake(self.bounds.width, self.bounds.height)
        
        // 8
        CGContextDrawLinearGradient(currentContext,gradient,startPoint,endPoint, 0)
        
        // 9
        CGContextRestoreGState(currentContext);
    
    
    }

}
