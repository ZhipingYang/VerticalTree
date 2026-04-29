//
//  VerticalTreeListController.swift
//  VerticalTreeIndexView
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

public class VerticalTreeListController<T: VerticalTreeNode>: UITableViewController {
    public var didSelectHandler: ((T)->Void)?

    @available(*, deprecated, renamed: "didSelectHandler")
    public var didSelectedHandle: ((T)->Void)? {
        get { return didSelectHandler }
        set { didSelectHandler = newValue }
    }

    /// visible nodes grouped by root node
    private var rootNodeDataList = [[T]]()
    private var treeDeepList = [Int]()

    public convenience init(source: T) {
        self.init(style: .plain)
        self.rootNodes = [source]
    }

    public override init(style: UITableView.Style) {
        super.init(style: style)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var rootNodes: [T]? {
        didSet {
            reloadDataSource()
            if isViewLoaded { tableView.reloadData() }
        }
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        if title == nil { title = "Vertical Tree" }
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
        tableView.register(VerticalTreeCell<T>.self, forCellReuseIdentifier: "VerticalTreeCell")
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadDataSource()
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
        return rootNodeDataList.count > 1 ? rootNodes?[section].info.nodeTitle : nil //.appending("'s Vertical Tree")
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: VerticalTreeCell = tableView.dequeueReusableCell(withIdentifier: "VerticalTreeCell") as! VerticalTreeCell<T>
        let node = rootNodeDataList[indexPath.section][indexPath.row]
        cell.configure(node: node, treeDeep: treeDeepList[indexPath.section])
        return cell
    }

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var node = rootNodeDataList[indexPath.section][indexPath.row]

        if let handle = didSelectHandler {
            handle(node)
            return
        }

        node.isFold = !node.isFold
        rootNodeDataList[indexPath.section][indexPath.row] = node

        let changedRows: [IndexPath]
        if node.isFold {
            let removedCount = removeVisibleDescendants(of: node, at: indexPath)
            changedRows = (0..<removedCount).map { IndexPath(row: indexPath.row + 1 + $0, section: indexPath.section) }
        } else {
            let insertedNodes = visibleChildNodes(of: node)
            rootNodeDataList[indexPath.section].insert(contentsOf: insertedNodes, at: indexPath.row + 1)
            changedRows = insertedNodes.indices.map { IndexPath(row: indexPath.row + 1 + $0, section: indexPath.section) }
        }

        tableView.beginUpdates()
        (tableView.cellForRow(at: indexPath) as? VerticalTreeCell<T>)?.configure(node: node, treeDeep: treeDeepList[indexPath.section])
        if !changedRows.isEmpty {
            if node.isFold {
                tableView.deleteRows(at: changedRows, with: .automatic)
            } else {
                tableView.insertRows(at: changedRows, with: .automatic)
            }
        }
        tableView.endUpdates()
    }
}

private extension VerticalTreeListController {

    func reloadDataSource() {
        guard let rootNodes = rootNodes else {
            rootNodeDataList = []
            treeDeepList = []
            return
        }

        treeDeepList = rootNodes.map { $0.treeDeep }
        rootNodeDataList = rootNodes.map { visibleNodes(from: $0) }
    }

    func visibleNodes(from node: T) -> [T] {
        var nodes = [node]
        if !node.isFold {
            nodes.append(contentsOf: visibleChildNodes(of: node))
        }
        return nodes
    }

    func visibleChildNodes(of node: T) -> [T] {
        return node.childs.flatMap { visibleNodes(from: $0) }
    }

    @discardableResult
    func removeVisibleDescendants(of node: T, at indexPath: IndexPath) -> Int {
        let startIndex = indexPath.row + 1
        var endIndex = startIndex
        let currentNodes = rootNodeDataList[indexPath.section]
        while endIndex < currentNodes.count, currentNodes[endIndex].currentDeep > node.currentDeep {
            endIndex += 1
        }
        guard endIndex > startIndex else { return 0 }

        rootNodeDataList[indexPath.section].removeSubrange(startIndex..<endIndex)
        return endIndex - startIndex
    }
}
