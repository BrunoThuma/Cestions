//
//  ViewController.swift
//  Cestions
//
//  Created by Bruno Thuma on 07/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var udpBroadcast: RoundedButton = RoundedButton.createBlueButton(title: "UDP Broadcast")
    private lazy var udpMessage: RoundedButton = RoundedButton.createBlueButton(title: "UDP direct IP")
    
    let gradient = CAGradientLayer()

    override func viewDidLoad() {
        title = "UDP Options"
        
        setupViews()
        setupHierarchy()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    func setupViews() {
        gradient.frame = self.view.bounds
        gradient.colors = [UIColor.systemGray4.cgColor, UIColor.systemGray6.cgColor]
        
        view.layer.insertSublayer(gradient, at: 0)
        
        udpBroadcast.addTarget(self,
                               action: #selector(udpBroadcastTapped),
                               for: .touchUpInside)
        
        udpMessage.addTarget(self,
                             action: #selector(udpMessageTapped),
                             for: .touchUpInside)
    }

    func setupHierarchy() {
        view.addSubview(udpBroadcast)
        view.addSubview(udpMessage)
    }

    func setupConstraints() {
        let contraints = [
            udpBroadcast.heightAnchor.constraint(equalToConstant: RoundedButton.LayoutMetrics.buttonHeight),
            udpBroadcast.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                  constant: RoundedButton.LayoutMetrics.buttonHorizontalPadding),
            udpBroadcast.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                   constant: -RoundedButton.LayoutMetrics.buttonHorizontalPadding),
            udpBroadcast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            udpBroadcast.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            udpMessage.heightAnchor.constraint(equalToConstant: RoundedButton.LayoutMetrics.buttonHeight),
            udpMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: RoundedButton.LayoutMetrics.buttonHorizontalPadding),
            udpMessage.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -RoundedButton.LayoutMetrics.buttonHorizontalPadding),
            udpMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            udpMessage.topAnchor.constraint(equalTo: udpBroadcast.bottomAnchor, constant: 40)
        ]
        NSLayoutConstraint.activate(contraints)
    }

    @objc private func udpBroadcastTapped() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let scanVC = UDPBroadcastViewController()
        navigationController?.pushViewController(scanVC, animated: true)
    }
    
    @objc private func udpMessageTapped() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        let collectionVC = UDPMessageViewController()
        navigationController?.pushViewController(collectionVC, animated: true)
    }
}
