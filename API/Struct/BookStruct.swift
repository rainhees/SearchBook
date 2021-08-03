//
//  BookStruct.swift
//  SearchBook
//
//  Created by Kang on 2021/07/04.
//

import Foundation

struct ResponseBook: Codable {
    let error : String
    let total : String
    let page : String
    let books : [Books]
}

struct Books: Codable, Equatable {
    let title: String?
    let subtitle: String?
    let isbn13: String?
    let price: String?
    let image: String?
    let url: String?
    
    static func ==(lhs: Books, rhs: Books) -> Bool {
        return lhs.isbn13 == rhs.isbn13
    }

}

struct BookDetail: Codable {
    let error: String
    let title: String?
    let subtitle: String?
    let isbn13: String?
    let price: String?
    let image: String?
    let url: String?
    
    let authors: String?
    let publisher: String?
    let language: String?
    let isbn10: String?
    let pages: String?
    let year: String?
    let rating: String?
    let desc: String?
    
}

extension Encodable {
    func hasKey(for path: String) -> Bool {
        return Mirror(reflecting: self).children.contains { $0.label == path }
    }
    func value(for path: String) -> Any? {
        return Mirror(reflecting: self).children.first {
            $0.label == path
        }?.value
    }
}
