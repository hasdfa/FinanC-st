//
//  AppDelegate.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    weak var drawerController: UIDrawerController? = nil

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if UserDefaults.standard.object(forKey: "first") == nil {
            AppDelegate.initDatabase(with: persistentContainer.viewContext)
            UserDefaults.standard.set(false, forKey: "first")
        }
        
        return true
    }
    
    public static func initDatabase(with context: NSManagedObjectContext) {
        let wallet1 = Wallet(context: context)
        wallet1.title = "Wallet 1"
        [Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 5), description: "Some1", value: 5000, type: .expenses, category: .rent),
        Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 7), description: "Some2", value: 60_000, type: .expenses, category: .bill),
        Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 6), description: "Some3", value: 100, type: .expenses, category: .rent),
        Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 6), description: "Some4", value: 2_500, type: .expenses, category: .rent)].forEach {
            transaction in
            wallet1.addToTransactions(transaction)
        }
        [Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 5), description: "Some1", value: 3_000, type: .income, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 7), description: "Some2", value: 150_000, type: .income, category: .bill),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 6), description: "Some3", value: 2000, type: .income, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 6), description: "Some4", value: 200, type: .income, category: .rent)].forEach {
            transaction in
            wallet1.addToTransactions(transaction)
        }
        
        
        let wallet2 = Wallet(context: context)
        wallet2.title = "Wallet 2"
        [Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 7), description: "Some21", value: 4_000, type: .expenses, category: .bill),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 6), description: "Some31", value: 200, type: .expenses, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 5), description: "Some11", value: 6000, type: .expenses, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 4), description: "Some41", value: 500, type: .expenses, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 3), description: "Some41", value: 200, type: .expenses, category: .rent)].forEach {
            transaction in
            wallet2.addToTransactions(transaction)
        }
        [Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 7), description: "Some21", value: 1_956, type: .income, category: .bill),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 6), description: "Some31", value: 5_100, type: .income, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 5), description: "Some11", value: 4000, type: .income, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 4), description: "Some41", value: 0, type: .income, category: .rent),
         Transaction.createOn(context, date: DateComponents.initWith(year: 2017, month: 3), description: "Some41", value: 100, type: .income, category: .rent)].forEach {
            transaction in
            wallet2.addToTransactions(transaction)
        }
        
        try! context.save()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FinanC_st")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension UIViewController {
    
    public var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    public var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
}


