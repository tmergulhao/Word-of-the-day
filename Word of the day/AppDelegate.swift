//
//  AppDelegate.swift
//  Word of the day
//
//  Created by Tiago Mergulhão on 04/09/17.
//  Copyright © 2017 Tiago Mergulhão. All rights reserved.
//

import UIKit
import Ambience
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var persistentContainer : NSPersistentContainer!
    
    var window: UIWindow?
    
    func createContainer(completion : @escaping(NSPersistentContainer) -> ()) {
        let container = NSPersistentContainer(name: "Model")
        
        container.loadPersistentStores { (description, error) in
            guard error == nil else {
                fatalError("Failed to load \(description) with \(String(describing: error))")
            }
            
            DispatchQueue.main.async {
                completion(container)
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        _ = Ambience.shared
        
        var numberOfTimes = Default<Int>(key: "SomeKey")
        
        numberOfTimes « nil
        
        if let numberOfTimesValue = numberOfTimes.value {
            numberOfTimes « numberOfTimesValue + 1
        } else {
            numberOfTimes « 1
        }
        
        print(numberOfTimes)
        
        createContainer { (container) in
            self.persistentContainer = container
        }
        
        return true
    }
}
