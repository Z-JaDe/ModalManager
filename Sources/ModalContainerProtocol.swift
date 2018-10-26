//
//  ModalContainerProtocol.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

public protocol ModalContainerProtocol: class {
    func show(_ viewCon: ModalViewController)
    func hide(_ viewCon: ModalViewController, _ completion: (() -> Void)?)
}
extension ModalContainerProtocol where Self: UIViewController {
    fileprivate func _show(_ viewCon: ModalViewController) {
        guard viewCon.parent == nil else { return }
        viewCon.presentationCon = viewCon.createPresentationCon(presenting: self)
        let presentationCon = viewCon.presentationCon
        let animatedTransitioning = viewCon.animatedTransitioning
        let containerView: UIView = self.view
        let animateDuration = animatedTransitioning.animateDuration(true)

        presentationCon.presentationTransitionWillBegin()
        let toView: UIView = presentationCon.presentedView!
        let finalFrame = presentationCon.frameOfPresentedViewInContainerView
        self.view.addSubview(toView)
        self.addChild(viewCon)
        viewCon.didMove(toParent: self)
        presentationCon.updateViewsFrame()
        toView.frame = animatedTransitioning.calculateToViewInitialFrame(containerView, finalFrame: finalFrame)
        animatedTransitioning.performAnimation(in: toView, finalFrame: finalFrame, duration: animateDuration, completion: nil)
        presentationCon.presentationTransitionDidEnd(true)
    }
    fileprivate func _hide(_ viewCon: ModalViewController, _ completion: (() -> Void)?) {
        guard viewCon.parent is ModalContainerProtocol else { return }
        let presentationCon = viewCon.presentationCon
        let animatedTransitioning = viewCon.animatedTransitioning

        let animateDuration = animatedTransitioning.animateDuration(true)

        presentationCon.dismissalTransitionWillBegin()
        let fromView: UIView = presentationCon.presentedView!
        let finalFrame = animatedTransitioning.calculateFromViewFinalFrame(fromView, initialFrame: fromView.frame)
        self.view.addSubview(presentationCon.presentedView!)
        self.addChild(viewCon)
        viewCon.didMove(toParent: self)

        animatedTransitioning.performAnimation(in: fromView, finalFrame: finalFrame, duration: animateDuration, completion: { (_) in
            fromView.removeFromSuperview()
            viewCon.willMove(toParent: nil)
            viewCon.removeFromParent()
            completion?()
        })
        presentationCon.dismissalTransitionDidEnd(true)
    }
}
extension ModalContainerProtocol where Self: UIViewController {
    public func show(_ viewCon: ModalViewController) {
        _show(viewCon)
    }
    public func hide(_ viewCon: ModalViewController, _ callback: (() -> Void)? = nil) {
        _hide(viewCon, callback)
    }
}
