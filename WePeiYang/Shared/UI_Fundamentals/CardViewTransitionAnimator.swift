//
//  CardViewTransitionAnimator.swift
//  WePeiYang
//
//  Created by Halcao on 2017/12/6.
//  Copyright © 2017年 twtstudio. All rights reserved.
//

import UIKit

class CardViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    fileprivate var isPresenting: Bool
    fileprivate var velocity = 0.6
    
    init(isPresenting: Bool) {
        self.isPresenting = isPresenting
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return velocity
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
}
