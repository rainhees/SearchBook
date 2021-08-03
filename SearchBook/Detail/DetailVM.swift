//
//  DetailVM.swift
//  SearchBook
//
//  Created by Kang on 2021/08/03.
//

import Foundation

class DetailVM: NSObject {
    
    //API호출 동기화 체크
    var completed:Bool = false
    
    //미리보기용으로 사용할 수 있는 정보
    var isSelect: Bool = false
    //책 상세정보
    var bookDetail: BookDetail?
    
    var requestComplete:(()->Void)?
    
    init(_ synopsis:Books?) {
        super.init()
        
        if let isbn13 = synopsis?.isbn13, isbn13.count > 0 {
            isSelect = BooksInfo.findISBN13(isbn13)
            request(isbn13)
        }
    }
}

extension DetailVM: RequsetAPI {
    
    func request(_ isbn13: String){
        self.requestDetailAPI(param: ["isbn13": isbn13 ]) { response in
            if let detailData = response {
                if let bookDetail = try? JSONDecoder().decode(BookDetail.self, from: detailData) {
                    self.bookDetail = bookDetail
                    self.requestComplete?()
                }
            }
        }
    }
}

