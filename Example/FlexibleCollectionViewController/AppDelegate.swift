//
//  AppDelegate.swift
//  FlexibleCollectionViewController
//
//  Created by Pilipenko Dima on 05/31/2016.
//  Copyright (c) 2016 Pilipenko Dima. All rights reserved.
//

import UIKit
import FlexibleCollectionViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var _flexibleCollectionVC: FlexibleCollectionViewController<CollectionImageCellData, ListGenerator<CollectionImageCellData>>!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.backgroundColor = .whiteColor()
        window!.makeKeyAndVisible()
        
        let vc = UIViewController()
        window!.rootViewController = vc
        
        _flexibleCollectionVC = FlexibleCollectionViewController(collectionViewLayout: CustomFlowLayout(), configuration: GalleryConfiguration())
        vc.addChildViewController(_flexibleCollectionVC)
        vc.view.addSubview(_flexibleCollectionVC.view)
        
        //
        _flexibleCollectionVC.registerCell(UICollectionViewCell.self, reuseIdentifier: String(UICollectionViewCell))
        _flexibleCollectionVC.registerSupplementaryView(UIHeaderImageCollectionView.self, kind: .Header, reuseIdentifier: UIHeaderImageCollectionView.reuseIdentifier)
        
        _flexibleCollectionVC.requestCellIdentifier = { value in
            return String(UICollectionViewCell)
        }
        
        _flexibleCollectionVC.requestSupplementaryIdentifier = { value in
            return UIHeaderImageCollectionView.reuseIdentifier
        }
        
        _flexibleCollectionVC.configureCell = { (cell: UICollectionViewCell, data: CollectionImageCellData?) in
            guard let data = data else {
                return false
            }
            
            cell.backgroundColor = data.color
            
            return true
        }
        
        _flexibleCollectionVC.configureSupplementary = { (view: UICollectionReusableView, data: CollectionImageCellData?) in
            if let view = view as? UIHeaderImageCollectionView, data = data {
                
                view.text = data.category
                
                return true
            }
            
            return false
        }
        
        _flexibleCollectionVC.cellDidSelect = { value in
            return true
        }
        
        _flexibleCollectionVC.estimateCellSize = { value in
            guard let layout = value.collectionViewLayout as? UICollectionViewFlowLayout else {
                return nil
            }
            
            let col: CGFloat = 3
            let width = value.collectionView.bounds.width-(layout.sectionInset.left+layout.sectionInset.right)
            let side = round(width/col)-layout.minimumInteritemSpacing
            return CGSize(width: side, height: side)
        }
        
        _flexibleCollectionVC.setData(getData())
        
        return true
    }
    
    private func getData() -> TableData<CollectionImageCellData, ListGenerator<CollectionImageCellData>> {
        var data = TableData<CollectionImageCellData, ListGenerator<CollectionImageCellData>>(generator: ListGenerator())
        
        var arr = [CollectionImageCellData]()
        for _ in 0..<100 {
            arr.append(CollectionImageCellData())
        }
        arr.sortInPlace { value in
            value.0.category > value.1.category
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

private struct GalleryConfiguration: CollectionConfigurationProtocol {
    let userInteractionEnabled = true
    let showsHorizontalScrollIndicator = false
    let multipleTouchEnabled = false
    let backgroundColor = UIColor.clearColor()
}

class CollectionImageCellData: CellDataProtocol {
    var title: String { return "B" }
    var category: String? = nil
    
    init() {
        category = ["Section One", "Section Two", "Section #N"][Int(arc4random_uniform(3))]
    }
    
    
    var color: UIColor { return UIColor(red: CGFloat(arc4random_uniform(155)+100)/255, green: CGFloat(arc4random_uniform(155)+100)/255, blue: CGFloat(arc4random_uniform(155)+100)/255, alpha: 1) }
}

class UIHeaderImageCollectionView: UICollectionReusableView {
    class var reuseIdentifier: String {
        return String(self)
    }
    
    var text: String? {
        get {
            return _label.text
        }
        set {
            let style = NSMutableParagraphStyle()
            style.alignment = .Center
            _label.attributedText = NSAttributedString(string: newValue ?? "", attributes: [NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 21)!, NSParagraphStyleAttributeName: style])
            _label.sizeToFit()
        }
    }
    
    private var _label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
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