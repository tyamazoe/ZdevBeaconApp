//
//  AppDelegate.swift
//  ZdevBeaconApp
//
//  Created by Tomohisa Yamazoe on 2020/12/18.
//

import UIKit
//import BackgroundTasks

//@main
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        // MARK: Registering Launch Handlers for Tasks
/*
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ziotreks.zdevbeaconapp.refresh", using: nil) { task in
            // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
  */
        /*
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.db_cleaning", using: nil) { task in
            // Downcast the parameter to a processing task as this identifier is used for a processing request.
            //self.handleDatabaseCleaning(task: task as! BGProcessingTask)
            self.handleAppProcessing(task: task as! BGProcessingTask)
        }
        */

        //debugLogPrint(msg:"registered tasks")
        //NSLog("launched")
        return true
    }

   func applicationDidBecomeActive(_ application: UIApplication) {
        //debugLogPrint(msg:"did become active")
        NSLog("did enter become active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //debugLogPrint(msg:"did enter background")
        NSLog("did enter background")
        //scheduleAppRefresh()
        //scheduleDatabaseCleaningIfNeeded()
        //scheduleAppProcessing()
    }

    // MARK: UISceneSession Lifecycle

    /*
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    */

    // MARK: - Handling Launch for Tasks
    /*
    private func handleAppRefresh(task: BGAppRefreshTask) {

        print("handle")
    }
    */
}

