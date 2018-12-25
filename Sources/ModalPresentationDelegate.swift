//
//  ModalPresentationDelegate.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/27.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

public protocol ModalPresentationDelegate: class {
    func config(wrappingView: PresentationController.WrappingView)
    func config(dimmingView: PresentationController.DimmingView)
    /// ZJaDe: 计算 presentedView frame
    func presentedViewFrame(_ containerViewBounds: CGRect, _ presentedViewContentSize: CGSize) -> CGRect

    func presentationTransitionWillBegin()
    func presentationTransitionDidEnd(_ completed: Bool)
    func dismissalTransitionWillBegin()
    func dismissalTransitionDidEnd(_ completed: Bool)
}
