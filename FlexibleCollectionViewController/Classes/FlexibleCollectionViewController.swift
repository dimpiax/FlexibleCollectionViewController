//
//  FlexibleCollectionViewController.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 5/31/16.
//  Copyright © 2016 dimpiax. All rights reserved.
//

import Foundation
import UIKit

open class FlexibleCollectionViewController<T: CellDataProtocol, U: ListGeneratorProtocol>: UICollectionViewController, UICollectionViewDelegateFlowLayout where U.Item == T {
    open var requestCellIdentifier: ((IndexPath) -> String?)?
    open var requestSupplementaryIdentifier: ((_ indexPath: IndexPath, _ kind: SupplementaryKind) -> String?)?
    
    open var configureCell: ((_ cell: UICollectionViewCell, _ data: T?, _ indexPath: IndexPath) -> Bool)?
    open var willDisplayCell: ((_ cell: UICollectionViewCell, _ data: T?, _ indexPath: IndexPath) -> Bool)?
    open var didEndDisplayingCell: ((_ cell: UICollectionViewCell, _ data: T?, _ indexPath: IndexPath) -> Bool)?
    open var cellDidSelect: ((IndexPath) -> (deselect: Bool, animate: Bool)?)?
    open var cellDidDeselect: ((IndexPath) -> Bool)?
    open var estimateCellSize: ((_ collectionView: UICollectionView, _ collectionViewLayout: UICollectionViewLayout, _ indexPath: IndexPath) -> CGSize?)?
    
    open var configureSupplementary: ((_ view: UICollectionReusableView, _ kind: SupplementaryKind, _ data: T?, _ indexPath: IndexPath) -> Bool)?
    open var willDisplaySupplementary: ((_ view: UICollectionReusableView, _ kind: SupplementaryKind, _ data: T?, _ indexPath: IndexPath) -> Bool)?
    open var didEndDisplayingSupplementary: ((_ view: UICollectionReusableView, _ kind: SupplementaryKind, _ data: T?, _ indexPath: IndexPath) -> Bool)?
    
    open var scrollViewDidScroll: ((_ scrollView: UIScrollView) -> Void)?
    open var scrollViewDidEndDragging: ((_ scrollView: UIScrollView, _ willDecelerate: Bool) -> Void)?
    
    fileprivate var _data: TableData<T, U>?
    
    convenience init(configuration: CollectionConfiguration) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout(), configuration: configuration)
    }
    
    public init(collectionViewLayout layout: UICollectionViewLayout, configuration: CollectionConfiguration) {
        super.init(collectionViewLayout: layout)
        
        collectionView!.isUserInteractionEnabled = configuration.userInteractionEnabled
        collectionView!.showsHorizontalScrollIndicator = configuration.showsHorizontalScrollIndicator
        collectionView!.isScrollEnabled = configuration.isScrollEnabled
        collectionView!.isMultipleTouchEnabled = configuration.multipleTouchEnabled
        collectionView!.backgroundColor = configuration.backgroundColor
        
        collectionView!.delegate = self
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setData(_ value: TableData<T, U>) {
        _data = value
        collectionView?.reloadData()
    }
    
    // * FUNCTIONS
    // METHODS
    open func register(_ classs: UICollectionViewCell.Type, forCellWithReuseIdentifier reuseIdentifier: String) {
        collectionView?.register(classs, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    open func registerSupplementaryView(_ classs: UICollectionReusableView.Type, kind: SupplementaryKind, reuseIdentifier: String) {
        collectionView?.register(classs, forSupplementaryViewOfKind: kind.type, withReuseIdentifier: reuseIdentifier)
    }
    
    open func getItemData(_ indexPath: IndexPath) -> T? {
        return _data?.getItem(indexPath)
    }
    
    // UICollectionViewDataSource
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let identifier = requestCellIdentifier?(indexPath) else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        configureCell?(cell, _data?.getItem(indexPath), indexPath)
        
        return cell
    }
    
    open override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let identifier = requestSupplementaryIdentifier?(indexPath, SupplementaryKind(value: kind)) else {
            return UICollectionReusableView()
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
        configureSupplementary?(view, SupplementaryKind(value: kind), _data?.getItem(indexPath), indexPath)
        
        return view
    }
    
    open override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        willDisplayCell?(cell, _data?.getItem(indexPath), indexPath)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        didEndDisplayingCell?(cell, _data?.getItem(indexPath), indexPath)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        willDisplaySupplementary?(view, SupplementaryKind(value: elementKind), _data?.getItem(indexPath), indexPath)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        didEndDisplayingSupplementary?(view, SupplementaryKind(value: elementKind), _data?.getItem(indexPath), indexPath)
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _data?.getRowsInSection(section) ?? 0
    }
    
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return _data?.sections ?? 1
    }
    
    open override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidScroll?(scrollView)
    }
    
    open override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewDidEndDragging?(scrollView, decelerate)
    }
    
    // UICollectionViewDelegate
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let result = cellDidSelect?(indexPath) else {
            return
        }
        
        if result.deselect {
            collectionView.deselectItem(at: indexPath, animated: result.animate)
        }
    }
    
    open override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        cellDidDeselect?(indexPath)
    }
    
    // UICollectionViewDelegateFlowLayout
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = estimateCellSize?(collectionView, collectionViewLayout, indexPath) {
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
