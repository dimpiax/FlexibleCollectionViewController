# FlexibleCollectionViewController

[![Language](https://img.shields.io/badge/swift-3.0-fec42e.svg)](https://swift.org/blog/swift-3-0-released/)
[![Version](https://img.shields.io/cocoapods/v/FlexibleCollectionViewController.svg?style=flat)](http://cocoapods.org/pods/FlexibleCollectionViewController)
[![License](https://img.shields.io/cocoapods/l/FlexibleCollectionViewController.svg?style=flat)](http://cocoapods.org/pods/FlexibleCollectionViewController)
[![Platform](https://img.shields.io/cocoapods/p/FlexibleCollectionViewController.svg?style=flat)](http://cocoapods.org/pods/FlexibleCollectionViewController)

Swift library of generic collection view controller with external data processing of functionality,
like determine cell's `reuseIdentifier` related to `indexPath`, 
configuration of requested cell for display and cell selection handler etc


## Example

Initialisation with configuration 
```
_flexibleCollectionVC = FlexibleCollectionViewController(collectionViewLayout: CustomFlowLayout(), configuration: CollectionConfiguration(userInteractionEnabled: true, showsHorizontalScrollIndicator: false, isScrollEnabled: true, multipleTouchEnabled: false, backgroundColor: .clear))
```

Cell and supplementary view registering
```
_flexibleCollectionVC.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
_flexibleCollectionVC.registerSupplementaryView(UIHeaderImageCollectionView.self, kind: .header, reuseIdentifier: UIHeaderImageCollectionView.reuseIdentifier)
```

Requesting indentifier of cell for specific indexPath
```
_flexibleCollectionVC.requestCellIdentifier = { value in
  return "UICollectionViewCell"
}
```

Requesting indentifier of supplementary view for specific indexPath
```
_flexibleCollectionVC.requestSupplementaryIdentifier = { value in
  return UIHeaderImageCollectionView.reuseIdentifier
}
```

Configuration of input cell with related data to indexPath
```
_flexibleCollectionVC.configureCell = { (cell: UICollectionViewCell, data: CollectionImageCellData?, indexPath: IndexPath) in
  guard let data = data else {
    return false
  }

  cell.backgroundColor = data.color

  return true
}
```

Configuration of supplementary view with related kind and data to indexPath
```
_flexibleCollectionVC.configureSupplementary = { (view: UICollectionReusableView, kind: SupplementaryKind, data: CollectionImageCellData?, indexPath: IndexPath) in
  if let view = view as? UIHeaderImageCollectionView, let data = data {
    view.text = data.category

    return true
  }

  return false
}
```

Process cell selection to related indexPath
```
_flexibleCollectionVC.cellDidSelect = { value in
  return (deselect: true, animate: true)
}
```

Estimate cell size
```
_flexibleCollectionVC.estimateCellSize = { value in
  guard let layout = value.1 as? UICollectionViewFlowLayout else {
    return nil
  }

  let col: CGFloat = 3
  let width = value.0.bounds.width-(layout.sectionInset.left+layout.sectionInset.right)
  let side = round(width/col)-layout.minimumInteritemSpacing
  return CGSize(width: side, height: side)
}
```

Put predefined cells in generated order related to ListGenerator
```
_flexibleCollectionVC.setData(getData())
```

## Requirements

Swift 3 or above

## Installation

FlexibleCollectionViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "FlexibleCollectionViewController"
```

## Author

Pilipenko Dima, dimpiax@gmail.com

## License

FlexibleCollectionViewController is available under the MIT license. See the LICENSE file for more info.
