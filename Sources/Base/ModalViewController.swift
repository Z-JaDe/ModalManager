//
//  ModalViewController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class ModalViewController: UIViewController, ModalPresentationDelegate, ModalAnimatedTransitioningDeledate {
    open override func loadView() {
        super.loadView()
        self.view = ModalRootView(frame: self.view.frame)
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -
    /// ZJaDe: model时 因为不是present(:::) 所以presentingViewController为nil 所以需要手动记录下
    private weak var modalPresenting: UIViewController?

    public weak var presentationDelegate: ModalPresentationDelegate?
    public weak var animatedTransitioningDelegate: ModalAnimatedTransitioningDeledate?

    public var tempPresentationController: PresentationController?
    open func configInit() {
        self.presentationDelegate = self
        self.animatedTransitioningDelegate = self
        /** ZJaDe:
            1. present之前需要随便初始化 一个 PresentationController 对象 要不然后面 presentationCon.presentingViewController 将取不到值，导致判断出错
            就是这么变态，手动调用load() initialize()也不行
         2. 又因为PresentationController初始化后会强引用presentedViewController，为了避免循环引用，还要保证PresentationController不被初始化多次，present之前先持有 PresentationController 对象 dismissed后释放
         */

        tempPresentationController = createPresentationCon(presenting: nil)
        self.transitioningDelegate = tempPresentationController
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        addChildView()
        configLayout()
        view.setNeedsLayout()
        updatePreferredContentSize(traitCollection: self.traitCollection)
        reloadData()
    }

    public var isShowing: Bool {
        return self.getPresenting != nil
    }
    public var getPresenting: UIViewController? {
        return self.modalPresenting ?? self.presentingViewController
    }
    /// ZJaDe: 重新加载
    open func reloadData() {

    }
    /// ZJaDe: 不要直接调用该方法，重写添加子view
    open func addChildView() {

    }
    /// ZJaDe: 不要直接调用该方法，重写设置约束
    open func configLayout() {

    }

    /// ZJaDe: 点击 dimmingView
    @objc open func dimmingViewTapped() {
        cancel()
    }
    
    public var didCancel:(() -> Void)?
    open func cancel(_ completion: (() -> Void)? = nil) {
        if let container = self.parent as? ModalContainerProtocol {
            container.hide(self, completion)
        } else {
            self.dismiss(animated: true, completion: completion)
        }
        self.didCancel?()
    }
    // MARK: -
    // MARK: -
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSize(traitCollection: newCollection)
    }
    open func updatePreferredContentSize(traitCollection: UITraitCollection) {
        self.preferredContentSize = (self.presentedViewController ?? self).view.frame.size
    }

    // MARK: - UIViewControllerTransitioningDelegate
    open var presentationControllerClass: PresentationController.Type {
        return PresentationController.self
    }
    func createPresentationCon(presenting presentingViewController: UIViewController? = nil) -> PresentationController {
        self.modalPresenting = presentingViewController
        return presentationControllerClass.init(self, presenting: presentingViewController)
    }
    func createPresentationCon(modalContainer: UIViewController) -> PresentationController {
        self.modalPresenting = modalContainer
        return presentationControllerClass.init(self, modalContainer: modalContainer)
    }
    open func createAnimatedTransitioning(isPresenting: Bool) -> ModalAnimatedTransitioning {
        return ModalAnimatedTransitioning(isPresenting, self.animatedTransitioningDelegate)
    }

    // MARK: - ModalPresentationDelegate
    public enum AnimateOption {
        case topOutToCenter, bottomOutToCenter, leftOutToCenter, rightOutToCenter
        case topOutIn, bottomOutIn, leftOutIn, rightOutIn
        case centerInOut
    }
    open var animateOption: AnimateOption {
        return .bottomOutToCenter
    }
    open func config(presentationWrappingView wrappingView: PresentationController.PresentationWrappingView) {
        switch self.animateOption {
        case .topOutIn:
            wrappingView.layer.shadowOffset = CGSize(width: 0, height: 6)
        case .bottomOutIn:
            wrappingView.layer.shadowOffset = CGSize(width: 0, height: -6)
        case .leftOutIn:
            wrappingView.layer.shadowOffset = CGSize(width: 6, height: 0)
        case .rightOutIn:
            wrappingView.layer.shadowOffset = CGSize(width: -6, height: 0)
        case .centerInOut, .topOutToCenter, .bottomOutToCenter, .leftOutToCenter, .rightOutToCenter:
            wrappingView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        wrappingView.layer.shadowOpacity = 0.44
        wrappingView.layer.shadowRadius = 13
    }
    open func config(dimmingView: PresentationController.DimmingView) {

    }
    open func presentedViewFrame(_ containerViewBounds: CGRect, _ presentedViewContentSize: CGSize) -> CGRect {
        var result = containerViewBounds
        result.size = presentedViewContentSize
        var x = (containerViewBounds.width - result.width) / 2
        var y = (containerViewBounds.height - result.height) / 2
        result.origin = CGPoint(x: x, y: y)
        switch self.animateOption {
        case .topOutIn:
            y = 0
        case .bottomOutIn:
            y = containerViewBounds.maxY - result.height
        case .leftOutIn:
            x = 0
        case .rightOutIn:
            x = containerViewBounds.maxX - result.width
        case .centerInOut, .topOutToCenter, .bottomOutToCenter, .leftOutToCenter, .rightOutToCenter:
            break
        }
        result.origin = CGPoint(x: x, y: y)
        return result
    }
    public enum State {
        case 还未显示
        case 将要显示
        case 已经显示
        case 将要消失
        case 已经消失
    }
    public private(set) var state: State = .还未显示
    open func presentationTransitionWillBegin() {
        self.state = .将要显示
    }
    open func presentationTransitionDidEnd(_ completed: Bool) {
        self.state = .已经显示
    }
    open func dismissalTransitionWillBegin() {
        self.state = .将要消失
    }
    open func dismissalTransitionDidEnd(_ completed: Bool) {
        self.tempPresentationController = nil
        self.state = .已经消失
    }
    // MARK: - ModalAnimatedTransitioningDeledate
    open func calculateToViewInitialFrame(finalFrame: CGRect) -> CGRect {
        switch self.animateOption {
        case .topOutIn, .topOutToCenter:
            return finalFrame.offsetBy(dx: 0, dy: -finalFrame.height)
        case .bottomOutIn, .bottomOutToCenter:
            return finalFrame.offsetBy(dx: 0, dy: finalFrame.height)
        case .leftOutIn, .leftOutToCenter:
            return finalFrame.offsetBy(dx: -finalFrame.width, dy: 0)
        case .rightOutIn, .rightOutToCenter:
            return finalFrame.offsetBy(dx: finalFrame.width, dy: 0)
        case .centerInOut:
            return CGRect(origin: CGPoint(x: finalFrame.midX, y: finalFrame.midY), size: CGSize.zero)
        }
    }
    open func calculateFromViewFinalFrame(initialFrame: CGRect) -> CGRect {
        return calculateToViewInitialFrame(finalFrame: initialFrame)
    }
}

extension PresentationController: UIViewControllerTransitioningDelegate {
    public final func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        assert(self.modalVC == presented, "presentedViewController错误")
        return self
    }
    public final func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalVC.createAnimatedTransitioning(isPresenting: true)
    }
    public final func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return modalVC.createAnimatedTransitioning(isPresenting: false)
    }
}
//extension UIColor {
//    var alpha: CGFloat {
//        var a: CGFloat = 0
//        getRed(nil, green: nil, blue: nil, alpha: &a)
//        return a
//    }
//}
