//
//  ModalViewController+ContentView.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/12/3.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

class ModalRootView: UIView {
    private var _centerContentView: UIView?

    var centerContentView: UIView {
        let centerContentView: UIView
        if let result = _centerContentView {
            centerContentView = result
        } else {
            centerContentView = UIView()
            _centerContentView = centerContentView
        }
        if centerContentView.superview != self {
            self.addSubview(centerContentView)
            centerContentViewLayout()
        }
        return centerContentView
    }
    private func centerContentViewLayout() {
        guard let centerContentView = _centerContentView else {
            return
        }
        centerContentView.translatesAutoresizingMaskIntoConstraints = false
        var constraintArr: [NSLayoutConstraint] = []
        constraintArr.append(centerContentView.centerXAnchor.constraint(equalTo: self.centerXAnchor))
        constraintArr.append(centerContentView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraintArr.append(centerContentView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor))
        constraintArr.append(centerContentView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor))
        NSLayoutConstraint.activate(constraintArr)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        guard let view = result, _centerContentView != nil else {
            return result
        }
        if view == self {
            return nil
        }
        return result
//        if view == _centerContentView {
//            return view
//        }
//        if view.isSubView(centerContentView) {
//            return view
//        }
//        return nil
    }
}

extension ModalViewController {
    /// ZJaDe: 调用时会 自动添加到self.view上面, 当内容尺寸不确定时可以使用这个，内容尺寸确定的话 直接使用self.view同时可以重写contentViewHeight;
    public var centerContentView: UIView {
        // swiftlint:disable force_cast
        return (self.view as! ModalRootView).centerContentView
    }
}

//extension UIView {
//    func isSubView(_ view: UIView) -> Bool {
//        guard let superview = self.superview else {
//            return false
//        }
//        if superview == view {
//            return true
//        } else {
//            return superview.isSubView(view)
//        }
//    }
//}
