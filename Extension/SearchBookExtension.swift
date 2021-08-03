//
//  SearchBookExtension.swift
//  SearchBook
//  https://github.com/rainhees/Extension
//
//  Created by Kang on 2021/07/02.
//

import UIKit
import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}


extension UILabel {
    /**
     
     uilabel 에 이미지 입력
     이미지 | 라벨 텍스트
     @param image name :String
     @returns uilabel : UILabel
     @exception <#throws#>
     */
    func addImage(_ imageName: String)
        //    {
        //        self.addImage(imageName, CGPoint(x: 0, y: -3))
        //    }
        //    func addImage(_ imageName: String, _ margin:CGPoint)
    {
        
        //image NSTextAttachment설정
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        
        let centerY = -(attachment.image?.size.height)!/2 - self.font.descender
        
        attachment.bounds = CGRect(x: 0, y: centerY, width: (attachment.image?.size.width)!, height: (attachment.image?.size.height)!)
        
        //NSTextAttachment NSAttributedString설정
        let attachmentString = NSAttributedString(attachment: attachment)
        
        //기존 라벨의 문자열
        let lableString = NSAttributedString(string: " \(self.text!)")
        
        //mutableatrributestring 생성
        let fullString = NSMutableAttributedString()
        fullString.append(attachmentString)
        fullString.append(lableString)
        
        self.attributedText = fullString
    }
    
    /**
     
     uilabel의 텍스트이 행간 간격 조절
     @param 행간 간격 : CGFloat
     @returns uilabel:UILabel
     @exception <#throws#>
     */
    
    func addLineSpacing(_ space:CGFloat) {
        if let textString = text {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = space
            
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}


extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
    
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }

        return arrayOrdered
    }
    
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
        // iOS 8 or earlier
        // return startIndex <= index && index < endIndex ? self[index] : nil
        // return 0 <= index && index < self.count ? self[index] : nil
    }
}



extension UICollectionViewCell {
    
    static func nib(isSmall: Bool = false) -> UINib? {
        
        let className = self.classForCoder().description()
        guard let nibName = className.components(separatedBy: ".").last else {
            return nil
        }
        return UINib(nibName: nibName, bundle: nil)
    }
    
}

extension UIStackView {
    //https://gist.github.com/Deub27/5eadbf1b77ce28abd9b630eadb95c1e2
    func safelyRemoveArrangedSubviews() {

        // Remove all the arranged subviews and save them to an array
        let removedSubviews = arrangedSubviews.reduce([]) { (sum, next) -> [UIView] in
            self.removeArrangedSubview(next)
            return sum + [next]
        }

        // Deactive all constraints at once
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
