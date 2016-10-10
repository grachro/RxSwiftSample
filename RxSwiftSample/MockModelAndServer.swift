//
//  Network.swift
//  RxSwiftSample
//
//  Created by grachro on 2016/10/09.
//  Copyright © 2016年 grachro. All rights reserved.
//

import Foundation
import RxSwift

class TapQueue {
    
    static let instance = TapQueue()
    
    private let disposeBag = DisposeBag()
    private let _queue = PublishSubject<Int>()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
    
    
    let _refreshServer = PublishSubject<[String]>()

    var refreshServer:Observable<[String]> {
        get {
            return _refreshServer
        }
    }

    
    private init () {
        _queue
            .observeOn(backgroundScheduler)
            .buffer(timeSpan: 0.1, count: 10, scheduler: backgroundScheduler)
            .filter{numbers in numbers.count > 0}
            .flatMap{numbers in
                MockNetworkApi.add(numbers)
            }
            .doOn{items in
                print("  doOn items [\(items)]")
            }
            .subscribeNext{allText in
                self._refreshServer.onNext(allText)
            }
            .addDisposableTo(disposeBag)
        
    }
    
    func add(number:Int) {
        print("mein \(number) tapped")
        self._queue.onNext(number)
    }
    
}


class MockNetworkApi {
    class func add(numbers:[Int]) -> Observable<[String]> {
        return Observable.create {observer in
            
            print("  back \(numbers)  network start")
            
            let items = MockServer.addAndGet(addNumbers:numbers)
            
            NSThread.sleepForTimeInterval(3) //サーバに問い合わせて3秒かかった
            print("  back \(numbers)  network end")
            
            observer.onNext(items)
            observer.onCompleted()
            
            
            //observer.onError()は省略
            return NopDisposable.instance
        }
    }
}




class MockServer {
    static var allText:[String] = []
    class func addAndGet(addNumbers addNumbers:[Int]) -> [String] {
        let j = addNumbers.map{String($0)}.joinWithSeparator(",")
        allText.append("[\(j)]")
        return allText
    }
}
