//
//  ModalViewController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class ModalViewController: UIViewController, UIViewControllerTransitioningDelegate {

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// ZJaDe:
    open lazy var presentationCon:PresentationController = createPresentationCon(presenting: nil)

    open lazy var animatedTransitioning:ModalAnimatedTransitioning = createModalAnimatedTransitioning()

    open func createPresentationCon(presenting presentingViewController: UIViewController? = nil) -> PresentationController {
        fatalError()
    }
    open func createModalAnimatedTransitioning() -> ModalAnimatedTransitioning {
        fatalError()
    }

    open func configInit() {
        /** ZJaDe:
            configInitd方法中需要随便初始化 一个 PresentationController 对象 要不然后面 presentationCon.presentingViewController 将取不到值，导致判断出错
            就是这么变态，原因未知 手动调用load() initialize()也不行
         */
        _ = self.presentationCon
        self.transitioningDelegate = self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize(traitCollection: self.traitCollection)
        addChildView()
        configLayout()
        view.setNeedsLayout()
    }

    /// ZJaDe: 不要直接调用该方法，重写添加子view
    open func addChildView() {

    }
    /// ZJaDe: 不要直接调用该方法，重写设置约束
    open func configLayout() {

    }
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSize(traitCollection: newCollection)
    }
    open func updatePreferredContentSize(traitCollection: UITraitCollection) {
        self.preferredContentSize = (self.presentedViewController ?? self).view.frame.size
    }

    // MARK: - UIViewControllerTransitioningDelegate
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        assert(self == presented, "presentedViewController错误")
        return self.presentationCon
    }
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animatedTransitioning
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animatedTransitioning
    }

}

