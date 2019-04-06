//
//  DemoVerticalTreeController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/5.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class DemoVerticalTreeController<T: TreeNode>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    lazy var treeView: VerticalTreeListView<T> = {
        let tree = VerticalTreeListView<T>.init(frame: UIScreen.main.bounds, style: UITableView.Style.plain)
        tree.frame = UIScreen.main.bounds
        return tree
    }()
    
    var rootNodes: [T]? {
        didSet {
            guard let rootNodes = rootNodes else { return }
            rootNodeDataList = rootNodes.map { $0.allSubnodes() }
            treeView.reloadData()
        }
    }

    var rootNodeDataList = [[T]]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        view.addSubview(treeView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view.addSubview(treeView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Vertical Tree"
        
        treeView.delegate = self
        treeView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.stop, target:self, action: #selector(dismissWindows))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        treeView.reloadData()
    }
    
    @objc func dismissWindows() {
        view.window?.isHidden = true
        UIApplication.shared.delegate?.window??.makeKeyAndVisible()
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
