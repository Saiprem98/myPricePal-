//
//  ItemViewController.swift
//  MyPricePal
//
//  Created by Brice Redmond on 4/19/19.
//  Copyright © 2019 CS48. All rights reserved.
//

import UIKit
import Anchors
import SafariServices


protocol ItemViewDismissalDelegate : class {
    func itemViewDidDismiss(_ controller: ItemViewController)
} 

class ItemViewController: UITableViewController {
    var image = UIImage(named: "imageC.jpg")
    var items: [String] = ["Costco: ","Walmart: ", "Amazon: ", "Albertsons: "]
//    var itemImages: [UIImage] = [UIImage(named: "costco")!,UIImage(named: "WalmartLogo")!,UIImage(named: "AmazonLogo")!,UIImage(named: "AlbertsonsLogo")!]

//    var imageView = UIImageView {
//        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
//        imageView.image = UIImage(named: "imageC.jpg")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    public weak var dismissalDelegate: ItemViewDismissalDelegate?
//    public let textView = UITextView(frame: .zero)
    var itemN: String? {
        didSet {
            self.titleLabel.text = itemN
        }
    }

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .black
        label.sizeToFit()
        return label
    }()

    @objc func dismissalAction(sender: Any) {
        dismissalDelegate?.itemViewDidDismiss(self)
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        let backBarButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissalAction(sender:)))
        navigationItem.leftBarButtonItem = backBarButton
<<<<<<< HEAD
        navigationItem.titleView = titleLabel
        
=======
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    override func viewDidLoad() {
>>>>>>> 06b4352bbe1e5e982a41ecf62813a28fe7671787
        tableView.register(ItemViewItemCell.self, forCellReuseIdentifier: "itemCellId")
        tableView.register(ItemViewHeader.self, forHeaderFooterViewReuseIdentifier: "itemHeaderId")
        
        tableView.sectionHeaderHeight = 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func showSafariVC(for url: String){
        guard let url = URL(string: url)else{
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row==0{
            let urlBase = "https://www.costco.com/CatalogSearch?dept=All&keyword="
            guard let item = itemN?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) else { return}
            showSafariVC(for: urlBase + item)
        }
        if indexPath.row == 1{
            //URl is hard to manipulate
            
        }
        if indexPath.row == 2{
            let urlBase = "https://www.amazon.com/s?k="
            let urlEnd = "&i=grocery&crid=1RQ40Q09MZBMW&sprefix=5+gum%2Caps%2C189&ref=nb_sb_ss_c_2_5"
            guard let item = itemN?.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil) else { return}
            showSafariVC(for: urlBase + item + urlEnd)
        }
        if indexPath.row == 3{
            //URl is hard to manipulate
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemCell = tableView.dequeueReusableCell(withIdentifier: "itemCellId", for: indexPath) as! ItemViewItemCell
        
        itemCell.nameLabel.text = items[indexPath.row]
 //       itemCell.logo.image = itemImages[indexPath.row]
//        itemCell.logo.clipsToBounds = true
        itemCell.contentMode = .scaleAspectFit
        
        itemCell.itemViewController = self
        
        itemCell.setupViews()
        return itemCell
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "itemHeaderId")
    }
}

class ItemViewHeader: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been initialized")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Best Prices:"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        activate(
           nameLabel.anchor.left.constant(16),
           nameLabel.anchor.centerY
        )
    }
}

class ItemViewItemCell: UITableViewCell {
    
    var itemViewController: ItemViewController?
    
    var mainImageView : UIImageView = {
        var imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        imageView.image = UIImage(named: "imageC.jpg")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
//    var logo: UIImageView = {
//        let logo = UIImageView(frame: .zero)
//        logo.translatesAutoresizingMaskIntoConstraints = false
//        return logo
//    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been initialized")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(actionButton)
<<<<<<< HEAD
        addSubview(nameLabel)

=======
        addSubview(mainImageView)
        
        activate(
            mainImageView.anchor.center
            //mainImageView.anchor.size
        )
        
>>>>>>> 06b4352bbe1e5e982a41ecf62813a28fe7671787
        actionButton.addTarget(self, action: #selector(handleAction(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[v0]-20-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    @objc func handleAction(sender: UIButton) {
        itemViewController?.deleteCell(cell: self)
    }
}
