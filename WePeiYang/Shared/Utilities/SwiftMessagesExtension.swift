//
//  SwiftMessagesExtension.swift
//  WePeiYang
//
//  Created by Halcao on 2018/3/13.
//  Copyright © 2018年 twtstudio. All rights reserved.
//

import UIKit
import SwiftMessages

extension SwiftMessages {
    static func showInfoMessage(title: String = "", body: String, context: PresentationContext = .automatic, layout: MessageView.Layout = .cardView) {
        message(title: title, body: body, theme: .info, context: context, layout: layout)
    }

    static func showSuccessMessage(title: String = "", body: String, context: PresentationContext = .automatic, layout: MessageView.Layout = .cardView) {
        message(title: title, body: body, theme: .success, context: context, layout: layout)
    }

    static func showWarningMessage(title: String = "", body: String, context: PresentationContext = .automatic, layout: MessageView.Layout = .cardView) {
        message(title: title, body: body, theme: .warning, context: context, layout: layout)
    }

    static func showErrorMessage(title: String = "", body: String, context: PresentationContext = .automatic, layout: MessageView.Layout = .cardView) {
        message(title: title, body: body, theme: .error, context: context, layout: layout)
    }

    static func message(title: String, body: String, theme: Theme, context: PresentationContext? = nil, layout: MessageView.Layout = .cardView) {
        let view = MessageView.viewFromNib(layout: layout)
        view.configureContent(title: title, body: body)
        view.button?.isHidden = true

        view.configureTheme(theme)

        var config = SwiftMessages.Config()
        if let context = context {
            config.presentationContext = context
        } else {
            if let top = UIViewController.current?.navigationController {
                config.presentationContext = .view(top.view)
            } else {
                config.presentationContext = .automatic
            }
        }
//        else if let top = UIViewController.current {
//            config.presentationContext = .view(top.view)
//        }

        SwiftMessages.show(config: config, view: view)
    }

    static var otherMessages = SwiftMessages()

    static func showLoading() {
//        var newMessage = SwiftMessages()
        let nib = UINib(nibName: "LoadingView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! UIView
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: UIWindowLevelAlert)
        config.interactiveHide = false
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        config.duration = .forever
        otherMessages.show(config: config, view: view)
    }

    static func hideLoading() {
        otherMessages.hideAll()
    }
}

