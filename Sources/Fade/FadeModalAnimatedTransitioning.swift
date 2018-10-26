//
//  FadeModalAnimatedTransitioning.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class FadeModalAnimatedTransitioning: ModalAnimatedTransitioning {
    public let fadeAnimationOptions: ModalFadeAnimationOptions
    public init(_ fadeAnimationOptions: ModalFadeAnimationOptions, _ presentingViewController:UIViewController) {
        self.fadeAnimationOptions = fadeAnimationOptions
        super.init(presentingViewController)
    }

    override func show(toView: UIView, finalFrame: CGRect, duration: TimeInterval, completion: ((Bool) -> Void)?) {
        let initialFrame = calculateToViewInitialFrame(finalFrame: finalFrame)
        toView.alpha = 0
        toView.frame = initialFrame
        performAnimation(withDuration: duration, {
            toView.alpha = 1
            toView.frame = finalFrame
        }, completion: completion)
    }
    override func hide(fromView: UIView, initialFrame: CGRect, duration: TimeInterval, completion: ((Bool) -> Void)?) {
        let finalFrame = calculateFromViewFinalFrame(initialFrame: initialFrame)
        performAnimation(withDuration: duration, {
            fromView.alpha = 0
            fromView.frame = finalFrame
        }, completion: completion)
        
    }
    open override func calculateToViewInitialFrame(finalFrame: CGRect) -> CGRect {
        switch self.fadeAnimationOptions {
        case .fill:
            return finalFrame
        case .bottom:
            return finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        case .top:
            return finalFrame.offsetBy(dx: 0, dy: -finalFrame.height)
        case .left:
            return finalFrame.offsetBy(dx: -finalFrame.width, dy: 0)
        case .right:
            return finalFrame.offsetBy(dx: finalFrame.width, dy: 0)
        case .center:
            return CGRect(origin: CGPoint(x: finalFrame.midX, y: finalFrame.midY), size: CGSize.zero)
        }
    }
    open override func calculateFromViewFinalFrame(initialFrame: CGRect) -> CGRect {
        switch self.fadeAnimationOptions {
        case .fill:
            return initialFrame
        case .bottom:
            return initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
        case .top:
            return initialFrame.offsetBy(dx: 0, dy: -initialFrame.height)
        case .left:
            return initialFrame.offsetBy(dx: -initialFrame.width, dy: 0)
        case .right:
            return initialFrame.offsetBy(dx: initialFrame.width, dy: 0)
        case .center:
            return CGRect(origin: CGPoint(x: initialFrame.midX, y: initialFrame.midY), size: CGSize.zero)
        }
    }
}
