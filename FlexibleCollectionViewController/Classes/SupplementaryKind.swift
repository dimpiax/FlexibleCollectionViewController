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
    case Header, Footer, Custom(String)
    
    init(value: String) {
        switch value {
            case UICollectionElementKindSectionHeader: self = .Header
            case UICollectionElementKindSectionFooter: self = .Footer
            default: self = .Custom(value)
        }
    }
    
    var type: String {
        switch self {
            case .Header: return UICollectionElementKindSectionHeader
            case .Footer: return UICollectionElementKindSectionFooter
            case .Custom(let name): return name
        }
    }
}