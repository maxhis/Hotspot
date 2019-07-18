//
//  ViewController.swift
//  Hotspot
//
//  Created by 马爱星 on 2019/7/15.
//  Copyright © 2019 oio.dev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var password: String? {
        didSet {
            if let _ = password {
                let content = "WIFI:S:\(UIDevice.current.name);T:WPA;P:\(password!);;"
                imageView.image = QRCodeGenerator.generateOpaqueQRCode(content: content)
            } else {
                imageView.image = nil
            }
            self.infoLabel.text = "SSID: \(UIDevice.current.name)\nPassword: \(self.password ?? "N/A")"
        }
    }
    
    lazy var inputAlert: UIAlertController = {
        let inputAlert = UIAlertController(title: "Input password", message: "at least 8 characters", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let pwd = inputAlert.textFields?.first?.text {
                self.password = pwd
                UserDefaults.standard.setValue(pwd, forKey: Constants.passwordKey)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        inputAlert.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.addTarget(self, action: #selector(self.textDidChanged(textField:)), for: .editingChanged)
        }
        okAction.isEnabled = false
        inputAlert.addAction(okAction)
        inputAlert.addAction(cancelAction)
        
        return inputAlert
    }()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Hotspot"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.infoLabel.text = "SSID:\(UIDevice.current.name)\nPassword:\(self.password ?? "N/A")"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPassword()
    }
    
    @IBAction func settingPressed(_ sender: Any) {
        present(self.inputAlert, animated: true, completion: nil)
    }
    
    func checkPassword() {
        if let password = UserDefaults.standard.string(forKey: Constants.passwordKey) {
            self.password = password
        } else {
            present(self.inputAlert, animated: true, completion: nil)
        }
    }
    
    @objc func textDidChanged(textField: UITextField) {
        if let input = textField.text, input.count >= 8 {
            self.inputAlert.actions.first?.isEnabled = true
        } else {
            self.inputAlert.actions.first?.isEnabled = false
        }
    }
}
