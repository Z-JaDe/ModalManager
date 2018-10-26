//
//  FadePresentationController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

open class FadePresentationController: PresentationController {
    public var fadeAnimationOptions: ModalFadeAnimationOptions = .bottom

    open override func createPresentationWrappingView() -> PresentationController.PresentationWrappingView {
        let view = super.createPresentationWrappingView()
        switch self.fadeAnimationOptions {
        case .fill:
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

    open override func presentedViewFrame(_ containerViewBounds: CGRect, _ presentedViewContentSize: CGSize) -> CGRect {
        var result = containerViewBounds
        result.size = presentedViewContentSize
        var x = (containerViewBounds.width - result.width) / 2
        var y = (containerViewBounds.height - result.height) / 2
        switch self.fadeAnimationOptions {
        case .top:
            y = 0
        case .bottom:
            y = containerViewBounds.maxY - result.height
        case .left:
            x = 0
        case .right:
            x = containerViewBounds.maxX - result.width
        case .center, .fill: break
        }
        result.origin = CGPoint(x: x, y: y)
        return result
    }
}
