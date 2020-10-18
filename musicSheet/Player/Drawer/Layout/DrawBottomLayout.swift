//
//  DrawBottomLayout.swift
//  musicSheet
//
//  Created by Jz D on 2020/8/11.
//  Copyright © 2020 Jz D. All rights reserved.
//

import UIKit


enum TableOption: String {
  case top
  case cover
  case cell
  
  var kind: String {
      switch self{
      case .top:
          return UICollectionReusableView.addTop
      case .cover:
          return "cover"
      default:
          return ""
      }
  }
}




enum Component: String {
  case top
  case header
  case cell
  
  var kind: String {
      switch self{
      case .top:
          return UICollectionReusableView.addTop
      case .header:
          return UICollectionReusableView.header
      default:
          return ""
      }
  }
}


class DrawBottomLayout: UICollectionViewLayout {

    private var cache = [TableOption: [IndexPath: UICollectionViewLayoutAttributes]]()
    
    
    let itemSize = CGSize(width: 144, height: 50)
    
    private var oldBounds = CGRect.zero
    
    private var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    
    
    private var zIndex = 1
    
    
    private var collectionViewHeight: CGFloat {
       collectionView!.frame.height
    }
    
    private var collectionViewWidth: CGFloat {
       collectionView!.frame.width
    }
    
    override public var collectionViewContentSize: CGSize {
        CGSize(width: collectionViewWidth, height: itemSize.height)
    }
    
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView, collectionView.numberOfItems(inSection: 0) > 0 else {
            return
        }
        
        prepareCache()
        oldBounds = collectionView.bounds
        zIndex = 2
        
        register(DrawBottomCoverView.self, forDecorationViewOfKind: TableOption.cover.kind)
        
        
        
        var xOffset: CGFloat = 0
        for item in 0...4 {
              let cellIndexPath = IndexPath(item: item, section: 0)
              let attributes = UICollectionViewLayoutAttributes(forCellWith: cellIndexPath)
              attributes.frame = CGRect(x: xOffset,
                                        y: Pen.reimburse,
                                        width: itemSize.width,
                                        height: itemSize.height)
              
              cache[.cell]?[cellIndexPath] = attributes
              attributes.zIndex = zIndex
              xOffset += itemSize.width
               
              zIndex += 1
        }
        
        
        let first = IndexPath(item: 0, section: 0)
        let headerAttributes = UICollectionViewLayoutAttributes(
                                  forSupplementaryViewOfKind: Component.top.kind,
                                  with: first)
        headerAttributes.zIndex = zIndex
        let headerAttributesWidth = UI.width - itemSize.width * 6 - 1
     
        xOffset = UI.width - itemSize.width - headerAttributesWidth
        headerAttributes.frame = CGRect(x: xOffset,
                                        y: Pen.reimburse,
                                        width: headerAttributesWidth,
                                        height: itemSize.height)
        
        cache[.top]?[first] = headerAttributes
        zIndex += 1
        
        
        let cellIndexPathLast = IndexPath(item: 5, section: 0)
        let attributesLast = UICollectionViewLayoutAttributes(forCellWith: cellIndexPathLast)
        
        xOffset = UI.width - itemSize.width
        attributesLast.frame = CGRect(x: xOffset,
                                  y: Pen.reimburse,
                                  width: itemSize.width,
                                  height: itemSize.height)
        attributesLast.zIndex = zIndex
        cache[.cell]?[cellIndexPathLast] = attributesLast
        
        
        let coverIndexPath = IndexPath(item: 0, section: 0)
        let attributeCover = UICollectionViewLayoutAttributes(forDecorationViewOfKind: TableOption.cover.kind, with: coverIndexPath)
        
        attributeCover.frame = CGRect(x: 0,
                                  y: Pen.reimburse,
                                  width: collectionViewWidth,
                                  height: itemSize.height)
        attributeCover.zIndex = 1
        cache[TableOption.cover]?[coverIndexPath] = attributeCover
       
        
    }
    
    
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[.cover]?[indexPath]
    }
  
   
    public override func layoutAttributesForSupplementaryView(ofKind ComponentKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      switch ComponentKind {
      case Component.top.kind:
        return cache[.top]?[indexPath]
      default:
        return nil
      }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
      return cache[.cell]?[indexPath]
    }
    

    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
          visibleLayoutAttributes.removeAll(keepingCapacity: true)
          for (_, infos) in cache {
                for (_, attributes) in infos {
                    visibleLayoutAttributes.append(attributes)
                }
          }
          return visibleLayoutAttributes
    }
    
    
    

}



extension DrawBottomLayout{
    private func prepareCache(){
      cache.removeAll(keepingCapacity: true)
      cache[.top] = [IndexPath: UICollectionViewLayoutAttributes]()
      cache[.cell] = [IndexPath: UICollectionViewLayoutAttributes]()
      cache[.cover] = [IndexPath: UICollectionViewLayoutAttributes]()
    }
}
