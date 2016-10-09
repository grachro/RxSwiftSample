//
//  ViewController.swift
//  RxSwiftSample
//
//  Created by grachro on 2016/10/08.
//  Copyright © 2016年 grachro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class ViewController: UIViewController {

    
    @IBOutlet weak var btnA: UIButton!
    @IBOutlet weak var btnB: UIButton!
    @IBOutlet weak var btnC: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnA.rx_tap
            .subscribeNext { [unowned self] _ in
                self.tappedBtn("a")
            }
            .addDisposableTo(disposeBag)
        
        btnB.rx_tap
            .subscribeNext { [unowned self] _ in
                self.tappedBtn("b")
            }
            .addDisposableTo(disposeBag)
        
        
        btnC.rx_tap
            .subscribeNext { [unowned self] _ in
                self.tappedBtn("c")
            }
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedBtn(name:String) {
        TapQueue.instance.add(name)
        print("mein \(name) tapped")
    }

}

