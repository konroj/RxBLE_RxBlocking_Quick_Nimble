//
//  BloodPressureListViewModel.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import RxBluetoothKit
import RxSwift

final class BloodPressureListViewModel {
    private let bluetoothManager: BluetoothManager
    private let databaseManager: CoreDataManager
    private var bloodPressureCharacteristic: Characteristic?
    
    var model: [BloodPressure] {
        return databaseManager.loadBloodPressureEntities()
    }
    
    init(bluetoothManager: BluetoothManager, databaseManager: CoreDataManager) {
        self.bluetoothManager = bluetoothManager
        self.databaseManager = databaseManager
    }
    
    func connect() -> Observable<Characteristic> {
        return bluetoothManager.connectBloodPressure()
        .do(onNext: { [weak self] (characteristic) in
            self?.bloodPressureCharacteristic = characteristic
            self?.bluetoothManager.observeBloodPressureAndSetNotification(for: characteristic)
            self?.bluetoothManager.observeDisconnect()
        })
        .asObservable()
    }
    
    func read() -> Single<Characteristic> {
        guard let bloodPressureCharacteristic = bloodPressureCharacteristic else { return Single.error(BluetoothManagerError.readValueFailed) }
        
        return bluetoothManager.readBloodPressure(from: bloodPressureCharacteristic)
    }
    
    func observePeripherialStatus() -> Observable<BluetoothManager.PeripheralStatus?> {
        return bluetoothManager.peripheralStatus.asObservable()
    }
    
    func observeBloodPressureValues() -> Observable<BluetoothManager.BloodPressureMeasurement?> {
        return bluetoothManager.observedBloodPressureValues
        .do(onNext: { [weak self] entity in
            guard let data = entity?.0, let date = entity?.1 else { return }
            self?.databaseManager.saveBloodPressure(BloodPressure(value: data, date: date))
        })
        .asObservable()
    }
    
}
