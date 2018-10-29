//
//  ViewController.swift
//  ModalViewController
//
//  Created by 郑军铎 on 2018/10/26.
//  Copyright © 2018 zjade. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ModalContainerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.yellow
        let modal = _ModalViewController()
//        self.present(modal, animated: true, completion: nil)
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            self.navigationController?.pushViewController(ViewController(), animated: true)
//        }
        self.show(modal)
    }
}

class _ModalViewController: ModalViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
    }
    override func updatePreferredContentSize(traitCollection: UITraitCollection) {
        self.preferredContentSize = CGSize(width: 50, height: 50)
    }
}
