//
//  LegofyTests.swift
//  LegofySwift
//
//  Created by Stefan Lage on 20/01/16.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import XCTest
@testable import LegofySwift

class LegofyTests: XCTestCase {
    
    let legofy = Legofy()
    // Paths
    let imagePath     = NSBundle(forClass: LegofyTests.self).URLForResource("image", withExtension: "")!.path!
    let imageJPGPath  = NSBundle(forClass: LegofyTests.self).URLForResource("image", withExtension: "jpg")!.path!
    let imagePDFPath  = NSBundle(forClass: LegofyTests.self).URLForResource("image", withExtension: "pdf")!.path!
    let defaultOutput = NSFileManager().currentDirectoryPath
    var wrongOutput   = NSFileManager().currentDirectoryPath + "/🏉Legofy🏉"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //#MARK:- Test errors on input URL
    
    func testLegofy_MakeLego_ImageNotFound(){
        self.legofy.makeLegoImage(NSURL(fileURLWithPath:"~/Documents/"), outputPath: "~/Documents/image.png", completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, LegofyErrorImageNotFound, "The code should be equal to LegofyErrorImageNotFound's value")
        })
    }
    
    func testLegofy_MakeLego_ExtensionNotFound(){
        self.legofy.makeLegoImage(NSURL(fileURLWithPath:self.imagePath), outputPath: "~/Documents/image.png", completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, LegofyErrorNoExtension, "The code should be equal to LegofyErrorNoExtension's value")
        })
    }
    
    func testLegofy_MakeLego_WrongExtension(){
        self.legofy.makeLegoImage(NSURL(fileURLWithPath:self.imagePDFPath), outputPath: "~/Documents/image.png", completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, LegofyErrorWrongExtension, "The code should be equal to LegofyErrorWrongExtension's value")
        })
    }
    
    //#MARK:- Test errors on output URL
    
    func testLegofy_MakeLego_OutputDirectoryNotFound(){
        self.legofy.makeLegoImage(NSURL(fileURLWithPath:self.imageJPGPath), outputPath: self.wrongOutput, completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, LegofyErrorOutputDirectoryNotFound, "The code should be equal to LegofyErrorOutputDirectoryNotFound's value")
        })
    }
    
    func testLegofy_MakeLego_OutputNotDirectory(){
        self.legofy.makeLegoImage(NSURL(fileURLWithPath:self.imageJPGPath), outputPath: self.imagePath, completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, LegofyErrorOutputNotDirectory, "The code should be equal to LegofyErrorOutputNotDirectory's value")
        })
    }
    
    //#MARK:- Mock Legofy 
    
    // Mock Legofy to fail the image generation
    func testLegofy_MakeLego_MockImageGeneration(){
        class MockLegofy: Legofy{
            override func generateNewImage(inImage: UIImage, completion:(imageData: NSData?) -> Void){
                completion(imageData: nil)
            }
        }
        
        MockLegofy().makeLegoImage(NSURL(fileURLWithPath:self.imageJPGPath), outputPath: self.defaultOutput, completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, -1995, "The code should be equal to LegofyErrorDescriptionNoData's value")
        })
    }
    
    func testLegofy_MakeLego_MockImageGenerationTimeOut(){
        class MockLegofy: Legofy{
            override func generateNewImage(inImage: UIImage, completion:(imageData: NSData?) -> Void){
                // Set a time out just in case
                let delta: Int64 = 1 * Int64(NSEC_PER_SEC)
                let timeOut = dispatch_time(DISPATCH_TIME_NOW, delta)
                dispatch_after(timeOut, dispatch_get_main_queue(), {
                    // Reach the timeout
                    completion(imageData: nil)
                })
            }
        }
        
        MockLegofy().makeLegoImage(NSURL(fileURLWithPath:self.imageJPGPath), outputPath: self.defaultOutput, completion: { (imageLegofy, error) -> Void in
            // The output image should be nil
            XCTAssertNil(imageLegofy, "The output image should not be set!")
            // The error should be set
            XCTAssertNotNil(error, "There should be an error!")
            // Test Error's domain
            XCTAssertEqual(error!.domain, LegofyErrorDomain, "The error domain should be equal to LegofyErrorDomain")
            // Then we check the error code
            XCTAssertEqual(error!.code, -1995, "The code should be equal to LegofyErrorDescriptionNoData's value")
        })
    }
    
    //#MARK:- Test make legofy image
    func testLegofy_MakeLego(){
        let sendMessageToLegofy = NSDate()
        self.legofy.makeLegoImage(NSURL(fileURLWithPath:self.imageJPGPath), outputPath: self.defaultOutput, completion: { (imageLegofy, error) -> Void in
            let returnMessageFromToLegofy = NSDate()
            // The output image should be nil
            XCTAssertNotNil(imageLegofy, "The output image should not be nil!")
            let executionTime = returnMessageFromToLegofy.timeIntervalSinceDate(sendMessageToLegofy)
            print("executionTime: \(executionTime)")
        })
    }
}
