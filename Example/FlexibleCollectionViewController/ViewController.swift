//
//  ViewController.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 05/31/2016.
//  Copyright (c) 2016 Pilipenko Dima. All rights reserved.
//

import UIKit
import FlexibleCollectionViewController

class ViewController: UIViewController {
    fileprivate var _flexibleCollectionVC: FlexibleCollectionViewController<CollectionImageCellData, ListGenerator<CollectionImageCellData>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialisation with configuration
        _flexibleCollectionVC = FlexibleCollectionViewController(collectionViewLayout: CustomFlowLayout(), configuration: CollectionConfiguration(userInteractionEnabled: true, showsHorizontalScrollIndicator: false, isScrollEnabled: true, multipleTouchEnabled: false, backgroundColor: .clear))
        
        addChildViewController(_flexibleCollectionVC)
        view.addSubview(_flexibleCollectionVC.view)
        
        // cell and supplementary view registering
        _flexibleCollectionVC.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        _flexibleCollectionVC.registerSupplementaryView(UIHeaderImageCollectionView.self, kind: .header, reuseIdentifier: UIHeaderImageCollectionView.reuseIdentifier)
        
        // requesting indentifier of cell for specific indexPath
        _flexibleCollectionVC.requestCellIdentifier = { value in
            return "UICollectionViewCell"
        }
        
        // requesting indentifier of supplementary view for specific indexPath
        _flexibleCollectionVC.requestSupplementaryIdentifier = { value in
            return UIHeaderImageCollectionView.reuseIdentifier
        }
        
        // configuration of input cell with related data to indexPath
        _flexibleCollectionVC.configureCell = { (cell: UICollectionViewCell, data: CollectionImageCellData?, indexPath: IndexPath) in
            guard let data = data else {
                return false
            }
            
            cell.backgroundColor = data.color
            
            return true
        }
        
        // configuration of supplementary view with related kind and data to indexPath
        _flexibleCollectionVC.configureSupplementary = { (view: UICollectionReusableView, kind: SupplementaryKind, data: CollectionImageCellData?, indexPath: IndexPath) in
            if let view = view as? UIHeaderImageCollectionView, let data = data {
                view.text = data.category
                
                return true
            }
            
            return false
        }
        
        // process cell selection to related indexPath
        _flexibleCollectionVC.cellDidSelect = { value in
            return (deselect: true, animate: true)
        }
        
        // estimate cell size
        _flexibleCollectionVC.estimateCellSize = { value in
            guard let layout = value.1 as? UICollectionViewFlowLayout else {
                return nil
            }
            
            let col: CGFloat = 3
            let width = value.0.bounds.width-(layout.sectionInset.left+layout.sectionInset.right)
            let side = round(width/col)-layout.minimumInteritemSpacing
            return CGSize(width: side, height: side)
        }
        
        // put predefined cells in generated order related to ListGenerator
        _flexibleCollectionVC.setData(getData())
    }

    fileprivate func getData() -> TableData<CollectionImageCellData, ListGenerator<CollectionImageCellData>> {
        var data = TableData<CollectionImageCellData, ListGenerator<CollectionImageCellData>>(generator: ListGenerator())
        
        var arr = [CollectionImageCellData]()
        for _ in 0..<100 {
            arr.append(CollectionImageCellData())
        }
        arr.sort { value in
            value.0.category! > value.1.category!
        }
        arr.forEach { data.addItem($0) }
        
        data.generate()
        return data
    }
}

class CustomFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        
        headerReferenceSize = CGSize(width: 0, height: 100)
        if #available(iOS 9.0, *) {
            sectionHeadersPinToVisibleBounds = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionImageCellData: CellDataProtocol {
    var title: String { return "B" }
    var category: String? = nil
    
    init() {
        category = ["Section #1", "Section #2", "Section  #N"][Int(arc4random_uniform(3))]
    }
    
    var color: UIColor { return UIColor(red: CGFloat(arc4random_uniform(100))/255, green: CGFloat(arc4random_uniform(100))/255, blue: CGFloat(arc4random_uniform(100))/255, alpha: 1) }
}

class UIHeaderImageCollectionView: UICollectionReusableView {
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var text: String? {
        get {
            return _label.text
        }
        set {
            let style = NSMutableParagraphStyle()
            style.alignment = .center
            _label.attributedText = NSAttributedString(string: newValue ?? "", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 21)!, NSParagraphStyleAttributeName: style])
            _label.sizeToFit()
        }
    }
    
    fileprivate var _label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        _label = UILabel()
        addSubview(_label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _label.frame = bounds
    }
}
