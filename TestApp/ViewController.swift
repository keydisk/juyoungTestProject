//
//  ViewController.swift
//  TestApp
//
//  Created by Ethan's MacBook on 2020/11/09.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
    }


}

