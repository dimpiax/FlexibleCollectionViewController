//
//  CollectionConfigurationProtocol.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation
import UIKit

public struct CollectionConfiguration {
    let userInteractionEnabled: Bool
    let showsHorizontalScrollIndicator: Bool
    let isScrollEnabled: Bool
    let multipleTouchEnabled: Bool
    let backgroundColor: UIColor
    
    public init() {
        userInteractionEnabled = true
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        multipleTouchEnabled = false
        backgroundColor = .clear
    }
    
    public init(userInteractionEnabled: Bool, showsHorizontalScrollIndicator: Bool, isScrollEnabled: Bool, multipleTouchEnabled: Bool, backgroundColor: UIColor) {
        self.userInteractionEnabled = userInteractionEnabled
        self.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        self.isScrollEnabled = isScrollEnabled
        self.multipleTouchEnabled = multipleTouchEnabled
        self.backgroundColor = backgroundColor
    }
}
