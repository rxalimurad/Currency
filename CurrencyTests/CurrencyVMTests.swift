//
//  CurrencyVMTests.swift
//  CurrencyTests
//
//  Created by murad on 28/10/2022.
//

import XCTest
import Combine
@testable import Currency

class CurrencyVMTests: XCTestCase {
    private var bindings = Set<AnyCancellable>()
    var viewModel = CurrencyConversionViewModel(service: CurrencyConversionMockService())
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.rateList)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.backUpDate)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.countryList)
        viewModel = CurrencyConversionViewModel(service: CurrencyConversionMockService())
        // Should not be empty now
        XCTAssert(viewModel.currencyListModel.currencyList.isEmpty)
        let promise = expectation(description: "Waiting for response")
        viewModel.$rateList
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                XCTFail()
            }, receiveValue: { rates in
                if !(rates?.rates.isEmpty ?? true) {
                    promise.fulfill()
                }
            })
            .store(in: &bindings)
        wait(for: [promise], timeout: 1)
        let promise1 = expectation(description: "Waiting for response")
        viewModel.$currencyListModel
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                XCTFail()
            }, receiveValue: { countryList in
                if !countryList.currencyList.isEmpty {
                    promise1.fulfill()
                }
            })
            .store(in: &bindings)
        wait(for: [promise1], timeout: 1)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCountiesList() throws {
        // Should not be empty now
        XCTAssert(!viewModel.currencyListModel.currencyList.isEmpty)
        // Count should be 3
        XCTAssertEqual(viewModel.currencyListModel.currencyList.count, 3)
        // check if arrays are sorted
        XCTAssert(viewModel.currencyListModel.currencyList.isSorted)
    }
    
    func testRateList() throws {
        // Should not be empty now
        XCTAssert(!(viewModel.rateList?.rates.isEmpty ?? false))
        // Count should be 3
        XCTAssertEqual((viewModel.rateList?.rates.count ?? 0), 3)
    }
    
    func testCoversion() {
        // check conversion
        XCTAssertEqual(viewModel.convertAmount(amount: 1, from: "USD", to: "USD"), 1.0)
        XCTAssertEqual(viewModel.convertAmount(amount: 2, from: "USD", to: "PKR"), 442.75)
    }
    
    func testDataPersistance() {
        XCTAssertNotNil(Preference.backUpDate)
        XCTAssertNotNil(Preference.rateList)
        XCTAssertNotNil(Preference.countryList)
       
    }
    override class func tearDown() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.rateList)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.backUpDate)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.countryList)
    }
}




