//
//  FlexibleCollectionViewController.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation
import UIKit

public class FlexibleCollectionViewController<T: CellDataProtocol, U: ListGeneratorProtocol where U.Item == T>: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    public var requestCellIdentifier: (NSIndexPath -> String?)?
    public var requestSupplementaryIdentifier: ((indexPath: NSIndexPath, kind: String) -> String?)?
    
    public var configureCell: ((UICollectionViewCell, T?) -> Bool)?
    public var cellDidSelect: (NSIndexPath -> Bool)?
    public var estimateCellSize: ((collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, indexPath: NSIndexPath) -> CGSize?)?
    
    public var configureSupplementary: ((UICollectionReusableView, T?) -> Bool)?
    
    private var _data: TableData<T, U>?
    
    convenience init(configuration: CollectionConfigurationProtocol) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout(), configuration: configuration)
    }
    
    public init(collectionViewLayout layout: UICollectionViewLayout, configuration: CollectionConfigurationProtocol) {
        super.init(collectionViewLayout: layout)
        
        collectionView!.userInteractionEnabled = configuration.userInteractionEnabled
        collectionView!.showsHorizontalScrollIndicator = configuration.showsHorizontalScrollIndicator
        collectionView!.multipleTouchEnabled = configuration.multipleTouchEnabled
        
        collectionView!.delegate = self
        collectionView!.backgroundColor = configuration.backgroundColor
    }
    
    public func setData(value: TableData<T, U>) {
        _data = value
        collectionView?.reloadData()
    }
    
    // * FUNCTIONS
    // METHODS
    public func registerCell(classs: UICollectionViewCell.Type, reuseIdentifier: String) {
        collectionView?.registerClass(classs, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    public func registerSupplementaryView(classs: UICollectionReusableView.Type, kind: SupplementaryKind, reuseIdentifier: String) {
        collectionView?.registerClass(classs, forSupplementaryViewOfKind: kind.type, withReuseIdentifier: reuseIdentifier)
    }
    
    public func getItemData(indexPath: NSIndexPath) -> T? {
        return _data?.getItem(indexPath)
    }
    
    // UICollectionViewDataSource
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let identifier = requestCellIdentifier?(indexPath) else {
            return UICollectionViewCell()
        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let identifier = requestSupplementaryIdentifier?(indexPath: indexPath, kind: kind) else {
            return UICollectionReusableView()
        }
        
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath)
    }
    
    override public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let itemData = _data?.getItem(indexPath) else {
            return
        }
        
        guard configureCell?(cell, itemData) == true else {
            return
        }
    }
    
    public override func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        guard let itemData = _data?.getItem(indexPath) else {
            return
        }
        
        guard configureSupplementary?(view, itemData) == true else {
            return
        }
    }
    
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _data?.getRowsInSection(section) ?? 0
    }
    
    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return _data?.sections ?? 1
    }
    
    // UICollectionViewDelegate
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if cellDidSelect?(indexPath) == true {
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        }
    }
    
    public override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let size = estimateCellSize?(collectionView: collectionView, collectionViewLayout: collectionViewLayout, indexPath: indexPath) {
            return size
        }
        
        return CGSize(width: 25, height: 25)
    }
}