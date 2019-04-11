//
//  Package.swift
//  Demo
//
//  Created by Daniel Yang on 2019/4/11.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "VerticalTreeView",
    products: [
        .library(name: "VerticalTreeView", targets: ["Demo"]),
    ],
    targets: [
        .target(name: "Demo"),
    ]
)
