//
//  UDPBroadcastViewController.swift
//  Cestions
//
//  Created by Bruno Thuma on 13/10/21.
//

import UIKit

class UDPBroadcastViewController: UIViewController {
    
    private lazy var labelMessage: UILabel = .init()
    private lazy var portTextField: FormsTextField = .init(placeholder: "Port")
    private lazy var messageTextField: FormsTextField = .init(placeholder: "Message")
    private lazy var udpButton: RoundedButton = RoundedButton.createBlueButton(title: "Send Broadcast")

    var broadcastConnection: UDPBroadcastConnection!
    
    var tap: UITapGestureRecognizer!
    
    var portUDP: UInt16?
    
    let gradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardNotifications()
        
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray6.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        setupMessageLabel()
        setupPortTextField()
        setupMessageTextField()
        setupUdpButton()
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            labelMessage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
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
            portTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                   constant: -40),
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
        
        udpButton.addTarget(self, action: #selector(sendBroadcastTapped), for: .touchUpInside)
        
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
    @objc func finishedPortInput() {
        print("portDidEdit")
        guard portTextField.text != "" else {
            portUDP = nil
            return
        }
        portTextField.layer.borderWidth = 0
        portUDP = UInt16(portTextField.text!)
        print(portTextField.text!)
    }
    
    @objc func sendBroadcastTapped() {
        guard portUDP != nil else {
            portTextField.layer.borderWidth = 1
            portTextField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        
        setupUdpBroadcastFramework()
        
        do {
            try broadcastConnection.sendBroadcast(messageTextField.text ?? "TestUDPBroadcast")
        } catch {
            print("Error on stablishing UDP connection")
        }
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
    func setupUdpBroadcastFramework() {
        
        guard let portUDP = portUDP else {
            portTextField.layer.borderWidth = 1
            portTextField.layer.borderColor = UIColor.systemRed.cgColor
            return
        }
        
        self.labelMessage.text = "Received from\t 192.168.15.157:20001\n\tHello UDP Client"
        
        do {
            broadcastConnection = try UDPBroadcastConnection(
                port: portUDP,
                handler: { ipAddress,port,response  in
                    print("Received from \(ipAddress):\(port):\n\n\(response)")
                    self.labelMessage.text = "Received from \(ipAddress):\(port)\n\(response)"
                },
                errorHandler: { (error) in
                    print(error)
                })

        } catch {
            print("Initialization error")
        }
    }
}
