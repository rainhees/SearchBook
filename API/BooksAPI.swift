//
//  BooksAPI.swift
//  SearchBook
//
//  Created by Kang on 2021/07/02.
//

import Foundation
import Alamofire

private let sessionManager: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .useProtocolCachePolicy //cache ignore
    configuration.timeoutIntervalForRequest = 180
    configuration.timeoutIntervalForResource = 30
    
    let mg = Alamofire.Session(configuration: configuration)
    
//    mg.retrier = RetryHandler()
    return mg
}()

protocol RequsetAPI: CanStopRequest {
    
    func requestSearchAPI(param:Parameters?, responsCallBack:@escaping (Data?)->Void, errorData:((Error)->Void)?)
    func requestDetailAPI(param:Parameters?, responsCallBack:@escaping (Data?)->Void, errorData:((Error)->Void)?)
}

extension RequsetAPI {
    
    // 기본 API 호출
    func APIRequest(_ apiString: String,
                     responsCallBack:@escaping (Data?)->Void,
                     errorData:((Error)->Void)? = nil){
        
        sessionManager.request(apiString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                               method: .get,
                               headers:nil).responseJSON { response in
            Swift.debugPrint("requestSearchAPI : \(response.request?.url?.absoluteString ?? "")")
            switch response.result{
            case .success:
                responsCallBack(response.data)
            case .failure(let error):
                errorData?(error)
            }
        }
        
    }
    
    // 검색 API 호출
    func requestSearchAPI(param:Parameters? = nil,
                          responsCallBack:@escaping (Data?)->Void,
                        errorData:((Error)->Void)? = nil){
        
        guard let keyword = param?["keyword"] as? String else {
            return
        }
        let maxSearch = 2
        let keyArr = keyword.replacingOccurrences(of: " ", with: "").split(separator: ",")
        let index = param?["page"] as? Int ?? 1
        
        var keyIndex = 0
        for key in keyArr {
            if keyIndex < maxSearch {
                let apiString = "https://api.itbook.store/1.0/search/\(key)/\(index)"
                APIRequest(apiString, responsCallBack: responsCallBack, errorData: errorData)
            }
            keyIndex += 1
        }
    }
    
    // 책 상세 API 호출
    func requestDetailAPI(param:Parameters? = nil,
                          responsCallBack:@escaping (Data?)->Void,
                          errorData:((Error)->Void)? = nil){
        
        
        guard let isbn13 = param?["isbn13"] else {
            return
        }
        let apiString = "https://api.itbook.store/1.0/books/\(isbn13)"
        APIRequest(apiString, responsCallBack: responsCallBack, errorData: errorData)
    }
}



protocol CanStopRequest {
    func stopRequestAPI()
}

extension CanStopRequest {
    func stopRequestAPI() {
        sessionManager.session.getTasksWithCompletionHandler{ (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach{ $0.cancel()}
        }
    }
}
