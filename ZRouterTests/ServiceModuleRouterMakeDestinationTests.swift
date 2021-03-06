//
//  ServiceModuleRouterMakeDestinationTests.swift
//  ZRouterTests
//
//  Created by zuik on 2018/4/28.
//  Copyright © 2018 zuik. All rights reserved.
//

import XCTest
import ZRouter

class ServiceModuleRouterMakeDestinationTests: XCTestCase {
    weak var router: ModuleServiceRouter<AServiceModuleInput>? {
        willSet {
            strongRouter = newValue
        }
    }
    private var strongRouter: ModuleServiceRouter<AServiceModuleInput>?
    var leaveTestExpectation: XCTestExpectation?
    
    func enterTest() {
        leaveTestExpectation = self.expectation(description: "Leave test")
    }
    
    func leaveTest() {
        strongRouter = nil
        leaveTestExpectation?.fulfill()
    }
    
    func handle(_ block: @escaping () -> Void) {
        DispatchQueue.main.async {
            block()
        }
    }
    
    override func setUp() {
        super.setUp()
        TestRouteRegistry.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        XCTAssert(self.router == nil, "Test router is not released")
        TestConfig.routeShouldFail = false
    }
    
    func testMakeDestination() {
        XCTAssertTrue(Router.to(RoutableServiceModule<AServiceModuleInput>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableServiceModule<AServiceModuleInput>())
        XCTAssertNotNil(destination)
    }
    
    func testMakeDestinationWithPreparation() {
        XCTAssertTrue(Router.to(RoutableServiceModule<AServiceModuleInput>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableServiceModule<AServiceModuleInput>(), preparation: { (module) in
            module.title = "test title"
            module.makeDestinationCompletion({ (destination) in
                XCTAssert(destination.title == "test title")
            })
        })
        XCTAssertNotNil(destination is AServiceInput)
    }
    
    func testMakeDestinationWithConfiguring() {
        let providerExpectation = self.expectation(description: "successHandler")
        let performerExpectation = self.expectation(description: "performerSuccessHandler")
        let completionHandlerExpectation = self.expectation(description: "completionHandler")
        XCTAssertTrue(Router.to(RoutableServiceModule<AServiceModuleInput>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableServiceModule<AServiceModuleInput>(), configuring: { (config, prepareModule) in
            prepareModule({ module in
                module.title = "test title"
                module.makeDestinationCompletion({ (destination) in
                    XCTAssert(destination.title == "test title")
                })
            })
            config.successHandler = { d in
                providerExpectation.fulfill()
            }
            config.performerSuccessHandler = { d in
                performerExpectation.fulfill()
            }
            config.errorHandler = { (action, error) in
                XCTAssert(false, "errorHandler should not be called")
            }
            config.performerErrorHandler = { (action, error) in
                XCTAssert(false, "performerErrorHandler should not be called")
            }
            config.completionHandler = { (success, destination, action, error) in
                XCTAssertTrue(success)
                XCTAssert(destination is AServiceInput)
                completionHandlerExpectation.fulfill()
            }
        })
        XCTAssertNotNil(destination is AServiceInput)
        waitForExpectations(timeout: 5, handler: { if let error = $0 {print(error)}})
    }
    
    func testSwiftAdapter() {
        let providerExpectation = self.expectation(description: "successHandler")
        let performerExpectation = self.expectation(description: "performerSuccessHandler")
        let completionHandlerExpectation = self.expectation(description: "completionHandler")
        XCTAssertTrue(Router.to(RoutableServiceModule<AServiceModuleInputAdapter>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableServiceModule<AServiceModuleInput>(), configuring: { (config, prepareModule) in
            prepareModule({ module in
                module.title = "test title"
                module.makeDestinationCompletion({ (destination) in
                    XCTAssert(destination.title == "test title")
                })
            })
            config.successHandler = { d in
                providerExpectation.fulfill()
            }
            config.performerSuccessHandler = { d in
                performerExpectation.fulfill()
            }
            config.errorHandler = { (action, error) in
                XCTAssert(false, "errorHandler should not be called")
            }
            config.performerErrorHandler = { (action, error) in
                XCTAssert(false, "performerErrorHandler should not be called")
            }
            config.completionHandler = { (success, destination, action, error) in
                XCTAssertTrue(success)
                XCTAssert(destination is AServiceInput)
                completionHandlerExpectation.fulfill()
            }
        })
        XCTAssertNotNil(destination is AServiceInput)
        waitForExpectations(timeout: 5, handler: { if let error = $0 {print(error)}})
    }
    
    func testObjcAdapter() {
        let providerExpectation = self.expectation(description: "successHandler")
        let performerExpectation = self.expectation(description: "performerSuccessHandler")
        let completionHandlerExpectation = self.expectation(description: "completionHandler")
        XCTAssertTrue(Router.to(RoutableServiceModule<AServiceModuleInputObjcAdapter>())!.canMakeDestination)
        let destination = Router.makeDestination(to: RoutableServiceModule<AServiceModuleInput>(), configuring: { (config, prepareModule) in
            prepareModule({ module in
                module.title = "test title"
                module.makeDestinationCompletion({ (destination) in
                    XCTAssert(destination.title == "test title")
                })
            })
            config.successHandler = { d in
                providerExpectation.fulfill()
            }
            config.performerSuccessHandler = { d in
                performerExpectation.fulfill()
            }
            config.errorHandler = { (action, error) in
                XCTAssert(false, "errorHandler should not be called")
            }
            config.performerErrorHandler = { (action, error) in
                XCTAssert(false, "performerErrorHandler should not be called")
            }
            config.completionHandler = { (success, destination, action, error) in
                XCTAssertTrue(success)
                XCTAssert(destination is AServiceInput)
                completionHandlerExpectation.fulfill()
            }
        })
        XCTAssertNotNil(destination is AServiceInput)
        waitForExpectations(timeout: 5, handler: { if let error = $0 {print(error)}})
    }
}
