//
//  Cell+Ext.swift
//  DishDash(Final)
//
//  Created by Apple on 25.05.24.
//

import Foundation
import UIKit

extension UICollectionViewCell{
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell{
    static var identifier: String {
        return String(describing: self)
    }
}
