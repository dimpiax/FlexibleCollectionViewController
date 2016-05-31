//
//  CollectionConfigurationProtocol.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation
import UIKit

public protocol CollectionConfigurationProtocol {
    var userInteractionEnabled: Bool { get }
    var showsHorizontalScrollIndicator: Bool { get }
    var multipleTouchEnabled: Bool { get }
    var backgroundColor: UIColor { get }
}