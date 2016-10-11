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

    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    
    @IBOutlet weak var btnClear: UIButton!

    @IBOutlet weak var lblResult: UILabel!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btn1.rx_tap
            .subscribeNext {
                TapQueue.instance.add(1)
            }
            .addDisposableTo(disposeBag)
        
        btn2.rx_tap
            .subscribeNext {
                TapQueue.instance.add(2)
            }
            .addDisposableTo(disposeBag)
        
        btn3.rx_tap
            .subscribeNext {
                TapQueue.instance.add(3)
            }
            .addDisposableTo(disposeBag)
        
        let _ = TapQueue.instance.serverResult
            .map{(self.lblResult.text ?? "") + "😄\($0)😄\n"}
            .observeOn(MainScheduler.instance)
            .bindTo(self.lblResult.rx_text)
            .addDisposableTo(disposeBag)
        
        btnClear.rx_tap
            .map{""}
            .bindTo(self.lblResult.rx_text)
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

