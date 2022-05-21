//
//  NewLayout.swift
//  TestDataPicker
//
//  Created by Юрий Девятаев on 20.05.2022.
//

import Foundation
import UIKit

protocol PinterestLayoutDelegate: AnyObject {
  func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat
}

class StickyHeadersCollectionViewFlowLayout: UICollectionViewLayout {//UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    weak var delegate: PinterestLayoutDelegate?
    
    let headerHeigh: CGFloat = 30
    let rowHeigh: CGFloat = 50
//    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 10

    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0

    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
          return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    
    override var collectionViewContentSize: CGSize {
        print(contentHeight)
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        guard cache.isEmpty == true, let collectionView = collectionView
        else { return }

        let columnWidth = contentWidth / 2 - cellPadding / 2
        let xOffset: [CGFloat] = [0.0, columnWidth + cellPadding]
    
        var column = 0
        var yOffset: [CGFloat] = [0, 0]

        for section in 0..<collectionView.numberOfSections {
            
            let headerAttr = UICollectionViewLayoutAttributes(
                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                with: IndexPath(row: 0, section: section))
            
            headerAttr.frame = CGRect(x: 0,
                                      y: yOffset[0],
                                      width: contentWidth,
                                      height: headerHeigh)
            cache.append(headerAttr)

            yOffset[0] = headerAttr.frame.maxY + cellPadding / 2
            yOffset[1] = headerAttr.frame.maxY + cellPadding / 2
            
            let countRow = collectionView.numberOfItems(inSection: section)
            column = 0
            
            for row in 0..<countRow {
                let indexPath = IndexPath(item: row, section: section)
                
                let customHeight = delegate?.collectionView(
                    collectionView,
                    heightForPhotoAtIndexPath: indexPath) ?? 180
                                
                var frame = CGRect(
                    x: xOffset[column],
                    y: yOffset[column],
                    width: columnWidth,
                    height: customHeight)
                
                if section == collectionView.numberOfSections - 1, row == countRow - 1 {
                    frame.size.width = contentWidth
                }
                
                yOffset[column] += customHeight + cellPadding
                column = yOffset[0] > yOffset[1] ? 1 : 0
                
                let attributes = UICollectionViewLayoutAttributes(
                    forCellWith:indexPath)
                attributes.frame = frame
                cache.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
            }
        }
    }

//    override func prepare() {
//        guard cache.isEmpty == true, let collectionView = collectionView
//        else { return }
//
//        let columnWidth = contentWidth / 2 - cellPadding / 2
//        let xOffset: [CGFloat] = [0.0, columnWidth + cellPadding]
//
//        var column = 0
//        var yOffset: [CGFloat] = [0, 0]
//
//        for section in 0..<collectionView.numberOfSections {
//
//            let headerAttr = UICollectionViewLayoutAttributes(
//                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                with: IndexPath(row: 0, section: section))
//
//            headerAttr.frame = CGRect(x: 0,
//                                      y: yOffset[0],
//                                      width: contentWidth,
//                                      height: headerHeigh)
//            cache.append(headerAttr)
//
//            yOffset[0] = headerAttr.frame.maxY + cellPadding / 2
//            yOffset[1] = headerAttr.frame.maxY + cellPadding / 2
//
//            let countRow = collectionView.numberOfItems(inSection: section)
//            column = 0
//
//            switch countRow {
//            case 5:
//                for row in 0..<countRow {
//                    let indexPath = IndexPath(item: row, section: section)
//                    var frame = CGRect.zero
//
//                    if row == 0 {
//                        let height = rowHeigh * 2 + cellPadding
//                        frame = CGRect(
//                            x: xOffset[column],
//                            y: yOffset[column],
//                            width: columnWidth,
//                            height: height)
//                        yOffset[column] += height + cellPadding
//                    } else {
//                        frame = CGRect(
//                            x: xOffset[column],
//                            y: yOffset[column],
//                            width: columnWidth,
//                            height: rowHeigh)
//                        yOffset[column] += rowHeigh + cellPadding
//                        column = 1
//                    }
//
//                    let attributes = UICollectionViewLayoutAttributes(
//                        forCellWith:indexPath)
//                    attributes.frame = frame
//                    cache.append(attributes)
//                }
//            case 4, 3, 2:
//                for row in 0..<countRow {
//                    let indexPath = IndexPath(item: row, section: section)
//
//                    let frame = CGRect(
//                        x: xOffset[column],
//                        y: yOffset[column],
//                        width: columnWidth,
//                        height: rowHeigh)
//                    yOffset[column] += rowHeigh + cellPadding
//                    column = column == 0 ? 1 : 0
//
//                    let attributes = UICollectionViewLayoutAttributes(
//                        forCellWith:indexPath)
//                    attributes.frame = frame
//                    cache.append(attributes)
//                }
//
//            case 1:
//                let frame = CGRect(
//                    x: xOffset[column],
//                    y: yOffset[column],
//                    width: contentWidth,
//                    height: rowHeigh)
//
//                let attributes = UICollectionViewLayoutAttributes(
//                    forCellWith: IndexPath(item: 0, section: section))
//                attributes.frame = frame
//                cache.append(attributes)
//            default: break
//            }
//        }
//    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Loop through the cache and look for items in the rect
        for attributes in cache {

            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
//        visibleLayoutAttributes[8].frame.size.width = contentWidth
        return visibleLayoutAttributes
    }
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        <#code#>
//    }
    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        let attr = cache[indexPath.item]
//        if indexPath.item == cache.count - 1 {
//            print(indexPath.item)
//        }
//      return attr
//    }
    
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
//        guard let boundaries = boundaries(forSection: indexPath.section) else { return layoutAttributes }
//        guard let collectionView = collectionView else { return layoutAttributes }
//
//        // Helpers
//        let contentOffsetY = collectionView.contentOffset.y
//        var frameForSupplementaryView = layoutAttributes.frame
//
//        let minimum = boundaries.minimum - frameForSupplementaryView.height
//        let maximum = boundaries.maximum - frameForSupplementaryView.height
//
//        if contentOffsetY < minimum {
//            frameForSupplementaryView.origin.y = minimum
//        } else if contentOffsetY > maximum {
//            frameForSupplementaryView.origin.y = maximum
//        } else {
//            frameForSupplementaryView.origin.y = contentOffsetY
//        }
//
//        layoutAttributes.frame = frameForSupplementaryView
//
//        return layoutAttributes
//    }
    
//    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
//        // Helpers
//        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
//
//        // Exit Early
//        guard let collectionView = collectionView else { return result }
//
//        // Fetch Number of Items for Section
//        let numberOfItems = collectionView.numberOfItems(inSection: section)
//
//        // Exit Early
//        guard numberOfItems > 0 else { return result }
//
//        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
//           let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
//            result.minimum = firstItem.frame.minY
//            result.maximum = lastItem.frame.maxY
//
//            // Take Header Size Into Account
//            result.minimum -= 30 // headerReferenceSize.height
//            result.maximum -= 30 //headerReferenceSize.height
//
//            // Take Section Inset Into Account
//            result.minimum -= 5 //sectionInset.top
//            result.maximum += 5 + 5 //(sectionInset.top + sectionInset.bottom)
//        }
//
//        return result
//    }

//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//
//        switch elementKind {
//        case UICollectionView.elementKindSectionHeader:
//            print(elementKind)
//
////            guard let header = collectionView.dequeueReusableSupplementaryView(
////                ofKind: elementKind,
////                withReuseIdentifier: HeaderCollectionView.identifireCell,
////                for: indexPath) as? HeaderCollectionView
////            else { return UICollectionReusableView() }
////
////            header.tittleLabel.text = group[indexPath.section]
////            return header
//
//        default:  fatalError("Unexpected element kind")
//        }
//        return UICollectionViewLayoutAttributes()
//    }
}
