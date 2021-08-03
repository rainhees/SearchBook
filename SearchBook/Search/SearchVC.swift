//
//  SearchVC.swift
//  SearchBook
//
//  Created by Kang on 2021/07/02.
//

import UIKit

class SearchVC: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    //더보기 페이지 인덱스
    var searchVM: SearchVM = SearchVM()
    var bookKeyword:String = ""
    
    @IBOutlet var recentTable: UITableView!
    @IBOutlet var bookCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookCollection.register(BookCell.nib(), forCellWithReuseIdentifier: BookCell.identifier)
        bookCollection.isHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        bookCollection.collectionViewLayout = layout
        
        searchVM.showError = {
            let alert = UIAlertController(title: "알림" , message: "데이터 없음" , preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: {_ in
                self.resetView()
            })
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        searchVM.responseBooks = {
            self.bookCollection.isHidden = false
    //
            self.bookCollection.reloadData()
        }
    }
    
    func updateSearchKeyWord(_ keyword:String){
        
        if keyword.count > 0 {
            
            searchVM.pageIndex = 1
            searchVM.notmoreData = false
            
            searchBar.text = keyword
            requestKeyword(keyword)
            recentTable.isHidden = true
            
            BooksInfo.saveKeyword(keyword)
            recentTable.reloadData()
        }
        
        
    }
        
    func requestKeyword(_ keyword: String){
        bookKeyword = keyword
        searchVM.request(keyword)
    }
    
    func resetView(){
        
        searchVM.searching = false
        searchVM.notmoreData = false
        searchVM.processing = false
        
        recentTable.reloadData()
        recentTable.isHidden = false
        
        bookCollection.scrollToItem(at: IndexPath(row: 0, section: 0),at: .top, animated: true)
        bookCollection.isHidden = true
        
        searchVM.searchBooks.removeAll()
        searchVM.pageIndex = 1
        
        bookCollection.reloadData()
        
    }
    
    

}

extension SearchVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.becomeFirstResponder()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        updateSearchKeyWord(searchBar.text ?? "")
        self.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resetView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            resetView()
        }
    }
}


extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return searchVM.searching ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BooksInfo.shared.bookKeywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = BooksInfo.shared.bookKeywords[safe:indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let keyword = BooksInfo.shared.bookKeywords[safe:indexPath.row] {
            if keyword.count > 0 {
                updateSearchKeyWord(keyword)
                bookKeyword = keyword
                self.searchBar.endEditing(true)
            }
        }
    }
    
}

extension SearchVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searchVM.searching ? 1 : 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchVM.searchBooks.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let cellWidth = (width - 20) / 2
        let cellHeight = cellWidth + 120
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.identifier, for: indexPath) as? BookCell {
            if let bookData = searchVM.searchBooks[safe:indexPath.row] {
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
        if let bookData = searchVM.searchBooks[safe:indexPath.row] {
          
            let storyBoard = UIStoryboard(name: "Detail", bundle: nil)
            if let detail = storyBoard.instantiateViewController(withIdentifier: "Detail") as? DetailVC {
                
                detail.synopsis = bookData
                detail.bookmark = { isSelect in
                    BooksInfo.saveBookmarks(bookData, isSelect)
                }
                
                self.navigationController?.present(detail, animated: true, completion: {
                    print("completed")
                })
            }
        }
    }
    
}



extension SearchVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        self.searchBar.endEditing(true)
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height
        {
            if bookKeyword.count > 0 {
                searchVM.requestMore(bookKeyword)
            }
        }
    }
}
