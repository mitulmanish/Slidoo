//
//  UIView+Extensions.swift
//  Slidoo
//
//  Created by Mitul Manish on 14/1/19.
//

import UIKit

extension UIView {
    public var isRTL: Bool {
        if #available(iOS 10.0, *) {
            return effectiveUserInterfaceLayoutDirection == .rightToLeft
        } else {
            return UIView.userInterfaceLayoutDirection(for: semanticContentAttribute) == .rightToLeft
        }
    }
}

