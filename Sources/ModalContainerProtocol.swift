//
//  ModalContainerProtocol.swift
//  ModalViewController
//
//  Created by ZJaDe on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

public protocol ModalContainerProtocol: class {
    typealias AnimateCompletionType = () -> Void
    func show(_ viewCon: ModalViewController, animated: Bool)
    /// ZJaDe: 如果是协调器方式show出来的 为了保证断开循环引用不要使用hide 使用modalVC.cancel()
    func hide(_ viewCon: ModalViewController, animated: Bool, _ completion: AnimateCompletionType?)
}
extension ModalContainerProtocol where Self: UIViewController {
    /// ZJaDe: 具体实现 不能直接调用
    public func _show(_ viewCon: ModalViewController, animated: Bool) {
        guard viewCon.parent == nil else { return }
        let presentationCon = viewCon.createPresentationCon(modalContainer: self)
        let animatedTransitioning = viewCon.createAnimatedTransitioning(isPresenting: true)
        let containerView: UIView = self.view
        let animateDuration = animatedTransitioning.animateDuration(animated)

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
    public func _hide(_ viewCon: ModalViewController, animated: Bool, _ completion: AnimateCompletionType?) {
        guard viewCon.parent is ModalContainerProtocol else { return }
        guard let presentationCon = viewCon.presentationController else { return }
        let animatedTransitioning = viewCon.createAnimatedTransitioning(isPresenting: false)

        let animateDuration = animatedTransitioning.animateDuration(animated)

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
    public func show(_ viewCon: ModalViewController, animated: Bool = true) {
        _show(viewCon, animated: animated)
    }
    public func hide(_ viewCon: ModalViewController, animated: Bool = true, _ callback: AnimateCompletionType? = nil) {
        _hide(viewCon, animated: animated, callback)
    }
}
extension ModalViewController {
    public func show(in container: ModalContainerProtocol, animated: Bool = true) {
        container.show(self, animated: animated)
    }
}
