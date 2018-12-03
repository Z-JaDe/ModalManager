//
//  ModalViewController+ContentView.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/12/3.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

private var _centerContentViewKey: UInt8 = 0
extension ModalViewController {
    private var _centerContentView:UIView? {
        get {return objc_getAssociatedObject(self, &_centerContentViewKey) as? UIView}
        set {objc_setAssociatedObject(self, &_centerContentViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    /// ZJaDe: 调用时会 自动添加到self.view上面, 当内容尺寸不确定时可以使用这个，内容尺寸确定的话 直接使用self.view
    public var centerContentView: UIView {
        let centerContentView:UIView
        if let result = self._centerContentView {
            centerContentView = result
        }else {
            centerContentView = UIView()
            _centerContentView = centerContentView
        }
        if centerContentView.superview != self.view {
            self.view.addSubview(centerContentView)
            centerContentViewLayout()
        }
        return centerContentView
    }
    private func centerContentViewLayout() {
        guard let centerContentView = self._centerContentView else {
            return
        }
        centerContentView.translatesAutoresizingMaskIntoConstraints = false
        var constraintArr:[NSLayoutConstraint] = []
        constraintArr.append(centerContentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
        constraintArr.append(centerContentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))
        constraintArr.append(centerContentView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor))
        constraintArr.append(centerContentView.leftAnchor.constraint(greaterThanOrEqualTo: self.view.leftAnchor))
        NSLayoutConstraint.activate(constraintArr)
    }
}
