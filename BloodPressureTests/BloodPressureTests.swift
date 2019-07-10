//
//  BloodPressureTests.swift
//  BloodPressureTests
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import RxBluetoothKit
import RxSwift
import RxBlocking
import Quick
import Nimble
@testable import BloodPressure

class BloodPressureSpec: QuickSpec {

    // should use mocked services/managers
    
    override func spec() {
        var viewModel: BloodPressureListViewModel!
        
        beforeEach {
            let databaseManager = CoreDataManager.shared
            databaseManager.clearAll()
            let bluetoothManager = BluetoothManager()
            viewModel = BloodPressureListViewModel(bluetoothManager: bluetoothManager, databaseManager: CoreDataManager.shared)
        }
        
        describe("calling") {
            context("connect") {
                it("should should connect phone to characteristic") {
                    do {
                        _ = try viewModel.connect()
                            .timeout(10.0, scheduler: MainScheduler())
                            .toBlocking()
                            .first()
                        let status = try viewModel.observePeripherialStatus().toBlocking().first()
                        
                        expect(status??.0).toNot(beNil())
                    } catch {
                        fail()
                    }
                }
            }
            
            context("read method") {
                it("should fetch data from connected characteristic") {
                    do {
                        _ = try viewModel.connect()
                            .flatMap({ _ -> Single<Characteristic> in
                                return viewModel.read()
                            })
                            .timeout(10.0, scheduler: MainScheduler())
                            .toBlocking()
                            .first()
                        let value = try viewModel.observeBloodPressureValues().toBlocking().first()
                        
                        expect(value??.1).to(beCloseTo(Date(), within: 0.1))
                    } catch {
                        fail()
                    }
                }
            }
        }
    }
    
}
