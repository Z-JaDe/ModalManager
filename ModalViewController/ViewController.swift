//
//  ViewController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.present(_ModalViewController(), animated: true, completion: nil)
    }


}

class _ModalViewController: ModalViewController {
    override var modalViewLayout: ModalViewLayout {
        return .center
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
    override func updatePreferredContentSize(traitCollection: UITraitCollection) {
        super.updatePreferredContentSize(traitCollection: traitCollection)
        self.preferredContentSize = CGSize(width: 50, height: 50)
    }
}
