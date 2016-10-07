//
//  SupplementaryKind.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation
import UIKit

public enum SupplementaryKind {
    case header, footer, custom(String)
    
    init(value: String) {
        switch value {
            case UICollectionElementKindSectionHeader: self = .header
            case UICollectionElementKindSectionFooter: self = .footer
            default: self = .custom(value)
        }
    }
    
    public var type: String {
        switch self {
            case .header: return UICollectionElementKindSectionHeader
            case .footer: return UICollectionElementKindSectionFooter
            case .custom(let name): return name
        }
    }
}
