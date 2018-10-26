//
//  FadeModalViewController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

public enum ModalFadeAnimationOptions {
    case fill, center, top, left, bottom, right
}
open class FadeModalViewController: ModalViewController {
    open var fadeAnimationOptions:ModalFadeAnimationOptions {
        return .fill
    }
    open override func createPresentationCon(presenting presentingViewController: UIViewController?) -> PresentationController {
        let viewCon = FadePresentationController(presentedViewController: self, presenting: presentingViewController)
        viewCon.fadeAnimationOptions = self.fadeAnimationOptions
        return viewCon
    }
    open override func createModalAnimatedTransitioning() -> ModalAnimatedTransitioning {
        return FadeModalAnimatedTransitioning(self.fadeAnimationOptions, self.presentationCon.presentingViewController)
    }
}
