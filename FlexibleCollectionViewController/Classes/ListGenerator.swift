//
//  ListGenerator.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation

public struct ListGenerator<Item: CellDataProtocol>: ListGeneratorProtocol {
    private var _data: [[Item]]?
    
    public var sections: Int? {
        return _data?.count
    }
    
    init() {
        // empty
    }
    
    // * FUNCTIONS
    // METHODS
    public mutating func generate(data: [Item]) {
        var arr = [[Item]]()
        
        var prevCategory: String?
        for value in data {
            if prevCategory != value.category {
                arr.append([])
            }
            
            arr[arr.count-1].append(value)
            prevCategory = value.category
        }
        
        _data = arr
    }
    
    public func getSectionData(value: Int) -> [Item]? {
        guard _data != nil else {
            return nil
        }
        
        guard value < _data!.count else {
            return nil
        }
        
        return _data![value]
    }
    
    public func getData(section: Int, row: Int) -> Item? {
        guard let sectionData = getSectionData(section) else {
            return nil
        }
        
        guard row < sectionData.count else {
            return nil
        }
        
        return sectionData[row]
    }
}