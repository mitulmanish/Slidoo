//
//  DrawerTableViewHeader.swift
//  Slidoo_Example
//
//  Created by Mitul Manish on 3/3/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//
import UIKit

class DrawerTableViewHeader: UIView {
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init(profileImage: UIImage?) {
        super.init(frame: .zero)
        backgroundColor = .darkGray
        setupProfileImage(with: profileImage)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupProfileImage(with image: UIImage?) {
        addSubview(profileImageView)
        [profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
         profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
         profileImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.65),
         profileImageView.widthAnchor.constraint(equalTo: profileImageView
            .heightAnchor)].forEach { $0.isActive = true }
        profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.clipsToBounds = true
    }
}
