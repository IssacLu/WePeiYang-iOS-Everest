//
//  WLANLoginViewController.swift
//  WePeiYang
//
//  Created by Tigris on 30/11/2017.
//  Copyright © 2017 twtstudio. All rights reserved.
//

import UIKit
import WMPageController
import SnapKit
import Alamofire
import SafariServices
import SwiftMessages

class WLANBindingViewController: UIViewController {
    
    var usernameTextField: UITextField!
    var passwordTextField: UITextField!
    var bindButton: UIButton!
    var logoutButton: UIButton!
    var dismissButton: UIButton!
//    var serviceButton: UIButton!
    var logoImage: UIImage!
    var logoImageView: UIImageView!
    var warningText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.barStyle = .black
        
        self.title = "校园网绑定"
        
        logoImage = UIImage(named: "TJU")
        let imageRatio: CGFloat = logoImage.size.width / logoImage.size.height
        let imageViewWidth: CGFloat = UIScreen.main.bounds.width * 0.6
        logoImageView = UIImageView.init(image: logoImage)
        logoImageView.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*1.0/5.0), size: CGSize(width: imageViewWidth, height: imageViewWidth / imageRatio))
        self.view.addSubview(logoImageView)
        
        let textFieldWidth: CGFloat = 250
        usernameTextField = UITextField()
        usernameTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: self.view.frame.size.height*2.0/5.0), size: CGSize(width: textFieldWidth, height: 40))
        usernameTextField.placeholder = "请输入账号"
        usernameTextField.keyboardType = .numberPad
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.clearButtonMode = .always
        usernameTextField.autocapitalizationType = .none
        passwordTextField = UITextField()
        passwordTextField.frame = CGRect(center: CGPoint(x: self.view.center.x, y: usernameTextField.frame.origin.y + usernameTextField.frame.size.height + 30), size: CGSize(width: textFieldWidth, height: 40))
        passwordTextField.placeholder = "请输入密码"
        passwordTextField.keyboardType = .default
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.clearButtonMode = .always
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)

        // Auto fill
        usernameTextField.text = TwTUser.shared.WLANAccount
        passwordTextField.text = TwTUser.shared.WLANPassword

        bindButton = UIButton()
        bindButton.frame = CGRect(x: (self.view.frame.size.width-textFieldWidth)/2, y: passwordTextField.frame.origin.y + passwordTextField.frame.size.height + 20, width: textFieldWidth, height: 38)
        bindButton.setTitle("绑 定", for: .normal)
        bindButton.setTitleColor(.white, for: .normal)
        bindButton.isUserInteractionEnabled = true
        bindButton.backgroundColor = UIColor(hex6: 0x00a1e9)
        // to make button rounded rect
        bindButton.layer.borderColor = UIColor(hex6: 0x00a1e9).cgColor
        bindButton.layer.borderWidth = 2
        bindButton.layer.cornerRadius = 5
        bindButton.addTarget(self, action: #selector(bind), for: .touchUpInside)
        self.view.addSubview(bindButton)


        dismissButton = UIButton(frame: CGRect(x: self.view.frame.width, y: bindButton.y + bindButton.height + 20, width: 30, height: 20))
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        dismissButton.setTitleColor(UIColor.gray, for: .normal)
        dismissButton.setTitle("暂不绑定", for: .normal)
        dismissButton.sizeToFit()
        dismissButton.center = CGPoint(x: self.view.center.x, y: bindButton.y + bindButton.height + 20)
        dismissButton.addTarget(self, action: #selector(dismissBinding), for: .touchUpInside)
        self.view.addSubview(dismissButton)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func bind() {
        
        guard usernameTextField.hasText && passwordTextField.hasText else {
            SwiftMessages.showWarningMessage(body: "请填写账号或密码")
            return
        }
            var loginInfo: [String: String] = [String: String]()
            loginInfo["username"] = usernameTextField.text!
            loginInfo["password"] = passwordTextField.text!

            SwiftMessages.showLoading()
            SolaSessionManager.solaSession(type: .get, url: WLANLoginAPIs.loginURL,  parameters: loginInfo, success: { dictionary in
                SwiftMessages.hideLoading()
                guard let errorCode: Int = dictionary["error_code"] as? Int,
                    let errMsg = dictionary["message"] as? String else {
                        SwiftMessages.showErrorMessage(body: "数据解析失败")
                        return
                }

                if errorCode == -1 {
                    TwTUser.shared.WLANBindingState = true
                    TwTUser.shared.WLANAccount = loginInfo["username"]
                    TwTUser.shared.WLANPassword = loginInfo["password"]
                    TwTUser.shared.save()
                    KeychainService.saveWLAN(account: loginInfo["username"]!, password: loginInfo["password"]!)
                    SwiftMessages.showSuccessMessage(body: "绑定成功！")
                    NotificationCenter.default.post(name: NotificationName.NotificationBindingStatusDidChange.name, object: nil)
                    self.dismiss(animated: true, completion: nil)
                } else if errorCode == 50002 {
                    SwiftMessages.showErrorMessage(body: "密码错误")
                } else {
                    TwTUser.shared.WLANAccount = loginInfo["username"]
                    TwTUser.shared.WLANPassword = loginInfo["password"]
                    TwTUser.shared.save()
                    SwiftMessages.hideLoading()
                    SwiftMessages.showErrorMessage(body: errMsg + "\n" + "已为你保存账号密码")
                }
            }, failure: { error in
                SwiftMessages.hideLoading()
                TwTUser.shared.WLANAccount = self.usernameTextField.text!
                TwTUser.shared.WLANPassword = self.passwordTextField.text!
                SwiftMessages.showErrorMessage(body: error.localizedDescription + "\n" + "已为你保存账号密码")
            })
    }
    
//    func cancelLogin() {
//        var loginInfo: [String: String] = [String: String]()
//        loginInfo["tjuuname"] = usernameTextField.text
//        loginInfo["tjupasswd"] = passwordTextField.text
//
//        SwiftMessages.showLoading()
//        SolaSessionManager.solaSession(type: .get, url: WLANLoginAPIs.loginURL, parameters: loginInfo, success: { dictionary in
//            SwiftMessages.hideLoading()
//            guard let errorCode: Int = dictionary["error_code"] as? Int,
//                let errMsg = dictionary["message"] as? String else {
//                    return
//            }
//
//            if errorCode == -1 {
//                TwTUser.shared.tjuBindingState = false
//                TwTUser.shared.save()
//                SwiftMessages.hide()
//                SwiftMessages.showSuccessMessage(body: "解绑成功！")
//                self.dismiss(animated: true, completion: nil)
//            } else {
//                SwiftMessages.hide()
//                SwiftMessages.showErrorMessage(body: errMsg)
//            }
//        }, failure: { error in
//            SwiftMessages.hideLoading()
//            SwiftMessages.showErrorMessage(body: error.localizedDescription)
//        })
//    }
    
    @objc func dismissBinding() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func showService() {
        if let url = URL(string: "http://202.113.4.11/") {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension WLANBindingViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -40
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

