//
//  File.swift
//  SearchBook
//
//  Created by Kang on 2021/08/03.
//

import Foundation

class SearchVM: NSObject{
    
    //검색책정보
    var searchBooks: [Books] = []
    
    var pageIndex: Int = 1
    //최근검색화면, 책목록화면
    var searching: Bool = false
    
    //검색 처리
    var processing: Bool = false
    //마지막 api 호출
    var notmoreData: Bool = false
    
    var showError:(()->Void)?
    var responseBooks:(()->Void)?
    
    
    override init() {
    }
}

extension SearchVM: RequsetAPI {
    
    
    func requestMore(_ keyword: String)
    {
        guard processing == false else {
            return
        }
        guard  notmoreData == false else {
            return
        }
        processing = true
        
        self.pageIndex += 1
        
        request(keyword)
    }
    func request(_ keyword: String){
        self.requestSearchAPI(param: ["keyword":keyword, "page":self.pageIndex]) { response in
            if let booksData = response {
                if let booksResult = try? JSONDecoder().decode(ResponseBook.self, from: booksData) {
                    let books = booksResult.books
                    self.searching = true
                    self.searchBooks.append(contentsOf: books)
                    self.responseBooks?()
                    if books.count == 0 {
                        self.notmoreData = true
                    }
                }
            }
            else{
                self.showError?()
            }
            self.processing = false
        } errorData: { error in
            print(error)
            
        }

    }
}
