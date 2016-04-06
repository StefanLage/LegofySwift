//
//  NSImageExtension.swift
//  LegofySwift
//
//  Created by Stefan Lage on 22/01/16.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import Foundation
import AppKit


private extension NSImage {
    private func createARGBBitmapContext(inImage: CGImageRef) -> CGContext {
        //Get image width, height
        let pixelsWide = CGImageGetWidth(inImage)
        let pixelsHigh = CGImageGetHeight(inImage)
        // Declare the number of bytes per row
        let bitmapBytesPerRow = Int(pixelsWide) * 4
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Allocate memory for image data
        let bitmapData = UnsafeMutablePointer<UInt8>()
        let bitmapInfo = CGImageAlphaInfo.PremultipliedFirst.rawValue
        // Create the bitmap context
        let context = CGBitmapContextCreate(bitmapData, pixelsWide, pixelsHigh, 8, bitmapBytesPerRow, colorSpace, bitmapInfo)
        return context!
    }
}

extension NSImage {
    /**
     Make a monochrome UIImage
     
     - parameter size:  image size
     - parameter color: image background color
     
     - returns: new monochrome image
     */
    internal class func initBlank(size: CGSize, color: NSColor) -> NSImage{
        let rect = NSMakeRect(0, 0, size.width, size.height)
        let image = NSImage(size: size);
        image.lockFocus()
        // set backgroung
        color.setFill()
        // Draw
        image.drawInRect(rect)
        image.unlockFocus()
        return image
    }
    
    /**
     Generate a thumnail of the current image
     Resize the image to a given size
     
     - parameter size: the size we'd like the image got
     
     - returns: the resized image
     */
    internal func thumbnail(size: CGSize) -> NSImage{
        let newImage = NSImage(size: size);
        newImage.lockFocus()
        self.size = size
        NSGraphicsContext.currentContext()?.imageInterpolation = NSImageInterpolation.High
        self.drawAtPoint(NSZeroPoint, fromRect: CGRectMake(0, 0, size.width, size.height), operation: NSCompositingOperation.CompositeCopy, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    
    /**
     Convert an image to it's bitmap 8bits (ARGB bitmap)
     
     - returns: bitmap
     */
    internal func convertToARGBBitmap() -> UnsafeMutablePointer<UInt8>{
        var imageRect:NSRect = NSMakeRect(0, 0, self.size.width, self.size.height)
        
        let imageRef: CGImageRef = self.CGImageForProposedRect(&imageRect, context: nil, hints: nil)!
        
        // Create context to draw UIImage into
        let context = self.createARGBBitmapContext(imageRef)
        
        let width = CGImageGetWidth(imageRef)
        let height = CGImageGetHeight(imageRef)
        
        let rect = CGRectMake(0, 0, CGFloat(width), CGFloat(height))
        CGContextDrawImage(context, rect, imageRef)
        
        let data = CGBitmapContextGetData(context)
        let bitmapData = UnsafeMutablePointer<UInt8>(data)
        
        let bytesPerRow = CGBitmapContextGetBytesPerRow(context)
        let bufferLength = bytesPerRow * height
        
        var newBitmap:UnsafeMutablePointer<UInt8> = nil
        
        print(bufferLength)
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