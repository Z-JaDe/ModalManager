//
//  ModalAnimatedTransitioning.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class ModalAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    public let modalViewLayout: ModalViewLayout
    public let presentingViewController: UIViewController
    public init(_ modalViewLayout: ModalViewLayout, _ presentingViewController:UIViewController) {
        self.modalViewLayout = modalViewLayout
        self.presentingViewController = presentingViewController
        super.init()
    }
    /// ZJaDe:
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? false) ? 0.35 : 0
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC:UIViewController = transitionContext.viewController(forKey: .from)!
        let toVC:UIViewController = transitionContext.viewController(forKey: .to)!
        let fromView:UIView? = transitionContext.view(forKey: .from)
        let toView:UIView? = transitionContext.view(forKey: .to)
        /// ZJaDe: 是否正在呈现
        let isPresenting = fromVC == self.presentingViewController
        let containerView = transitionContext.containerView
        let fromViewInitialFrame = transitionContext.initialFrame(for: fromVC)
        var fromViewFinalFrame = transitionContext.finalFrame(for: fromVC)
        var toViewInitialFrame = transitionContext.initialFrame(for: toVC)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC)

        /// ZJaDe:
        if let toView = toView {
            containerView.addSubview(toView)
        }

        if isPresenting {
            toViewInitialFrame = calculateToViewInitialFrame(containerView, finalFrame: toViewFinalFrame)
            toView?.frame = toViewInitialFrame
        } else {
            fromViewFinalFrame = calculateFromViewFinalFrame(containerView, initialFrame: fromView?.frame ?? fromViewInitialFrame)
        }

        if isPresenting {
            guard let toView = toView else { return }
            performAnimation(in: toView, finalFrame: toViewFinalFrame, using: transitionContext)
        }else {
            guard let fromView = fromView else { return }
            performAnimation(in: fromView, finalFrame: fromViewFinalFrame, using: transitionContext)
        }
    }
    /// ZJaDe: 执行过渡动画
    open func performAnimation(in view: UIView, finalFrame: CGRect, using transitionContext: UIViewControllerContextTransitioning) {
        let transitionDuration = self.transitionDuration(using: transitionContext)
        UIView.animate(withDuration: transitionDuration, animations: {
            view.frame = finalFrame
        }) { (_) in
            let wasCancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!wasCancelled)
        }
    }
    /// ZJaDe: 呈现toView时 的最初frame
    open func calculateToViewInitialFrame(_ containerView:UIView, finalFrame:CGRect) -> CGRect {
        switch self.modalViewLayout {
        case .default, .bottom:
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
    /// ZJaDe: 隐藏fromView时 的最终frame
    open func calculateFromViewFinalFrame(_ containerView:UIView, initialFrame:CGRect) -> CGRect {
        switch self.modalViewLayout {
        case .default, .bottom:
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
