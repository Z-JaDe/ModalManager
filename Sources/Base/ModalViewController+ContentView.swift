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
        guard let centerContentView = _centerContentView else { return }
        centerContentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerContentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            centerContentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            centerContentView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            centerContentView.leftAnchor.constraint(greaterThanOrEqualTo: self.leftAnchor)
            ])
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let result = super.hitTest(point, with: event)
        guard let view = result, _centerContentView != nil else { return result }
        if view == self { return nil }
        return result
    }
}

extension ModalViewController {
    /// ZJaDe: 调用时会 自动添加到self.view上面, 当内容尺寸不确定时可以使用这个，内容尺寸确定的话 直接使用self.view同时可以重写contentViewHeight;
    public var centerContentView: UIView {
        // swiftlint:disable force_cast
        return (self.view as! ModalRootView).centerContentView
    }
}
