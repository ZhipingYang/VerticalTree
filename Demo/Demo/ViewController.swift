//
//  ViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/1/22.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBAction func actionSelector(_ sender: Any) {
        let tvc = IndexTreeTableController<UIView>()
        tvc.source = view.window ?? navigationController?.view ?? view
        navigationController?.pushViewController(tvc, animated: true)
    }
}

