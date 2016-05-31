//
//  CellDataProtocol.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation

public protocol CellDataProtocol {
    var title: String { get }
    var category: String? { get }
}