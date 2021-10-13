//
//  UDPMessageViewController.swift
//  Cestions
//
//  Created by Bruno Thuma on 12/10/21.
//

import UIKit
import Network

class UDPMessageViewController: UIViewController {

    private lazy var labelStatus: UILabel = .init()
    private lazy var labelMessage: UILabel = .init()
    private lazy var addressTextField: UITextField = .init()
    private lazy var messageTextField: UITextField = .init()
    private lazy var udpButton: RoundedButton = RoundedButton.createBlueButton(title: "Send message")
    
    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host?// = "192.168.15.157"
    var portUDP: NWEndpoint.Port?// = 20001
    
    let gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray6.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)

        setupUdpButton()
    }
    
    private func setupUdpButton() {
        
        udpButton.addTarget(self, action: #selector(udpRoutine), for: .touchUpInside)
        
        view.addSubview(udpButton)
        
        let contraints = [
            udpButton.heightAnchor.constraint(equalToConstant: RoundedButton.LayoutMetrics.buttonHeight),
            udpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            udpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            udpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: RoundedButton.LayoutMetrics.buttonHorizontalPadding),
            udpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -RoundedButton.LayoutMetrics.buttonHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupStatusLabel() {
        labelStatus.translatesAutoresizingMaskIntoConstraints = false
        labelStatus.textColor = .systemGray6
    }
    
    private func setupMessageLabel() {
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        labelMessage.textColor = .systemGray6
    }
    
    private func setupAddressField() {
        addressTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //MARK:- UDP
    @objc func udpRoutine() {
        
        guard let hostUDP = hostUDP, let portUDP = portUDP else {
            addressTextField.layer.borderWidth = 1
            addressTextField.layer.borderColor = UIColor.systemRed.cgColor
            messageTextField.layer.borderWidth = 1
            messageTextField.layer.borderColor = UIColor.systemRed.cgColor
            
            return
        }

        connectToUDP(hostUDP, portUDP)
    }
    
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:
        let messageToUDP = "Teste"
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
                case .ready:
                    print("State: Ready\n")
                    self.sendUDP(messageToUDP)
                    self.receiveUDP()
                case .setup:
                    print("State: Setup\n")
                case .cancelled:
                    print("State: Cancelled\n")
                case .preparing:
                    print("State: Preparing\n")
                default:
                    print("ERROR! State not defined!\n")
            }
        }
        self.connection?.start(queue: .global())
    }

    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }

    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
                DispatchQueue.main.async { self.labelStatus.text = "Data was sent to UDP" }
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    
    func receiveUDP() {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                DispatchQueue.main.async { self.labelStatus.text = "Receive is complete" }
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                    DispatchQueue.main.async { self.labelMessage.text = backToString }
                    
                } else {
                    print("Data == nil")
                }
            }
        }
    }
}
