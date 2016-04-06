
//  UIImageExtension.swift
//  LegofySwift
//
//  Created by Stefan Lage on 11/01/16.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import Foundation

private extension UIImage {
    private func createARGBBitmapContext(inImage: CGImageRef) -> CGContext {
        //Get image size
        let pixelsWide        = CGImageGetWidth(inImage)
        let pixelsHigh        = CGImageGetHeight(inImage)
        // Bytes per row
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        // Use the generic RGB color space
        let colorSpace        = CGColorSpaceCreateDeviceRGB()
        // Allocate memory for image data
        let bitmapData        = UnsafeMutablePointer<UInt8>()
        let bitmapInfo        = CGImageAlphaInfo.PremultipliedFirst.rawValue
        // Create the bitmap context
        let context           = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo)
        return context!
    }
}

extension  UIImage {
    /**
     Make a monochrome UIImage
     
     - parameter size:  image size
     - parameter color: image background color
     
     - returns: new monochrome image
     */
    internal class func initBlank(size: CGSize, color: UIColor) -> UIImage{
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        // set backgroung
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    /**
     Generate a thumnail of the current image
     Resize the image to a given size
     
     - parameter size: the size we'd like the image got
     
     - returns: the resized image
     */
    internal func thumbnail(size: CGSize) -> UIImage{
        UIGraphicsBeginImageContext(size);
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage
    }

    /**
     Convert an image to it's bitmap 8bits (ARGB bitmap)
     
     - returns: bitmap
     */
    internal func convertToARGBBitmap() -> UnsafeMutablePointer<UInt8>{

        let imageRef: CGImageRef                  = self.CGImage!

        // Create context to draw UIImage into
        let context                               = self.createARGBBitmapContext(imageRef)

        let width                                 = CGImageGetWidth(imageRef)
        let height                                = CGImageGetHeight(imageRef)

        let rect                                  = CGRectMake(0, 0, CGFloat(width), CGFloat(height))
        CGContextDrawImage(context, rect, imageRef)

        let data                                  = CGBitmapContextGetData(context)
        let bitmapData                            = UnsafeMutablePointer<UInt8>(data)

        let bytesPerRow                           = CGBitmapContextGetBytesPerRow(context)
        let bufferLength                          = bytesPerRow * height

        var newBitmap:UnsafeMutablePointer<UInt8> = nil
        if(bitmapData != nil){
            newBitmap = UnsafeMutablePointer<UInt8>.alloc(bytesPerRow * height)
            if(newBitmap != nil){
                for var i = 0; i < bufferLength; ++i {
                    newBitmap[i] = bitmapData[i]
                }
            }
        }
        else{
            print("Error getting bitmap pixel data")
        }
        return newBitmap
    }
}