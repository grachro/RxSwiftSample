//
//  Network.swift
//  RxSwiftSample
//
//  Created by grachro on 2016/10/09.
//  Copyright © 2016年 grachro. All rights reserved.
//

import Foundation
import RxSwift

class Item: CustomStringConvertible  {
    let name:String
    var count:Int = 1
    init(name:String) {self.name = name}
    var description: String { return "Item(\(name),\(count))" }
}

class TapQueue {
    
    static let instance = TapQueue()
    
    private let disposeBag = DisposeBag()
    private let _queue = PublishSubject<String>()
    private let backgroundScheduler = ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Background)
    
    private init () {
        _queue
            .observeOn(backgroundScheduler)
            .buffer(timeSpan: 0.1, count: 10, scheduler: backgroundScheduler)
            .filter{items in items.count > 0}
            .flatMap{names in
                MockNetworkApi.add(names)
            }
            .subscribeNext{items in
                print("  finish items [\(items)]")
            }
            .addDisposableTo(disposeBag)
    }
    
    func add(name:String) {
        self._queue.onNext(name)
    }
    
}


class MockNetworkApi {
    class func add(names:[String]) -> Observable<[Item]> {
        return Observable.create {observer in
            
            print("  back \(names)  network start")
            
            let items = MockServer.addAndGet(addNames:names)
            
            NSThread.sleepForTimeInterval(3) //サーバに問い合わせて3秒かかった
            print("  back \(names)  network end")
            
            observer.onNext(items)
            observer.onCompleted()
            
            
            //observer.onError()は省略
            return NopDisposable.instance
        }
    }
}




class MockServer {
    static var items:[Item] = []
    class func addAndGet(addNames addNames:[String]) -> [Item] {
        
        addNames.forEach{addName in
            let item:Item? = items.filter{$0.name == addName}.first
            if let item = item {
                item.count += 1
            } else {
                items.append(Item(name:addName))
            }
        }
        
        
        return items
    }
}
