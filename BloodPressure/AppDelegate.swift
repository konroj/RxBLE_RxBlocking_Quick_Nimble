//
//  AppDelegate.swift
//  BloodPressure
//
//  Created by Konrad Roj on 10/07/2019.
//  Copyright © 2019 Konrad Roj. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
}
    
extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = prepareBloodPressureListScene()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationDidBecomeActive(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
        
}

extension AppDelegate {
    
    private func prepareBloodPressureListScene() -> UINavigationController {
        let bluetoothManager = BluetoothManager()
        let databaseManager = CoreDataManager.shared
        let viewModel = BloodPressureListViewModel(bluetoothManager: bluetoothManager, databaseManager: databaseManager)
        let viewController = BloodPressureListViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
}

