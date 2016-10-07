//
//  ListGeneratorProtocol.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation

public protocol ListGeneratorProtocol {
    associatedtype Item
    
    var sections: Int? { get }
    
    func getSectionData(_ value: Int) -> [Item]?
    func getData(_ section: Int, row: Int) -> Item?
    
    mutating func generate(_ data: [Item])
}
