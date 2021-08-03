//
//  DetailVC.swift
//  SearchBook
//
//  Created by Kang on 2021/07/03.
//

import UIKit

class DetailVC: UIViewController {
    
    //책 상세 내역 정보 순서
    let viewList:[String] = ["title", "subtitle", "price" ,"authors", "publisher", "language" , "year", "rating","desc"]
    
    @IBOutlet var bookImage: UIImageView!
    @IBOutlet var bookInfoTable: UITableView!
    @IBOutlet var bookmartButton: UIButton!
    
    
    var synopsis: Books?
    var detailVM: DetailVM?
    
    //북마크
    var bookmark: ((Bool)-> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailVM = DetailVM(synopsis)
        bookmartButton.isSelected = detailVM?.isSelect ?? false
        detailVM?.requestComplete = {
            if let imageUrl = self.detailVM?.bookDetail?.image{
                if let url = URL(string: imageUrl) {
                    self.bookImage.sd_setImage(with: url, completed: nil)
                    self.bookInfoTable.reloadData()
                }
            }
        }
    }
    
    @IBAction func selectBookmark(_ sender: Any) {
        bookmartButton.isSelected = !bookmartButton.isSelected
        self.bookmark?(bookmartButton.isSelected)
    }

}


extension DetailVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "cell")
        
        if let key = viewList[safe:indexPath.row] {
            if let value = detailVM?.bookDetail?.value(for: key) as? String{
                cell.textLabel?.text = key
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = value
                cell.detailTextLabel?.numberOfLines = 0
            }
        }
        
        return cell
    }

}
