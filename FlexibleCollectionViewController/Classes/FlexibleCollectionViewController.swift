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
    public var requestSupplementaryIdentifier: ((indexPath: NSIndexPath, kind: SupplementaryKind) -> String?)?
    
    public var configureCell: ((cell: UICollectionViewCell, data: T?, indexPath: NSIndexPath) -> Bool)?
    public var willDisplayCell: ((cell: UICollectionViewCell, data: T?, indexPath: NSIndexPath) -> Bool)?
    public var didEndDisplayingCell: ((cell: UICollectionViewCell, data: T?, indexPath: NSIndexPath) -> Bool)?
    public var cellDidSelect: (NSIndexPath -> (deselect: Bool, animate: Bool)?)?
    public var cellDidDeselect: (NSIndexPath -> Bool)?
    public var estimateCellSize: ((collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, indexPath: NSIndexPath) -> CGSize?)?
    
    public var configureSupplementary: ((view: UICollectionReusableView, kind: SupplementaryKind, data: T?, indexPath: NSIndexPath) -> Bool)?
    public var willDisplaySupplementary: ((view: UICollectionReusableView, kind: SupplementaryKind, data: T?, indexPath: NSIndexPath) -> Bool)?
    public var didEndDisplayingSupplementary: ((view: UICollectionReusableView, kind: SupplementaryKind, data: T?, indexPath: NSIndexPath) -> Bool)?
    
    public var scrollViewDidScroll: ((scrollView: UIScrollView) -> Void)?
    public var scrollViewDidEndDragging: ((scrollView: UIScrollView, willDecelerate: Bool) -> Void)?
    
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
    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let identifier = requestCellIdentifier?(indexPath) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        configureCell?(cell: cell, data: _data?.getItem(indexPath), indexPath: indexPath)
        
        return cell
    }
    
    public override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let identifier = requestSupplementaryIdentifier?(indexPath: indexPath, kind: SupplementaryKind(value: kind)) else {
            return UICollectionReusableView()
        }
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath)
        configureSupplementary?(view: view, kind: SupplementaryKind(value: kind), data: _data?.getItem(indexPath), indexPath: indexPath)
        
        return view
    }
    
    public override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        willDisplayCell?(cell: cell, data: _data?.getItem(indexPath), indexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        didEndDisplayingCell?(cell: cell, data: _data?.getItem(indexPath), indexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        willDisplaySupplementary?(view: view, kind: SupplementaryKind(value: elementKind), data: _data?.getItem(indexPath), indexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        didEndDisplayingSupplementary?(view: view, kind: SupplementaryKind(value: elementKind), data: _data?.getItem(indexPath), indexPath: indexPath)
    }
    
    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _data?.getRowsInSection(section) ?? 0
    }
    
    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return _data?.sections ?? 1
    }
    
    public override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollViewDidScroll?(scrollView: scrollView)
    }
    
    public override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDidEndDragging?(scrollView: scrollView, willDecelerate: decelerate)
    }
    
    // UICollectionViewDelegate
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let result = cellDidSelect?(indexPath) else {
            return
        }
        
        if result.deselect {
            collectionView.deselectItemAtIndexPath(indexPath, animated: result.animate)
        }
    }
    
    public override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        cellDidDeselect?(indexPath)
    }
    
    // UICollectionViewDelegateFlowLayout
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if let size = estimateCellSize?(collectionView: collectionView, collectionViewLayout: collectionViewLayout, indexPath: indexPath) {
            return size
        }
        
        return CGSize(width: 25, height: 25)
    }
    
    deinit {
        requestCellIdentifier = nil
        requestSupplementaryIdentifier = nil
        
        configureCell = nil
        willDisplayCell = nil
        didEndDisplayingCell = nil
        cellDidSelect = nil
        estimateCellSize = nil
        
        configureSupplementary = nil
        willDisplaySupplementary = nil
        didEndDisplayingSupplementary = nil
        
        scrollViewDidScroll = nil
        scrollViewDidEndDragging = nil
        
        _data = nil
    }
}