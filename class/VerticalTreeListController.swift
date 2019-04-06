//
//  VerticalTreeListController.swift
//  VerticalTreeIndexView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class VerticalTreeListController<T: TreeNode>: UITableViewController {
    
    var rootNodeDataList = [[T]]()

    convenience init(source: T) {
        self.init(style: .plain)
        self.rootNodes = [source]
    }
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var rootNodes: [T]? {
        didSet {
            guard let rootNodes = rootNodes else { return }
            rootNodeDataList = rootNodes.map { $0.allSubnodes() }
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vertical Tree"
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        tableView.register(VerticalTreeCell<T>.self, forCellReuseIdentifier: "VerticalTreeCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return rootNodeDataList.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootNodeDataList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rootNodeDataList.count>1 ? rootNodeDataList[section].first?.info.nodeTitle : nil //.appending("'s Vertical Tree")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VerticalTreeCell = tableView.dequeueReusableCell(withIdentifier: "VerticalTreeCell") as! VerticalTreeCell<T>
        let node = rootNodeDataList[indexPath.section][indexPath.row]
        cell.node = node
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? VerticalTreeCell<T> else { return }
        var node = rootNodeDataList[indexPath.section][indexPath.row]
        node.isFold = !node.isFold
        rootNodeDataList[indexPath.section][indexPath.row] = node
        
        tableView.beginUpdates()
        cell.fold = node.isFold
        tableView.endUpdates()
    }
}
