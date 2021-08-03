//
//  BookCell.swift
//  SearchBook
//
//  Created by Kang on 2021/07/02.
//

import UIKit
import SDWebImage

class BookCell: UICollectionViewCell {
    
    static let identifier = "BookCell"
    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookinfoStack: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(info:Books) {
        
        if let imageUrl = info.image{
            if let url = URL(string: imageUrl) {
                bookImage.sd_setImage(with: url, completed: nil)
            }
        }
        
        var bookText:[String] = []
        if let title = info.title, title.count > 0 {
            bookText.append(title)
        }
        if let subtitle = info.subtitle, subtitle.count > 0 {
            bookText.append(subtitle)
        }
        if let isbn13 = info.isbn13, isbn13.count > 0 {
            bookText.append(isbn13)
        }
        if let price = info.price, price.count > 0 {
            bookText.append(price)
        }
        
        if bookText.count > 0 {
            insertInfo(bookText)
        }
    }
    
    func insertInfo(_ bookText:[String]){
        
        for text in bookText {
            let label = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 0))
            
            
            label.font = UIFont.systemFont(ofSize: 15)
            label.text = text
            label.sizeToFit()
            bookinfoStack.addArrangedSubview(label)
        }
    }
    
    override func prepareForReuse() {
        bookImage.image = nil
        bookinfoStack.safelyRemoveArrangedSubviews()
        
        super.prepareForReuse()
    }
    
    
}
