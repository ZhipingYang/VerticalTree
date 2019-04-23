//
//  VerticalTreeListController.swift
//  VerticalTreeIndexView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

public class VerticalTreeListController<T: VerticalTreeNode>: UITableViewController {
    var didSelectedHandle: ((T)->Void)?
    /// dataSource
    private var rootNodeDataList = [[T]]()

    public convenience init(source: T) {
        self.init(style: .plain)
        self.rootNodes = [source]
        self.rootNodeDataList = [source].map { $0.allSubnodes() }
    }

    public override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public var rootNodes: [T]? {
        didSet {
            guard let rootNodes = rootNodes else { return }
            rootNodeDataList = rootNodes.map { $0.allSubnodes() }
            tableView.reloadData()
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Vertical Tree"
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        tableView.register(VerticalTreeCell<T>.self, forCellReuseIdentifier: "VerticalTreeCell")
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source & delegate
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return rootNodeDataList.count
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootNodeDataList[section].count
    }
    
    override public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rootNodeDataList.count>1 ? rootNodeDataList[section].first?.info.nodeTitle : nil //.appending("'s Vertical Tree")
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VerticalTreeCell = tableView.dequeueReusableCell(withIdentifier: "VerticalTreeCell") as! VerticalTreeCell<T>
        let node = rootNodeDataList[indexPath.section][indexPath.row]
        cell.node = node
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var node = rootNodeDataList[indexPath.section][indexPath.row]

        if let handle = didSelectedHandle {
            handle(node)
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? VerticalTreeCell<T> else { return }
        node.isFold = !node.isFold
        rootNodeDataList[indexPath.section][indexPath.row] = node
        
        tableView.beginUpdates()
        cell.fold = node.isFold
        tableView.endUpdates()
    }
}
