//
//  AppDelegate.swift
//  MyPricePal
//
//  Created by Brice Redmond on 4/15/19.
//  Copyright © 2019 CS48. All rights reserved.
//

import UIKit
import Firebase
import BarcodeScanner
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SaveData.getChartsData()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        UINavigationBar.appearance().barTintColor = .black
        UIBarButtonItem.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        let barcodeVC = BarcodeScannerViewController()
        window?.rootViewController = MainViewController(rootViewController: barcodeVC)
        
        //Sets the window and mainviewcontroller programatically.
        FirebaseApp.configure();
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SaveData.deleteAllData("Items")
        SaveData.deleteAllData("ChartStats")
        
        let searchVC = (window?.rootViewController as! MainViewController).searchVC
        SaveData.saveSearchData(searchVC!.items)
        
        SaveData.saveChartsData(productsSearched: return_products_searched(), productsScanned: return_products_scanned(), productsAdded: return_products_added())
        
        return
    }
}

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}

