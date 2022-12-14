//
//  New_Murja_ClientTests.swift
//  New Murja ClientTests
//
//  Created by Ilpo Lehtinen on 30.10.2022.
//

import XCTest
@testable import New_Murja_Client

final class New_Murja_ClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTagDeduplication() throws {
        let ctrl = Murja_Client_Controller()
        ctrl.titles = [Murja_Title(Month: 2.0, Id: -1, Tags: ["Testing", "Tags"], Year: 1993.0, Title: "Lol"),
                       Murja_Title(Month: 2.0, Id: -1, Tags: ["Tags", "Are", "Your", "Friend"], Year: 1993.0, Title: "Lol")]

        XCTAssertEqual(ctrl.allTags(titles: ctrl.titles),
                        Array(Set(["Testing", "Tags", "Are", "Your", "Friend"])))
    }

    func testPostDecoding() throws {
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: "posts", ofType: "json")!
        let posts = try String(contentsOfFile: path)
        
        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode([Murja_Post].self, from: Data(posts.utf8)))
        
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
