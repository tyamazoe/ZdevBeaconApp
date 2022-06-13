//
//  SceneDelegate.swift
//  ZdevBeaconApp
//
//  Created by Tomohisa Yamazoe on 2020/12/18.
//

import UIKit
import BackgroundTasks

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        // MARK: Registering Launch Handlers for Tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.ziotreks.zdevbeaconapp.refresh", using: nil) { task in
            // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        NSLog("scine")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        NSLog("scineDidEnterBackground")
        //scheduleAppRefresh()
    }
    // MARK: - Scheduling Tasks
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.ziotreks.zdevbeaconapp.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // Fetch no earlier than 15 minutes from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
            NSLog("scheduleAppRefreshed")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    // MARK: - Handling Launch for Tasks
    private func handleAppRefresh(task: BGAppRefreshTask) {
        // 1日の間、何度も実行したい場合は、1回実行するごとに新たにスケジューリングに登録します
        NSLog("handleAppRefresh (1)")
        scheduleAppRefresh()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        // 時間内に実行完了しなかった場合は、処理を解放します
        // バックグラウンドで実行する処理は、次回に回しても問題ない処理のはずなので、これでOK
        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        // サンプルの処理をキューに詰めます
        //let array = [1, 2, 3, 4, 5]
        let array = [1, 2, 3, 4, 5]
        array.enumerated().forEach { arg in
            let (offset, value) = arg
            let operation = PrintOperation(id: value)
            if offset == array.count - 1 {
                operation.completionBlock = {
                    // 最後の処理が完了したら、必ず完了したことを伝える必要があります
                    task.setTaskCompleted(success: operation.isFinished)
                }
            }
            queue.addOperation(operation)
        }
        NSLog("handleAppRefresh (2)")
    }

}
// サンプル用のOperation
class PrintOperation: Operation {
    let id: Int

    private func debugLogPrint(msg:String) {
        let dt = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd HHmmss.SSS", options: 0, locale: Locale(identifier: "ja_JP"))
        print("\(dateFormatter.string(from: dt)): \(msg)")
    }

    init(id: Int) {
        self.id = id
    }

    override func main() {
        debugLogPrint(msg:"this operation id is \(self.id)")
        //localPush()
        //getServerStatus()
        /*
        if id == 1 {
            scanBeacon()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // your code here
                NSLog("waiting for ...")
                self.stopBeacon()
                //self.getServerStatus()
            }
        }
        else if id == 3 {
            getServerStatus()
        }
        else {
            //debugLogPrint(msg: "id: \(id)")
        }
        */
        //getServerStatus()
        debugLogPrint(msg:"print operation main done \(id)")
        //debugLogPrint(msg:"print operation main done without delay")
    }
    /*
    func localPush() {
        print("localPush")
        let content = UNMutableNotificationContent()
        content.title = "お知らせ"
        content.body = "localPush background"
        //content.sound = UNNotificationSound.default

        // 直ぐに通知を表示
        let request = UNNotificationRequest(identifier: "immediately", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    private let beaconScanner = BeaconScanner()
    private func scanBeacon() {
        NSLog("scan Beacon")
        beaconScanner.startScan()
    }
    private func stopBeacon() {
        NSLog("stop Beacon")
        beaconScanner.stopScan()
    }
    

    // -----------------------------------
    // Connect server
    let serverAddress = "192.168.1.83"
    let serverPort = "8888"
    
    func getServerStatus() {
        let url = "http://\(serverAddress):\(serverPort)/device/status"
        getURL(url: url)
    }
    func getURL(url:String) {
        do {
            let apiUrl = URL(string:url)!
            let dat = try Data(contentsOf: apiUrl)
            //debugLogPrint(msg:"dat")
            NSLog("dat")
            NSLog("\(dat)")
            if let bufString = String.init(data: dat, encoding: .utf8) {
                NSLog("data")
                print(bufString)
                //responseLabel.text = bufString
            }
            //resposeLabel.text = String(data)!
            //let json = try JSONSerialization.jsonObject(with: dat) as! [String: Any]
            //print("JSON")
            //print(json)
            //responseLabel.text = json
            
        //} catch APIError.Network {
        //    self.responseLabel.text = "Exception"
        } catch {
            print(error)
            //self.responseLabel.text = "Exception"
        }
    }
     */

}

