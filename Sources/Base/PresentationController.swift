//
//  PresentationController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class PresentationController: UIPresentationController {
    // MARK: -
    public class PresentationWrappingView: UIView { }
    public class DimmingView: UIView { }
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.modalPresentationStyle = .custom
        configInit()
    }
    open func configInit() {

    }

    private var presentationWrappingView: PresentationWrappingView?
    private var dimmingView: DimmingView?

    open override var presentedView: UIView? {
        return self.presentationWrappingView
    }
    // MARK: - 
    public final override func presentationTransitionWillBegin() {
        guard let presentedView = super.presentedView else {
            return
        }
        /// ZJaDe:
        let wrappingView = createPresentationWrappingView()
        self.presentationWrappingView = wrappingView
        wrappingView.frame = self.frameOfPresentedViewInContainerView
        /// ZJaDe:
        presentedView.frame = wrappingView.bounds
        add(presentedView: presentedView, in: wrappingView)
        /// ZJaDe:
        let dimmingView = createDimmingView()
        self.dimmingView = dimmingView
        dimmingView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped(_:))))
        self.containerView?.addSubview(dimmingView)
        /// ZJaDe:
        showDimmingViewAnimate(dimmingView)
    }
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    open override func dismissalTransitionWillBegin() {
        guard let dimmingView = dimmingView else { return }
        hideDimmingViewAnimate(dimmingView)
    }
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed == true {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    // MARK: - 自定义方法 可重写
    /// ZJaDe: 创建presentedView的 阴影层视图
    open func createPresentationWrappingView() -> PresentationWrappingView {
        let view = PresentationWrappingView()
        return view
    }
    /// ZJaDe: 创建背景层视图
    open func createDimmingView() -> DimmingView {
        let dimmingView = DimmingView()
        dimmingView.backgroundColor = UIColor.black
        dimmingView.isOpaque = false
        dimmingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return dimmingView
    }
    /// ZJaDe: 点击 dimmingView
    @objc open func dimmingViewTapped(_ sender:UITapGestureRecognizer) {
        if let container = self.presentingViewController as? ModalContainerProtocol, let modelVC = self.presentedViewController as? ModalViewController {
            container.hide(modelVC, nil)
        } else {
            self.presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    /// ZJaDe: dimmingView动画
    open func showDimmingViewAnimate(_ dimmingView:DimmingView) {
        dimmingView.alpha = 0
        animate {
            dimmingView.alpha = 0.5
        }
    }
    open func hideDimmingViewAnimate(_ dimmingView:DimmingView) {
        animate {
            dimmingView.alpha = 0
        }
    }
    /// ZJaDe: add presentedView
    open func add(presentedView: UIView, in wrappingView: PresentationWrappingView) {
        wrappingView.addSubview(presentedView)
    }
    /// ZJaDe: animate
    open func animate(_ closure: @escaping () -> Void) {
        if let transitionCoordinator = self.presentingViewController.transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: { (context) in
                closure()
            }, completion: nil)
        }else {
            UIView.animate(withDuration: 0.35) {
                closure()
            }
        }
    }

    // MARK: - Layout
    open override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
        if container === self.presentedViewController {
            self.containerView?.setNeedsLayout()
        }
    }
    open override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container === self.presentedViewController {
            return self.presentedViewController.preferredContentSize
        }else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    public final override var frameOfPresentedViewInContainerView: CGRect {
        let presentedViewContentSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds.size)
        guard let result = presentedViewFrame(containerViewBounds, presentedViewContentSize) else {
            return super.frameOfPresentedViewInContainerView
        }
        return result
    }
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        updateViewsFrame()
    }
    /// ZJaDe:
    open func updateViewsFrame() {
        self.dimmingView?.frame = containerViewBounds
        self.presentationWrappingView?.frame = self.frameOfPresentedViewInContainerView
    }
    open override var containerView: UIView? {
        if let result = super.containerView {
            return result
        }else {
            return self.presentingViewController.view
        }
    }
    open var containerViewBounds: CGRect {
        return self.containerView!.bounds
    }
    /// ZJaDe: 计算 presentedView的Frame
    open func presentedViewFrame(_ containerViewBounds:CGRect, _ presentedViewContentSize: CGSize) -> CGRect? {
        return nil
    }
}
