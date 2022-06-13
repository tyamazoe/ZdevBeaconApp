//
//  ViewController.swift
//  ZdevBeaconApp
//
//  Created by Tomohisa Yamazoe on 2020/12/18.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        print("Error")
        print(error)
    }
    
    private func stripHeader(msg: String) -> String {
        if msg.hasPrefix("en") {
            print("strip en")
            return String(msg.suffix(msg.count-2))
        }
        else {
            return msg
        }
    }
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // do nothing
        for message in messages {
            for payload in message.records {
                if var payloadString = String.init(data: payload.payload.advanced(by: 1), encoding: .utf8) {
                    payloadString = stripHeader(msg: payloadString)
                    print(payloadString)
                    DispatchQueue.main.async {
                        self.nfcDataLabel.text = payloadString
                    }
                }
            }
        }
    }
    //optional?
    /*
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        
    }
 */
    //:(NFCNDEFReaderSession *)session API_AVAILABLE(ios(13.0)) API_UNAVAILABLE(watchos, macos, tvos);

    @IBOutlet weak var nfcDataLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /*
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.eventBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.eventForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        */

    }


    @IBAction func readNFC(_ sender: Any) {
        let session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: false)
        session.begin()
        print("session start")
    }
}

