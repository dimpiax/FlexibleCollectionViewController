//
//  TableData.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation

public struct TableData<T: CellDataProtocol, U: ListGeneratorProtocol where U.Item == T> {
    private var _arr: [T]?
    private var _generator: U?
    
    var sections: Int {
        return _generator?.sections ?? 1
    }
    
    var isEmpty: Bool {
        return _arr?.isEmpty != false
    }
    
    public init(generator: U) {
        _generator = generator
    }
    
    public mutating func addItem(value: T) {
        if _arr == nil { _arr = [] }
        _arr!.append(value)
    }
    
    public mutating func generate() {
        guard let arr = _arr else { return }
        
        _generator?.generate(arr)
    }
    
    public func getItem(indexPath: NSIndexPath) -> T? {
        return _generator?.getData(indexPath.section, row: indexPath.row) ?? _arr?[indexPath.row]
    }
    
    public func getRowsInSection(value: Int) -> Int {
        return  _generator?.getSectionData(value)?.count ?? _arr?.count ?? 0
    }
}