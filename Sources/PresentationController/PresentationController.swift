//
//  PresentationController.swift
//  PresentationController
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
    public var modalViewLayout: ModalViewLayout = .default
    private var presentationWrappingView: PresentationWrappingView?
    private var dimmingView: DimmingView?

    open override var presentedView: UIView? {
        return self.presentationWrappingView
    }
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
    // MARK: -
    open override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    open override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed == true {
            self.presentationWrappingView = nil
            self.dimmingView = nil
        }
    }
    open override func dismissalTransitionWillBegin() {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView?.alpha = 0
        }, completion: nil)
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
        guard let containerViewBounds = self.containerView?.bounds else {
            return super.frameOfPresentedViewInContainerView
        }
        let presentedViewContentSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds.size)
        guard let result = presentedViewFrame(containerViewBounds, presentedViewContentSize) else {
            return super.frameOfPresentedViewInContainerView
        }
        return result
    }
    open override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        if let containerView = self.containerView {
            self.dimmingView?.frame = containerView.bounds
        }
        self.presentationWrappingView?.frame = self.frameOfPresentedViewInContainerView
    }
    /// ZJaDe: 计算 presentedView的Frame
    open func presentedViewFrame(_ containerViewBounds:CGRect, _ presentedViewContentSize: CGSize) -> CGRect? {
        var result = containerViewBounds
        result.size = presentedViewContentSize
        switch self.modalViewLayout {
        case .default: return nil
        case .top:
            result.origin.y = 0
        case .bottom:
            result.origin.y = containerViewBounds.maxY - result.height
        case .left:
            result.origin.x = 0
        case .right:
            result.origin.x = containerViewBounds.maxX - result.width
        case .center:
            let x = (containerViewBounds.width - result.width) / 2
            let y = (containerViewBounds.height - result.height) / 2
            result.origin = CGPoint(x: x, y: y)
        }
        return result
    }
    // MARK: -
    /// ZJaDe: 创建presentedView的 阴影层视图
    open func createPresentationWrappingView() -> PresentationWrappingView {
        let view = PresentationWrappingView()
        switch self.modalViewLayout {
        case .default:
            return view
        case .top:
            view.layer.shadowOffset = CGSize(width: 0, height: 6)
        case .bottom:
            view.layer.shadowOffset = CGSize(width: 0, height: -6)
        case .left:
            view.layer.shadowOffset = CGSize(width: 6, height: 0)
        case .right:
            view.layer.shadowOffset = CGSize(width: -6, height: 0)
        case .center:
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        view.layer.shadowOpacity = 0.44
        view.layer.shadowRadius = 13
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
        self.presentingViewController.dismiss(animated: true, completion: nil)
    }
    /// ZJaDe: dimmingView动画
    open func showDimmingViewAnimate(_ dimmingView:DimmingView) {
        let transitionCoordinator = self.presentingViewController.transitionCoordinator
        dimmingView.alpha = 0
        transitionCoordinator?.animate(alongsideTransition: { (context) in
            dimmingView.alpha = 0.5
        }, completion: nil)
    }
    /// ZJaDe: add presentedView
    open func add(presentedView: UIView, in wrappingView: PresentationWrappingView) {
        wrappingView.addSubview(presentedView)
    }
    
}


