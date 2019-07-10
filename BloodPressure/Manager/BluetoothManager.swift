//
//  BluetoothManager.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import RxSwift
import RxCocoa
import RxBluetoothKit
import CoreBluetooth

final class BluetoothManager {
    typealias PeripheralStatus = (String?, String?)
    typealias BloodPressureMeasurement = (Data, Date)
    
    let observedBloodPressureValues = BehaviorSubject<BloodPressureMeasurement?>(value: nil)
    let peripheralStatus = BehaviorSubject<PeripheralStatus?>(value: nil)
    
    private let bag = DisposeBag()
    private let centralManager = CentralManager(queue: .main)
    private var peripheral: Peripheral?
}

extension BluetoothManager {
    
    func connectBloodPressure() -> Observable<Characteristic> {
        return centralManager
            .observeState()
            .startWith(centralManager.state)
            .filter { $0 == .poweredOn }
            .subscribeOn(MainScheduler.instance)
            .flatMap { [weak self] _ -> Observable<ScannedPeripheral> in
                guard let self = self else { return Observable.empty() }
                return self.centralManager.scanForPeripherals(withServices:  [Const.CBUUIDs.service])
            }
            .take(1)
            .flatMap { $0.peripheral.establishConnection() }
            .do(onNext: { [weak self] peripherial in
                self?.peripheral = peripherial
                self?.peripheralStatus.onNext((peripherial.name, Const.ConnectionState.state(from: peripherial.isConnected)))
            })
            .flatMap { $0.discoverServices([Const.CBUUIDs.service]) }
            .flatMap { Observable.from($0) }
            .flatMap { $0.discoverCharacteristics([Const.CBUUIDs.characteristic]) }
            .flatMap { Observable.from($0) }
    }
    
    func readBloodPressure(from characteristic: Characteristic) -> Single<Characteristic> {
        return characteristic.readValue()
    }
    
    func writeBloodPressure(to characteristic: Characteristic, data: Data) -> Completable {
        guard let writeType = characteristic.determineWriteType() else {
            return Completable.error(BluetoothManagerError.writeValueFailed)
        }
        return characteristic.writeValue(data, type: writeType).asCompletable()
    }
    
    func observeBloodPressureAndSetNotification(for characteristic: Characteristic) {
        characteristic.observeValueUpdateAndSetNotification().subscribe(onNext: { [weak self] (characteristic) in
            guard let value = characteristic.value else { return }
            self?.observedBloodPressureValues.onNext((value, Date()))
        }, onError: { (error) in
            // handle error
        })
        .disposed(by: bag)
    }
    
    func observeDisconnect() {
        centralManager.observeDisconnect(for: peripheral)
        .subscribe(onNext: { [weak self] (peripherial, reason) in
            guard let self = self else { return }
            self.peripheralStatus.onNext((peripherial.name, Const.ConnectionState.state(from: peripherial.isConnected)))
            // should handle disconnect
        }, onError: { (error) in
            // handle error
        })
        .disposed(by: bag)
    }
    
}

enum BluetoothManagerError: Error {
    case readValueFailed
    case writeValueFailed
}
