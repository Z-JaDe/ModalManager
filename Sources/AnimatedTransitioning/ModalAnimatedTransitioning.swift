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
    public final func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animateDuration(transitionContext?.isAnimated ?? false)
    }
    public final func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC:UIViewController = transitionContext.viewController(forKey: .from)!
        let toVC:UIViewController = transitionContext.viewController(forKey: .to)!
        let fromView:UIView? = transitionContext.view(forKey: .from)
        let toView:UIView? = transitionContext.view(forKey: .to)
        /// ZJaDe: 是否正在呈现
        let isPresenting = fromVC == self.presentingViewController
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
        }else {
            guard let fromView = fromView else { return }
            hide(fromView: fromView, initialFrame: fromView.frame, duration: transitionDuration, completion: completion)
        }
    }
    func show(toView: UIView, finalFrame: CGRect, duration:TimeInterval, completion: ((Bool) -> Void)?) {
        let initialFrame = calculateToViewInitialFrame(finalFrame: finalFrame)
        toView.frame = initialFrame
        performAnimation(in: toView, finalFrame: finalFrame, duration: duration, completion: completion)
    }
    func hide(fromView: UIView, initialFrame: CGRect, duration:TimeInterval, completion: ((Bool) -> Void)?) {
        let finalFrame = calculateFromViewFinalFrame(initialFrame: initialFrame)
        performAnimation(in: fromView, finalFrame: finalFrame, duration: duration, completion: completion)
    }
    // MARK: -
    open func animateDuration(_ animated: Bool) -> TimeInterval {
        return animated ?  0.35 : 0
    }
    /// ZJaDe: 执行过渡动画
    open func performAnimation(in view: UIView, finalFrame: CGRect, duration:TimeInterval, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, animations: {
            view.frame = finalFrame
        }, completion: completion)
    }
    
    /// ZJaDe: 呈现toView时 的最初frame
    open func calculateToViewInitialFrame(finalFrame:CGRect) -> CGRect {
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
    open func calculateFromViewFinalFrame(initialFrame:CGRect) -> CGRect {
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
