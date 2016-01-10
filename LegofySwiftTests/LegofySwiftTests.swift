//
//  LegofySwiftTests.swift
//  LegofySwiftTests
//
//  Created by Stefan Lage on 08/01/16.
//  Copyright © 2016 Stefan Lage. All rights reserved.
//

import XCTest
@testable import LegofySwift

class LegofySwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //# MARK : PALETTES

    func test_1_PalettesNotNil(){
        let p = Palettes()
        XCTAssertNotNil(p, "test_1_PalettesNotNil() - Palettes object is nil")
        XCTAssertNotNil(p.palettes(), "test_1_PalettesNotNil() - Palettes dictionary is nil")
    }
    
    func test_2_PalettesCount(){
        let p = Palettes().palettes()
        XCTAssertEqual(p.count, 4, "test_2_PalettesCount() - Problem with palettes's count, should got 4 palettes")
    }

    func test_3_PalettesKeys(){
        let p = Palettes().palettes()
        XCTAssertNotNil(p["effects"], "test_3_PalettesKeys() - Effects key not FOUND!!!")
        XCTAssertNotNil(p["mono"], "test_3_PalettesKeys() - Mono key not FOUND!!!")
        XCTAssertNotNil(p["solid"], "test_3_PalettesKeys() - Solid key not FOUND!!!")
        XCTAssertNotNil(p["transparent"], "test_3_PalettesKeys() - Transparent key not FOUND!!!")
    }
    
    //# MARK : Test each Palettes count
    
    func test_4_1_PalettesEffectCount(){
        let p = Palettes().palettes()
        XCTAssertNotNil(p["effects"], "test_4_1_PalettesEffectCount() - Effects key not FOUND!!!")
        XCTAssertEqual(p["effects"]!.count, 4, "test_4_1_PalettesEffectCount() - Effects - Number of effect colors is wrong!!!")
    }
    
    func test_4_1_PalettesMonoCount(){
        let p = Palettes().palettes()
        XCTAssertNotNil(p["mono"], "test_4_1_PalettesMonoCount() - Mono key not FOUND!!!")
        XCTAssertEqual(p["mono"]!.count, 2, "test_4_1_PalettesMonoCount() - Mono - Number of mono colors is wrong!!!")
    }
    
    func test_4_1_PalettesSolidCount(){
        let p = Palettes().palettes()
        XCTAssertNotNil(p["solid"], "test_4_1_PalettesSolidCount() - Solid key not FOUND!!!")
        XCTAssertEqual(p["solid"]!.count, 33, "test_4_1_PalettesSolidCount() - Solid - Number of solid colors is wrong!!!")
    }
    
    func test_4_1_PalettesTransparentCount(){
        let p = Palettes().palettes()
        XCTAssertNotNil(p["transparent"], "test_4_1_PalettesTransparentCount() - Transparent key not FOUND!!!")
        XCTAssertEqual(p["transparent"]!.count, 14, "test_4_1_PalettesTransparentCount() - Transparent - Number of transparent colors is wrong!!!")
    }
    
    //# MARK: Test merge palettes
    func test_5_1_MergedPalettesNotNil(){
        let p = Palettes()
        XCTAssertNotNil(p, "test_5_1_MergedPalettesNotNil() - Palettes object is nil")
        XCTAssertNotNil(p.palettes(), "test_5_1_MergedPalettesNotNil() - Palettes dictionary is nil")
        XCTAssertNotNil(p.mergePalettes(), "test_5_1_MergedPalettesNotNil() - Merge palettes is nil")
    }
    
    func test_5_2_MergedPalettesCount(){
        let p = Palettes().mergePalettes()
        XCTAssertEqual(p.count, 5, "test_5_2_MergedPalettesCount() - Problem with merged palettes's count, should got 5 palettes")
    }
    
    func test_5_3_MergedPalettesKeys(){
        let p = Palettes().mergePalettes()
        XCTAssertNotNil(p["effects"], "test_5_3_MergedPalettesKeys() - Effects key not FOUND!!!")
        XCTAssertNotNil(p["mono"], "test_5_3_MergedPalettesKeys() - Mono key not FOUND!!!")
        XCTAssertNotNil(p["solid"], "test_5_3_MergedPalettesKeys() - Solid key not FOUND!!!")
        XCTAssertNotNil(p["transparent"], "test_5_3_MergedPalettesKeys() - Transparent key not FOUND!!!")
        XCTAssertNotNil(p["all"], "test_5_3_MergedPalettesKeys() - All key not FOUND!!!")
    }
    
    func test_5_4_PalettesMergedKeys(){
        let p = Palettes().mergePalettes()
        let theoricalAllCount = 53
        let realAllCount = 51
        let allCount = p["effects"]!.count +  p["mono"]!.count +  p["solid"]!.count +  p["transparent"]!.count
        XCTAssertEqual(theoricalAllCount, allCount, "test_5_4_PalettesMergedKeys() - All count should be equal to theorical count!")
        XCTAssertNotEqual(realAllCount, allCount, "test_5_4_PalettesMergedKeys() - All count should not be equal to real count!")
        XCTAssertEqual(p["all"]!.count, realAllCount, "test_5_4_PalettesMergedKeys() - All count should contains 53 colors1")
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
