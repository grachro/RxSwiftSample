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
    
    let _serverResult = PublishSubject<String>()
    var serverResult:Observable<String> {
        get {
            return _serverResult
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
            .subscribeNext{result in
                self._serverResult.onNext(result)
            }
            .addDisposableTo(disposeBag)
        
    }
    

    
}

class MockNetworkApi {

    class func add(numbers:[Int]) -> Observable<String> {
        
        let semaphore:dispatch_semaphore_t = dispatch_semaphore_create(0)
        print("api 1::\(numbers)")
        
        return Observable.create {observer in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let edited = "《" + numbers.map{String($0)}.joinWithSeparator("⚡️") + "》"
                NSThread.sleepForTimeInterval(3) //サーバに問い合わせて3秒かかった
                
                observer.onNext(edited)
                observer.onCompleted()
                
                dispatch_semaphore_signal(semaphore)
                print("api 2::\(numbers)")
                
            });
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
            print("api 3::\(numbers)")
            
            return NopDisposable.instance
        }
    }
}
