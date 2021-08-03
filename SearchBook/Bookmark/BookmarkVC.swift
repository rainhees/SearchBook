//
//  BookmarkVC.swift
//  SearchBook
//
//  Created by Kang on 2021/07/02.
//

import UIKit

class BookmarkVC: UIViewController {

    @IBOutlet var bookmarkCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        bookmarkCollection.register(BookCell.nib(), forCellWithReuseIdentifier: BookCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        bookmarkCollection.collectionViewLayout = layout
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookmarkCollection.reloadData()
    }

}

extension BookmarkVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BooksInfo.shared.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let cellWidth = (width - 20) / 2
        let cellHeight = cellWidth + 120
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell {
            if let bookData = BooksInfo.shared.bookmarks[safe:indexPath.row] {
                cell.setData(info: bookData)
                return cell
            }
            else{
                return UICollectionViewCell.init()
            }
        }
        else{
            return UICollectionViewCell.init()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let bookData = BooksInfo.shared.bookmarks[safe:indexPath.row] {
          
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            if let detail = storyBoard.instantiateViewController(withIdentifier: "Detail") as? DetailVC {
                
                detail.synopsis = bookData
                detail.bookmark = { isSelect in
                    BooksInfo.saveBookmarks(bookData, isSelect)
                    if isSelect == false {
                        collectionView.deleteItems(at: [indexPath])
                    }
                    
                }
                
                self.navigationController?.present(detail, animated: true, completion: {
                    print("completed")
                })
            }
        }
    }
}
