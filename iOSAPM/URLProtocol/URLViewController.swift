//
//  URLViewController.swift
//  iOSAPM
//
//  Created by leoli on 2018/8/23.
//  Copyright © 2018 leoli. All rights reserved.
//

import UIKit
import Alamofire

class URLViewController: UIViewController {

    var manager: SessionManager = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [CustomURLProtocol.self]
            configuration.httpAdditionalHeaders = ["Session-Configuration-Header": "nimei"]

            return configuration
        }()

        return SessionManager(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        test()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func test() {
        let urlString = "https://exchangeratesapi.io/api/latest?base=USD&symbols=CNY"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.setValue("nimei", forHTTPHeaderField: "Request-Header")

        manager.request(urlRequest).response { (resp) in
            print(resp)
        }
    }
}
