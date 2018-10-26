//
//  ModalViewController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

public enum ModalViewLayout {
    case `default`, center, top, left, bottom, right
}

open class ModalViewController: UIViewController, UIViewControllerTransitioningDelegate {

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configInit()
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// ZJaDe:
    open lazy var presentationCon:PresentationController = PresentationController(presentedViewController: self, presenting: nil)

    open var modalViewLayout:ModalViewLayout {
        return .default
    }

    open func configInit() {
        self.presentationCon.modalViewLayout = self.modalViewLayout
        self.transitioningDelegate = self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        updatePreferredContentSize(traitCollection: self.traitCollection)
    }
    open override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        updatePreferredContentSize(traitCollection: newCollection)
    }
    open func updatePreferredContentSize(traitCollection: UITraitCollection) {
        
    }

    // MARK: - UIViewControllerTransitioningDelegate
    open func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        assert(self == presented, "presentedViewController错误")
        return self.presentationCon
    }
    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalAnimatedTransitioning(self.modalViewLayout, self.presentationCon.presentingViewController)
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ModalAnimatedTransitioning(self.modalViewLayout, self.presentationCon.presentingViewController)
    }

}
