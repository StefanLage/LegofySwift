//
//  Legofy.swift
//  LegofySwift
//
//  Created by Stefan Lage on 22/01/16.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import Foundation
import AppKit

//#MARK: LegofyError Public
public let LegofyErrorDomain: String                      = "LegofyErrorDomain"
public let LegofyErrorImageNotFound: Int                  = -1990
public let LegofyErrorNoExtension: Int                    = -1991
public let LegofyErrorWrongExtension: Int                 = -1992
public let LegofyErrorOutputDirectoryNotFound: Int        = -1993
public let LegofyErrorOutputNotDirectory: Int             = -1994
public let LegofyErrorNoData: Int                         = -1995

//#MARK: LegofyError Private
// Description messages
private let LegofyErrorDescriptionImageNotFound           = "The image was not found!"
private let LegofyErrorDescriptionNoExtension             = "The path your entered has no extension!"
private let LegofyErrorDescriptionWrongExtension          = "The file is not an image or it's not PNG / JPG!"
private let LegofyErrorDescriptionOutputDirectoryNotFound = "The outpu path was not found!"
private let LegofyErrorDescriptionOutputNotDirectory      = "The output pawth you entered seems to be a file instead of a directory"
private let LegofyErrorDescriptionNoData                  = "Time out! (20s) Your image seems to be too big for our generator."
// Suggestion messages
private let LegofyErrorSuggestionImageNotFound            = "Are you sure you put the right path?"
private let LegofyErrorSuggestionNoExtension              = "Make sure to add the file extension in your path"
private let LegofyErrorSuggestionWrongExtension           = "This framework only support PNG and JPEG files"
private let LegofyErrorSuggestionOutputDirectoryNotFound  = "Please infrom a valid path to a directory"
private let LegofyErrorSuggestionOutputNotDirectory       = "The path must point to a directory"
private let LegofyErrorSuggestionNoData                   = "Maybe you should compress your image and then retry to legofy it"

//# MARK: Static private

/**
Just make a dictionary formatted as a NSError's userInfo

- parameter descriptionKey:
- parameter suggestion:

- returns:
*/
private func makeErrorUserInfo(descriptionKey: String, suggestion: String) -> [NSObject : AnyObject]{
    return [NSLocalizedDescriptionKey : descriptionKey,
        NSLocalizedRecoverySuggestionErrorKey: suggestion]
}


//#MARK:- Legofy
public class Legofy{
    
    private let brickImageName = "1x1B4"
    
    public init(){
    }
    
    //# MARK: Internal methods
    
    /**
    Generate new CGSize adjusting a pattern size to a source one
    
    - parameter inSize:  CGSize
    - parameter patternSize:
    
    - returns: CGSize generated
    */
    private func newSize(inSize: CGSize, patternSize: CGSize) -> CGSize{
        var newSize = inSize
        let scaleX = patternSize.width
        let scaleY = patternSize.height
        var scale: CGFloat
        if(newSize.width > scaleX || newSize.height > scaleY){
            if(newSize.width < newSize.height){
                scale = newSize.height / scaleY
            }
            else{
                scale = newSize.width / scaleX
            }
            newSize = CGSizeMake(round(newSize.width/scale), round(newSize.height/scale))
        }
        return newSize
    }
    
    internal func generateNewImage(inImage: NSImage, completion:(imageData: NSData?) -> Void){
        var image       = inImage
        // Get brick image object
        let brickImage = NSBundle(forClass: Legofy.self).imageForResource(self.brickImageName)! /// NSImage(named: self.brickImageName)!
//        let brickImage  = NSImage(named: self.brickImageName, inBundle: NSBundle(forClass: Legofy.self), compatibleWithTraitCollection: nil)!
        let brickWidth  = brickImage.size.width
        let brickHeight = brickImage.size.height
        // Calculate the new image size
        let newSize = self.newSize(image.size, patternSize: brickImage.size)
        // Minimize the source image
        image = image.thumbnail(newSize)
        // Make te "future" image object (a blank one -> white image)
        var legoImage = NSImage.initBlank(CGSizeMake(newSize.width * brickWidth, newSize.height * brickHeight), color: NSColor.whiteColor())
        let baseRect  = CGRectMake(0, 0, legoImage.size.width, legoImage.size.height)
        let brickSize = brickImage.size
        
        // Get image bitmap
        let colors = image.convertToARGBBitmap()
        
        // Set a time out just in case
        let delta: Int64 = 20 * Int64(NSEC_PER_SEC)
        let timeOut = dispatch_time(DISPATCH_TIME_NOW, delta)
        dispatch_after(timeOut, dispatch_get_main_queue(), {
            // Reach the timeout
            completion(imageData: nil)
        })
        
        // Start filling the lego image
        for var brickX = CGFloat(0); brickX < newSize.width; ++brickX{
            for var brickY = CGFloat(0); brickY < newSize.height; ++brickY{
                autoreleasepool {
                    // Get the pixel position in terms of the original image
                    let offset: Int = 4*((Int(image.size.width) * Int(brickY)) + (Int(brickX)))
                    // Get ARGB values
                    let alpha = Double(colors[offset]) / Double(255)
                    let red = Double(colors[offset+1]) / Double(255)
                    let green = Double(colors[offset+2]) / Double(255)
                    let blue = Double(colors[offset+3]) / Double(255)
                    // Get the color object
                    let color = NSColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
                    // Make the rectangle where will be added the new brick
                    let brickRect = CGRectMake(brickX * brickWidth, brickY * brickHeight, brickSize.width, brickSize.height)
                    let tmpImage = NSImage(size: baseRect.size)
                    tmpImage.lockFocus()
                    // Draw the pattern image
                    legoImage.drawInRect(baseRect)
                    // Paint it with the brick rect with right color then paste the brick images
                    color.setFill()
                    brickImage.drawInRect(brickRect, fromRect: baseRect, operation: NSCompositingOperation.CompositeMultiply, fraction: 1.0)
//                    UIRectFillUsingBlendMode(brickRect, CGBlendMode.Multiply)
                    NSRectFillUsingOperation(brickRect, NSCompositingOperation.CompositeMultiply)
                    tmpImage.unlockFocus()
                    // Save the new image
                    legoImage = tmpImage
                }
            }
        }
        
//        let legoImageRep: NSBitmapImageRep = legoImage.representations.filter { (imgrep) -> Bool in
//            if(imgrep.isKindOfClass(NSBitmapImageRep.self)){
//                return true
//            }
//            else{
//                return false
//            }
//        }.first as! NSBitmapImageRep!
        let cgRef:CGImageRef = legoImage.CGImageForProposedRect(nil, context: nil, hints: nil)!
        let legoImageRep: NSBitmapImageRep =  NSBitmapImageRep(CGImage: cgRef)
        // Works for PNG too
        completion(imageData:legoImageRep.representationUsingType(NSBitmapImageFileType.NSJPEGFileType, properties: [:]))
    }
    
