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
    
    var fold: Bool = true {
        didSet {
            descriptionHeightConstraint?.isActive = fold
            self.updateConstraintsIfNeeded()
        }
    }

    var descriptionHeightConstraint: NSLayoutConstraint?
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    var node: TreeNode? {
        didSet {
            indexView.node = node
            descriptionLabel.text = node?.info.description
            fold = node?.isFold ?? true
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _init()
    }
    
    func _init() {
        self.clipsToBounds = true
        
        contentView.addSubview(indexView)
        contentView.addSubview(descriptionLabel)
        indexView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = descriptionLabel.heightAnchor.constraint(equalToConstant: 0)
        height.priority = UILayoutPriority.required
        descriptionHeightConstraint = height
        NSLayoutConstraint.activate([
            indexView.topAnchor.constraint(equalTo: contentView.topAnchor),
            indexView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            indexView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            indexView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            descriptionLabel.topAnchor.constraint(equalTo: indexView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            height
        ])
        
        descriptionHeightConstraint?.isActive = fold
    }
}

class IndexTreeTableController<T: TreeNode>: UITableViewController {
    
    var dataSource = [T]()

    convenience init(source: T) {
        self.init(style: .plain)
        self.source = source
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
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 10
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
        let node = dataSource[indexPath.row]
        cell.node = node
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cell = tableView.cellForRow(at: indexPath) as? IndexTreeCell else { return }
        var node = dataSource[indexPath.row]
        node.isFold = !node.isFold
        dataSource[indexPath.row] = node
        
        tableView.beginUpdates()
        cell.fold = node.isFold
        tableView.endUpdates()
    }
}
