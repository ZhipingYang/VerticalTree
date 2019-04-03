//
//  IndexTreeTableController.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class IndexTreeCell: UITableViewCell {
    
    var indexView: IndexTreeView = IndexTreeView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(indexView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.addSubview(indexView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        indexView.frame = bounds.insetBy(dx: 10, dy: 0)
    }
}

class IndexTreeTableController<T: TreeNode>: UITableViewController {
    
    var dataSource = [T]()
    
    convenience init(source: T) {
        self.init(style: .plain)
        self.source = source
        self.dataSource = source.allSubnodes()
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var source: T? {
        didSet {
            guard let source = source else { return }
            dataSource = source.allSubnodes()
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vertical Tree"
        tableView.separatorStyle = .none
        tableView.register(IndexTreeCell.self, forCellReuseIdentifier: "IndexTreeCell")

        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target:self, action: #selector(dismissWindows))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    @objc func dismissWindows() {
        view.window?.isHidden = true
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IndexTreeCell = tableView.dequeueReusableCell(withIdentifier: "IndexTreeCell") as! IndexTreeCell
        cell.indexView.node = dataSource[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 18
    }
}
