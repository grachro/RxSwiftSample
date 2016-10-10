//
//  TapQueue.swift
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
    
    let _refreshServer = PublishSubject<[String]>()
    var refreshServer:Observable<[String]> {
        get {
            return _refreshServer
        }
    }

    
    private let _queue = PublishSubject<Int>()
    private let background = ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
    
    func add(number:Int) {
        print("mein \(number) tapped") //debug print
        self._queue.onNext(number)
    }

    private init () {
        
        self._queue
            .observeOn(background)
            .buffer(timeSpan: 0.1, count: 10, scheduler: background)
            .filter{numbers in numbers.count > 0}
            .flatMap{numbers in
                MockNetworkApi.add(numbers)
            }
            .doOn{items in
                print("  doOn items [\(items)]") //debug print
            }
            .subscribeNext{allText in
                self._refreshServer.onNext(allText)
            }
            .addDisposableTo(disposeBag)
        
    }
    

    
}


class MockNetworkApi {
    class func add(numbers:[Int]) -> Observable<[String]> {
        return Observable.create {observer in
            
            print("  back \(numbers)  network start")
            let allText = MockServer.addAndGet(addNumbers:numbers)
            NSThread.sleepForTimeInterval(3) //サーバに問い合わせて3秒かかった
            print("  back \(numbers)  network end")
            
            observer.onNext(allText)
            observer.onCompleted()
            
            
            //observer.onError()は省略
            return NopDisposable.instance
        }
    }
}




class MockServer {
    static var allText:[String] = []
    class func addAndGet(addNumbers addNumbers:[Int]) -> [String] {
        let j = addNumbers.map{String($0)}.joinWithSeparator("⚡️")
        allText.append("《\(j)》")
        allText =  ([String])(allText.suffix(5))
        return allText
    }
}
