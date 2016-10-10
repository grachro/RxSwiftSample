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

    @IBOutlet weak var lblResult1: UILabel!
    @IBOutlet weak var lblResult2: UILabel!

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
        
        let _ = TapQueue.instance.refreshServer //Observable<[String]>
            .map{$0.joinWithSeparator("\n")}
            .observeOn(MainScheduler.instance) //メインスレッド
            .bindTo(self.lblResult1.rx_text)
            .addDisposableTo(disposeBag)

        let _ = TapQueue.instance.refreshServer //Observable<[String]>
            .map{$0.map{"😄\($0)😄"}.joinWithSeparator("\n")}
            .observeOn(MainScheduler.instance)
            .bindTo(self.lblResult2.rx_text)
            .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

