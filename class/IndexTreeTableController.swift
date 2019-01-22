//
//  IndexTreeTableController.swift
//  IndexTreeView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class IndexTreeCell: UITableViewCell {
    lazy var indexView: IndexTreeView = IndexTreeView<UIView>()
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

class IndexTreeTableController: UITableViewController {
    
    var source: UIView?
    var dataSource = [UIView]()
    
    init(_ view: UIView) {
        self.source = view
        if let arr = source?.allSubnodes {
            self.dataSource += arr
        }
        super.init(style: UITableView.Style.plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        source = nil;
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        source = nil;
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(IndexTreeCell.self, forCellReuseIdentifier: "IndexTreeCell")
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
}
