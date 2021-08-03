//
//  File.swift
//  SearchBook
//
//  Created by Kang on 2021/08/03.
//

import Foundation

class BooksInfo {
    static let shared = BooksInfo()

    static let MaXKeyWorkd = 10
    var bookmarks:[Books] = []
    var bookKeywords:[String] = []
    
    var count: Int {
        return bookmarks.count
    }
    
    func contains(_ book:Books)-> Bool{
        return self.bookmarks.contains(book)
    }
    
    
    func contains(isbn13:String)-> Bool{
        return self.bookmarks.contains(where: {$0.isbn13 == isbn13})
    }
    
    
    func append(_ book:Books){
        bookmarks.append(book)
    }
    
    func firstIndex(of book:Books) -> Int?{
        return bookmarks.firstIndex(of: book)
    }
    
    func firstIndex(keyword:String) -> Int?{
        return bookKeywords.firstIndex(of: keyword)
    }
    
    func insert(keyword:String){
        bookKeywords.insert(keyword, at: 0)
    }
    
    func remove(at index:Int){
        bookmarks.remove(at: index)
    }
    
    func remove(keywordIndex:Int){
        bookKeywords.remove(at: keywordIndex)
    }
    
    func removeLast(){
        bookKeywords.removeLast()
    }
    
    func maxcheck()->Bool {
        return bookKeywords.count > BooksInfo.MaXKeyWorkd ? true : false
    }
    
    
    class func saveBookmarks(_ book:Books, _ isSelect:Bool = true){
        if isSelect {
            if BooksInfo.shared.contains(book) {
                
            }
            else{
                BooksInfo.shared.append(book)
            }
        }
        else{
            if BooksInfo.shared.contains(book) {
                if let index = BooksInfo.shared.firstIndex(of: book) {
                    BooksInfo.shared.remove(at: index)
                }
            }
            else{
                
            }
        }
        
    }
    
    class func findISBN13(_ isbn13:String) -> Bool{
        if BooksInfo.shared.contains(isbn13:isbn13) {
            return true
        }
        else{
            return false
        }
    }
    
    class func saveKeyword(_ word:String){
        if let index = BooksInfo.shared.firstIndex(keyword: word){
            BooksInfo.shared.remove(keywordIndex: index)
        }
        
        if word.count > 0 {
            
            BooksInfo.shared.insert(keyword: word)
        }
        
        func maxCheck(){
            
            if BooksInfo.shared.maxcheck(){
                BooksInfo.shared.removeLast()
                maxCheck()
            }
        }
        maxCheck()
    }
}

