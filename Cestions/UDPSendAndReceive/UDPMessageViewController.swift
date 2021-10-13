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
    private lazy var addressTextField: FormsTextField = .init(placeholder: "HostIP")
    private lazy var portTextField: FormsTextField = .init(placeholder: "Port")
    private lazy var messageTextField: FormsTextField = .init(placeholder: "Message")
    private lazy var udpButton: RoundedButton = RoundedButton.createBlueButton(title: "Send message")
    
    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host?// = "192.168.15.157"
    var portUDP: NWEndpoint.Port?// = 20001
    
    var tap: UITapGestureRecognizer!
    
    let gradient = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray6.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        setupKeyboardNotifications()

        setupStatusLabel()
        setupMessageLabel()
        setupAddressTextField()
        setupPortTextField()
        setupMessageTextField()
        setupUdpButton()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupStatusLabel() {
        labelStatus.translatesAutoresizingMaskIntoConstraints = false
        labelStatus.text = "Conection Status: Disconnected"
        labelStatus.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
        
        view.addSubview(labelStatus)
        
        let contraints = [
            labelStatus.heightAnchor.constraint(equalToConstant:
                                                    FormsTextField
                                                    .LayoutMetrics
                                                    .textFieldHeight),
            labelStatus.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelStatus.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                             constant: 40),
            labelStatus.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                 constant:
                                                    FormsTextField
                                                    .LayoutMetrics
                                                    .textFieldHorizontalPadding),
            labelStatus.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant:
                                                    -FormsTextField
                                                    .LayoutMetrics
                                                    .textFieldHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupMessageLabel() {
        labelMessage.translatesAutoresizingMaskIntoConstraints = false
        labelMessage.text = ""
        labelMessage.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
        labelMessage.numberOfLines = 0
        
        view.addSubview(labelMessage)
        
        let contraints = [
            labelMessage.heightAnchor.constraint(equalToConstant: 80),
            labelMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelMessage.topAnchor.constraint(equalTo: labelStatus.bottomAnchor,
                                              constant: 40),
            labelMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant:
                                                    FormsTextField
                                                    .LayoutMetrics
                                                    .textFieldHorizontalPadding),
            labelMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                  constant:
                                                    -FormsTextField
                                                    .LayoutMetrics
                                                    .textFieldHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupAddressTextField() {
        addressTextField.addTarget(self,
                                   action: #selector(finishedAddressInput),
                                   for: .editingDidEnd)
        addressTextField.text = "192.168.15.157"
        view.addSubview(addressTextField)
        
        let contraints = [
            addressTextField.heightAnchor.constraint(equalToConstant:
                                                        FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHeight),
            addressTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addressTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                      constant: -40),
            addressTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant:
                                                        FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHorizontalPadding),
            addressTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant:
                                                        -FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupPortTextField() {
        portTextField.addTarget(self,
                                action: #selector(finishedPortInput),
                                for: .editingDidEnd)
        portTextField.text = "20001"
        
        view.addSubview(portTextField)
        
        let contraints = [
            portTextField.heightAnchor.constraint(equalToConstant:
                                                        FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHeight),
            portTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            portTextField.topAnchor.constraint(equalTo: addressTextField.bottomAnchor,
                                                      constant: 20),
            portTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant:
                                                    FormsTextField
                                                    .LayoutMetrics
                                                    .textFieldHorizontalPadding),
            portTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant:
                                                        -FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupMessageTextField() {
        messageTextField.text = "Jonas"
        
        view.addSubview(messageTextField)
        
        let contraints = [
            messageTextField.heightAnchor.constraint(equalToConstant:
                                                        FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHeight),
            messageTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageTextField.topAnchor.constraint(equalTo: portTextField.bottomAnchor,
                                                  constant: 20),
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                      constant:
                                                        FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHorizontalPadding),
            messageTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                       constant:
                                                        -FormsTextField
                                                        .LayoutMetrics
                                                        .textFieldHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    private func setupUdpButton() {
        
        udpButton.addTarget(self, action: #selector(sendUdpTapped), for: .touchUpInside)
        
        view.addSubview(udpButton)
        
        let contraints = [
            udpButton.heightAnchor.constraint(equalToConstant:
                                                RoundedButton
                                                .LayoutMetrics
                                                .buttonHeight),
            udpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            udpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                              constant: -60),
            udpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant:
                                                RoundedButton
                                                .LayoutMetrics
                                                .buttonHorizontalPadding),
            udpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant:
                                                    -RoundedButton
                                                    .LayoutMetrics
                                                    .buttonHorizontalPadding)
        ]
        NSLayoutConstraint.activate(contraints)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        
        return true
    }
    
    //MARK:- @objc
    @objc func finishedAddressInput() {
        print("ipDidEdit")
        guard addressTextField.text != "" else {
            hostUDP = nil
            return
        }
        addressTextField.layer.borderWidth = 0
        hostUDP = NWEndpoint.Host(addressTextField.text!)
        print(addressTextField.text!)
    }
    
    @objc func finishedPortInput() {
        print("portDidEdit")
        guard portTextField.text != "" else {
            portUDP = nil
            return
        }
        portTextField.layer.borderWidth = 0
        portUDP = NWEndpoint.Port(rawValue: UInt16(portTextField.text!)!)
        print(portTextField.text!)
    }
    
    @objc func sendUdpTapped() {
        guard let hostUDP = hostUDP else {
            addressTextField.layer.borderWidth = 1
            addressTextField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        
        guard let portUDP = portUDP else {
            portTextField.layer.borderWidth = 1
            portTextField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        
        connectToUDP(hostUDP, portUDP)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 90
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK:- UDP
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:
        let messageToUDP = messageTextField.text ?? ""
        var statusText = "Connection Status: Disconnected"
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        self.connection?.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                statusText = "Connection Status: Ready"
                self.sendUDP(messageToUDP)
                self.receiveUDP()
            case .setup:
                statusText = "Connection Status: Setup"
            case .cancelled:
                statusText = "Connection Status: Cancelled"
            case .preparing:
                statusText = "Connection Status: Preparing"
            default:
                statusText = "Connection Status: ERROR! State not defined!"
            }
        }
        self.labelStatus.text = statusText
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
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                    DispatchQueue.main.async { self.labelMessage.text = "Received: \(backToString)" }
                } else {
                    print("Data == nil")
                }
            }
        }
    }
}
