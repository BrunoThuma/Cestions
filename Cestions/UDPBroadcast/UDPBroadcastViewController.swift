//
//  UDPBroadcastViewController.swift
//  Cestions
//
//  Created by Bruno Thuma on 13/10/21.
//

import UIKit

class UDPBroadcastViewController: UIViewController {

    var broadcastConnection: UDPBroadcastConnection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUdpBroadcastFramework()
    }
    
    func setupUdpBroadcastFramework() {
        do {
            broadcastConnection = try UDPBroadcastConnection(
                port: 35602,
                handler: { ipAddress,port,response  in
                    print("Received from \(ipAddress):\(port):\n\n\(response)")
                },
                errorHandler: { (error) in
                    print(error)
                })

        } catch {
            print("Initialization error")
        }
    }
    
    //MARK:- @objc
    @objc func sendBroadcastTapped() {
        do {
            try broadcastConnection.sendBroadcast("This is a test!")
        } catch {
            print("Error on stablishing UDP connection")
        }
    }
}
