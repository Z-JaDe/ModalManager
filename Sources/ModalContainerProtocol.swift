//
//  ModalContainerProtocol.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

public protocol ModalContainerProtocol: class {
    typealias AnimateCompletionType = () -> Void
    func show(_ viewCon: ModalViewController)
    func hide(_ viewCon: ModalViewController, _ completion: AnimateCompletionType?)
}
extension ModalContainerProtocol where Self: UIViewController {
    /// ZJaDe: 具体实现 不能直接调用
    public func _show(_ viewCon: ModalViewController) {
        guard viewCon.parent == nil else { return }
        viewCon.presentationCon = viewCon.createPresentationCon(presenting: self)
        let presentationCon = viewCon.presentationCon
        let animatedTransitioning = viewCon.animatedTransitioning
        let containerView: UIView = self.view
        let animateDuration = animatedTransitioning.animateDuration(true)

        presentationCon.presentationTransitionWillBegin()
        let toView: UIView = presentationCon.presentedView!
        let finalFrame = presentationCon.frameOfPresentedViewInContainerView
        containerView.addSubview(toView)
        self.addChild(viewCon)
        viewCon.didMove(toParent: self)
        presentationCon.updateViewsFrame()
        animatedTransitioning.show(toView: toView, finalFrame: finalFrame, duration: animateDuration, completion: nil)
        presentationCon.presentationTransitionDidEnd(true)
    }
    /// ZJaDe: 具体实现 不能直接调用
    public func _hide(_ viewCon: ModalViewController, _ completion: AnimateCompletionType?) {
        guard viewCon.parent is ModalContainerProtocol else { return }
        let presentationCon = viewCon.presentationCon
        let animatedTransitioning = viewCon.animatedTransitioning

        let animateDuration = animatedTransitioning.animateDuration(true)

        presentationCon.dismissalTransitionWillBegin()
        let fromView: UIView = presentationCon.presentedView!

        animatedTransitioning.hide(fromView: fromView, initialFrame: fromView.frame, duration: animateDuration, completion: { (_) in
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
    public func hide(_ viewCon: ModalViewController, _ callback: AnimateCompletionType? = nil) {
        _hide(viewCon, callback)
    }
}
extension ModalViewController {
    public func show(in container: ModalContainerProtocol) {
        container.show(self)
    }
    public func hide(_ callback: ModalContainerProtocol.AnimateCompletionType? = nil) {
        (self.parent as? ModalContainerProtocol)?.hide(self, callback)
    }
}