    //# MARK: Public methods
    
    // Make a lego version of an image
    public func makeLegoImage(imagePathToLegofy: NSURL, outputPath: String?, completion:(imageLegofy: NSImage?, error: NSError?) -> Void){
        var _sourceExt: String?
        var _outputPath = outputPath
        
        // First thing First -> Make sure the image exists
        if(!NSFileManager.defaultManager().fileExistsAtPath(imagePathToLegofy.path!)){
            completion(imageLegofy: nil, error: NSError(domain: LegofyErrorDomain, code: LegofyErrorImageNotFound, userInfo: makeErrorUserInfo(LegofyErrorDescriptionImageNotFound, suggestion: LegofyErrorSuggestionImageNotFound)))
            return
        }
        else{
            // Make sure the file is an image (JPEG or PNG)
            _sourceExt = imagePathToLegofy.pathExtension
            if (_sourceExt == nil || _sourceExt!.isEmpty) {
                completion(imageLegofy: nil, error: NSError(domain: LegofyErrorDomain, code: LegofyErrorNoExtension, userInfo: makeErrorUserInfo(LegofyErrorDescriptionNoExtension, suggestion: LegofyErrorSuggestionNoExtension)))
                return
            }
            if(_sourceExt?.caseInsensitiveCompare("jpg") != NSComparisonResult.OrderedSame
                && _sourceExt?.caseInsensitiveCompare("jpeg") != NSComparisonResult.OrderedSame
                && _sourceExt?.caseInsensitiveCompare("png") != NSComparisonResult.OrderedSame){
                    completion(imageLegofy: nil, error: NSError(domain: LegofyErrorDomain, code: LegofyErrorWrongExtension, userInfo: makeErrorUserInfo(LegofyErrorDescriptionWrongExtension, suggestion: LegofyErrorSuggestionWrongExtension)))
                    return
            }
        }
        
        // Then check the output path -> if nil then set its default value to
        if(_outputPath != nil){
            var isDirectory = ObjCBool(false)
            if(!NSFileManager.defaultManager().fileExistsAtPath(_outputPath!, isDirectory: &isDirectory)){
                completion(imageLegofy: nil, error: NSError(domain: LegofyErrorDomain, code: LegofyErrorOutputDirectoryNotFound, userInfo: makeErrorUserInfo(LegofyErrorDescriptionOutputDirectoryNotFound, suggestion: LegofyErrorSuggestionOutputDirectoryNotFound)))
                return
            }
            if(!isDirectory){
                completion(imageLegofy: nil, error: NSError(domain: LegofyErrorDomain, code: LegofyErrorOutputNotDirectory, userInfo: makeErrorUserInfo(LegofyErrorDescriptionOutputNotDirectory, suggestion: LegofyErrorSuggestionOutputNotDirectory)))
                return
            }
        }
        else{
            // Set the default value
            _outputPath = imagePathToLegofy.path
        }
        // Set output filename
        let filename = ((imagePathToLegofy.absoluteString as NSString).lastPathComponent as NSString).stringByDeletingPathExtension + "_legofy." + _sourceExt!
        // Make final path
        _outputPath! += "/" + filename
        // The image should exists!
        let sourceImage = NSImage(data: NSData(contentsOfURL: imagePathToLegofy)!)!
        // Generate the image legofy
        self.generateNewImage(sourceImage, completion:{(imageData) -> Void in
            guard let newImageData = imageData else{
                completion(imageLegofy: nil, error: NSError(domain: LegofyErrorDomain, code: LegofyErrorNoData, userInfo: makeErrorUserInfo(LegofyErrorDescriptionNoData, suggestion: LegofyErrorSuggestionNoData)))
                return
            }
            // Save the new image
            newImageData.writeToFile(_outputPath!, atomically: true)
            completion(imageLegofy: NSImage(data: newImageData), error: nil)
        })
    }
}