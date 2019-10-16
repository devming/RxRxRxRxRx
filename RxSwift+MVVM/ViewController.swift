//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import RxSwift
import SwiftyJSON
import UIKit

let MEMBER_LIST_URL = "https://my.api.mockaroo.com/members_with_avatar.json?key=44ce18f0"

/// 4. 나중에 생기는 데이터는 어떻게 정의된걸까?

class ViewController: UIViewController {
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var editView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.timerLabel.text = "\(Date().timeIntervalSince1970)"
        }
    }

    private func setVisibleWithAnimation(_ v: UIView?, _ s: Bool) {
        guard let v = v else { return }
        UIView.animate(withDuration: 0.3, animations: { [weak v] in
            v?.isHidden = !s
        }, completion: { [weak self] _ in
            self?.view.layoutIfNeeded()
        })
    }

    // MARK: SYNC

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBAction func onLoad() {
        editView.text = ""
        setVisibleWithAnimation(activityIndicator, true)

//        /// 2. 여기는 어떻게?
//        self.editView.text = getJson()
        
//      ->
        
        /// 3. 나중에 생기는 데이터 처리
//        let 나중에생기는데이터 = getJsonAsync()
//
//        나중에생기는데이터.오겠지 { json in
//            // 처리
//            DispatchQueue.main.async {
//                self.editView.text = json
//
//                self.setVisibleWithAnimation(self.activityIndicator, false)
//            }
//        }
        
        let ob = getJsonRx()
        
        _ = ob
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (json) in
                self.editView.text = json
                self.setVisibleWithAnimation(self.activityIndicator, false)
            })

//        getJson { json in
//            DispatchQueue.main.async {
//                self.editView.text = json
//            }
//        }
        /// 비동기를 처리하는 좀 더 깔끔한 방식이 없을까?
    }
    
//    func getJson(_ onCompleted: @escaping (String) -> Void) {
//
//        DispatchQueue.global().async {
//            let url = URL(string: MEMBER_LIST_URL)!
//            let data = try! Data(contentsOf: url)
//            let json = String(data: data, encoding: .utf8)!
//            onCompleted(json)  /// 1. 이렇게 해결!
//
//        }
//    }
    
//    func getJsonAsync() -> AsyncResult<String>
//    func getJsonAsync() -> 나중에생기는데이터 {
//        return 나중에생기는데이터() { f in
//            let url = URL(string: MEMBER_LIST_URL)!
//            let data = try! Data(contentsOf: url)
//            let json = String(data: data, encoding: .utf8)!
//            f(json)
//        }
//    }
    
    func getJsonRx() -> Observable<String> {
        return Observable.create { f in
            let url = URL(string: MEMBER_LIST_URL)!
            let data = try! Data(contentsOf: url)
            let json = String(data: data, encoding: .utf8)!
            f.onNext(json)
            return Disposables.create()
        }
    }
}

//class 나중에생기는데이터 {
//    let job: (@escaping (String) -> Void) -> Void
//    init(_ job: @escaping (@escaping (String) -> Void) -> Void) {
//        self.job = job
//    }
//
//    func 오겠지(_ f: @escaping (String) -> Void) {
//        DispatchQueue.global().async {
//            self.job(f)
//        }
//    }
//}
