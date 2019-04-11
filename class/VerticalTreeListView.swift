//
//  VerticalTreeListView.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/5.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class VerticalTreeListView<T: TreeNode>: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var rootNodeDataList = [[T]]()
    
    public convenience init(rootNodes: [T]) {
        self.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.rootNodes = rootNodes
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    private func _init() {
        separatorStyle = .none
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 10
        register(VerticalTreeCell<T>.self, forCellReuseIdentifier: "VerticalTreeCell")
        
        delegate = self
        dataSource = self
    }
    
    public var rootNodes: [T]? {
        didSet(newValue) {
            rootNodeDataList = newValue?.map { $0.allSubnodes() } ?? []
            reloadData()
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if let _ = window {
            reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rootNodeDataList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rootNodeDataList[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rootNodeDataList.count>1 ? rootNodeDataList[section].first?.info.nodeTitle : nil //.appending("'s Vertical Tree")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VerticalTreeCell = tableView.dequeueReusableCell(withIdentifier: "VerticalTreeCell") as! VerticalTreeCell<T>
        let node = rootNodeDataList[indexPath.section][indexPath.row]
        cell.node = node
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
