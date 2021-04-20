//
//  GhibliMoviesTests.swift
//  GhibliMoviesTests
//
//  Created by Muhammad Rajab Priharsanto on 19/04/21.
//

import XCTest
@testable import GhibliMovies

class GhibliMoviesTests: XCTestCase {

    var viewController: HomeViewController?
    var viewModel: ApiViewModel?
    
    override func setUp() {
        super.setUp()
        let sampleStoryBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let homeView  = sampleStoryBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        viewController = homeView
        XCTAssertNotNil(viewController?.view, "Home View not found")
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testGoToHomeVC() {
        guard viewController != nil else {
            XCTAssertTrue(false, "Home View Controller not found")
            return
        }
    }
    
    func testHomeBindData() {
        viewController?.fetchData()
        viewController?.setupTableView()
        viewController?.alertErrorSetup()
        viewController?.reloadInputViews()
    }
}
