//
//  VerticalTreeCell.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/5.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import Then

class VerticalTreeCell<T: VerticalTreeNode>: UITableViewCell {

    var descriptionHeightConstraint: NSLayoutConstraint?

    lazy var indexView = VerticalTreeIndexView<T>().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()

    var fold: Bool = true {
        didSet {
            descriptionHeightConstraint?.isActive = fold
        }
    }

    var treeDeep: Int = 1 {
        didSet {
            indexView.treeDeep = treeDeep
        }
    }

    var node: T? {
        didSet {
            indexView.node = node
            descriptionLabel.text = node?.info.nodeDescription
            fold = node?.isFold ?? true
        }
    }

    func configure(node: T, treeDeep: Int) {
        self.treeDeep = treeDeep
        self.node = node
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        node = nil
        treeDeep = 1
        descriptionLabel.text = nil
        fold = true
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

        descriptionHeightConstraint = descriptionLabel.heightAnchor.constraint(equalToConstant: 0).then {
            $0.priority = UILayoutPriority.required
            $0.isActive = fold
        }
        NSLayoutConstraint.activate([
            indexView.topAnchor.constraint(equalTo: contentView.topAnchor),
            indexView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            indexView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            indexView.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),

            descriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: indexView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
