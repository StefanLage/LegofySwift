//
//  LegofySwiftMacTests.swift
//  LegofySwiftMacTests
//
//  Created by Stefan Lage on 22/01/16.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import XCTest
@testable import LegofySwift

//TODO: Make all tests

class LegofySwiftMacTests: XCTestCase {
    
    let legofy = Legofy()
    // Paths
    let imagePath     = NSBundle(forClass: LegofySwiftMacTests.self).URLForResource("image", withExtension: "")!.path!
    let imageJPGPath  = NSBundle(forClass: LegofySwiftMacTests.self).URLForResource("image", withExtension: "jpg")!.path!
    let imagePDFPath  = NSBundle(forClass: LegofySwiftMacTests.self).URLForResource("image", withExtension: "pdf")!.path!
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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
