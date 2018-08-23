//
//  ViewController.swift
//  iOSAPM
//
//  Created by leoli on 2018/8/23.
//  Copyright © 2018 leoli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let button = UIButton.init(frame: CGRect.init(x: 40, y: 80, width: 200, height: 80))
        button.setTitle("拦截", for: .normal)
        button.addTarget(self, action: #selector(jump), for: .touchUpInside)
        button.backgroundColor = UIColor.blue

        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func jump() {
        let vc = URLViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

