//
//  IndexTreeTableController.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class IndexTreeCell<T: TreeNode>: UITableViewCell {
    
    var indexView: IndexTreeView = IndexTreeView<T>()
    
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
        indexView.frame = bounds
    }
}

class IndexTreeTableController<T: TreeNode>: UITableViewController {
    
    var dataSource = [T]()

    var source: T? {
        didSet {
            guard let source = source else { return }
            dataSource = source.allSubnodes(source)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(IndexTreeCell<T>.self, forCellReuseIdentifier: "IndexTreeCell")
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: IndexTreeCell = tableView.dequeueReusableCell(withIdentifier: "IndexTreeCell") as! IndexTreeCell<T>
        cell.indexView.node = dataSource[indexPath.row]
        return cell
    }
}
