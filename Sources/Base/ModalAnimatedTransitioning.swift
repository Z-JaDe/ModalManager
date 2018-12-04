//
//  ModalAnimatedTransitioning.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class ModalAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    public let isPresenting: Bool
    public weak var modalDelegate: ModalAnimatedTransitioningDeledate?
    public init(_ isPresenting: Bool, _ modalDelegate: ModalAnimatedTransitioningDeledate?) {
        self.isPresenting = isPresenting
        self.modalDelegate = modalDelegate
        super.init()
    }
    /// ZJaDe:
    public final func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animateDuration(transitionContext?.isAnimated ?? false)
    }
    public final func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let _:UIViewController = transitionContext.viewController(forKey: .from)!
        let toVC: UIViewController = transitionContext.viewController(forKey: .to)!
        let fromView: UIView? = transitionContext.view(forKey: .from)
        let toView: UIView? = transitionContext.view(forKey: .to)

        let containerView = transitionContext.containerView
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        /// ZJaDe:
        if let toView = toView {
            containerView.addSubview(toView)
        }
        let transitionDuration = self.transitionDuration(using: transitionContext)
        let completion: (Bool) -> Void = { (_) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
        if isPresenting {
            guard let toView = toView else { return }
            show(toView: toView, finalFrame: toViewFinalFrame, duration: transitionDuration, completion: completion)
        } else {
            guard let fromView = fromView else { return }
            hide(fromView: fromView, initialFrame: fromView.frame, duration: transitionDuration, completion: completion)
        }
    }
    func show(toView: UIView, finalFrame: CGRect, duration: TimeInterval, completion: ((Bool) -> Void)?) {
        let initialFrame = calculateToViewInitialFrame(finalFrame: finalFrame)
        toView.alpha = 0
        toView.frame = initialFrame
        performAnimation(withDuration: duration, {
            toView.alpha = 1
            toView.frame = finalFrame
        }, completion: completion)
    }
    func hide(fromView: UIView, initialFrame: CGRect, duration: TimeInterval, completion: ((Bool) -> Void)?) {
        let finalFrame = calculateFromViewFinalFrame(initialFrame: initialFrame)
        performAnimation(withDuration: duration, {
            fromView.frame = finalFrame
            fromView.alpha = 0
        }, completion: completion)
    }
    // MARK: -
    open func animateDuration(_ animated: Bool) -> TimeInterval {
        return animated ?  0.35 : 0
    }
    /// ZJaDe: 执行过渡动画
    open func performAnimation(withDuration duration: TimeInterval, _ animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: [], animations: animations, completion: completion)
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }

    /// ZJaDe: 呈现toView时 的最初frame
    open func calculateToViewInitialFrame(finalFrame: CGRect) -> CGRect {
        if let rect = self.modalDelegate?.calculateToViewInitialFrame(finalFrame: finalFrame) {
            return rect
        }
        return finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
    }
    /// ZJaDe: 隐藏fromView时 的最终frame
    open func calculateFromViewFinalFrame(initialFrame: CGRect) -> CGRect {
        if let rect = self.modalDelegate?.calculateFromViewFinalFrame(initialFrame: initialFrame) {
            return rect
        }
        return initialFrame.offsetBy(dx: 0, dy: initialFrame.height)
    }
}
