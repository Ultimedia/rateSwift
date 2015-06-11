//
//  UIImageExtension.swift
//  ImageMask
//
//  Created by Damien Laughton on 12/05/2015.
//  Copyright (c) 2015 Mobilology. All rights reserved.
//

import UIKit

public extension UIImage {
  
  func scale(newSize: CGSize) -> UIImage {
    
    UIGraphicsBeginImageContext(newSize)
    self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }
  
  func mask(maskImage: UIImage) -> UIImage? {
    var maskedImage: UIImage? = nil
    
    let maskRef = maskImage.CGImage as CGImageRef
    
    let mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
    CGImageGetHeight(maskRef),
    CGImageGetBitsPerComponent(maskRef),
    CGImageGetBitsPerPixel(maskRef),
    CGImageGetBytesPerRow(maskRef),
    CGImageGetDataProvider(maskRef), nil, false) as CGImageRef
    
    let maskedImageRef = CGImageCreateWithMask(self.CGImage, mask)
    
    maskedImage = UIImage(CGImage: maskedImageRef)
    
    return maskedImage
  }
  
}

