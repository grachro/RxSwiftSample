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

    @IBOutlet weak var lblResult1: UILabel!
    @IBOutlet weak var lblResult2: UILabel!

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnA.rx_tap
            .subscribeNext { [unowned self] _ in
                self.tappedBtn(1)
            }
            .addDisposableTo(disposeBag)
        
        btnB.rx_tap
            .subscribeNext { [unowned self] _ in
                self.tappedBtn(2)
            }
            .addDisposableTo(disposeBag)
        
        
        btnC.rx_tap
            .subscribeNext { [unowned self] _ in
                self.tappedBtn(3)
            }
            .addDisposableTo(disposeBag)
        
        
        
        let _ = TapQueue.instance.refreshServer //Observable<[String]>
            .observeOn(MainScheduler.instance)
            .subscribeNext{allText in
                let s = allText.joinWithSeparator("\n")
                self.lblResult1.text = s
            }
            .addDisposableTo(disposeBag)
        
        
        let _ = TapQueue.instance.refreshServer //Observable<[String]>
            .observeOn(MainScheduler.instance)
            .subscribeNext{allText in
                let s = allText.reverse().joinWithSeparator("\n")
                self.lblResult2.text = s
            }
            .addDisposableTo(disposeBag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tappedBtn(number:Int) {
        TapQueue.instance.add(number)
    }

}

