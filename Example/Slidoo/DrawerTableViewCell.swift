//
//  DrawerTableViewCell.swift
//  Slidoo_Example
//
//  Created by Mitul Manish on 3/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
class DrawerTableViewCell: UITableViewCell {
    static let identifier = "cellID"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .darkGray
        contentView.backgroundColor = .darkGray
        textLabel?.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
