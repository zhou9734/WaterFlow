//
//  WaterFlowLayout.swift
//  WaterFlow
//
//  Created by zhoucj on 16/9/5.
//  Copyright © 2016年 zhoucj. All rights reserved.
//

import UIKit

@objc
protocol WaterFlowLayoutDelegate: NSObjectProtocol{
    func waterflowLayout(waterFlow: WaterFlowLayout, heightForItemAtIndex index: Int, itemWidth: CGFloat) -> CGFloat
    optional func columnCountInWaterflowLayout(waterFlow: WaterFlowLayout) -> Int
    optional func columnMarginInWaterflowLayout(waterFlow: WaterFlowLayout) -> CGFloat
    optional func rowMarginInWaterflowLayout(waterFlow: WaterFlowLayout) -> CGFloat
    optional func edgeInsetsInWaterflowLayout(waterFlow: WaterFlowLayout) -> UIEdgeInsets
}

class WaterFlowLayout: UICollectionViewLayout {
    var delegate: WaterFlowLayoutDelegate?
    //默认的列数
    let defaultColumnCount: Int = 3
    //每一列之间的间距
    let defaultColumnMargin: CGFloat = 10
    //每一行之间的间距
    let defaultRowMargin: CGFloat = 10
    //边缘间距
    let defaultEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 10, right: 10)
    //存放所有cell的布局属性
    var attrsArray = [UICollectionViewLayoutAttributes]()
    //存放所有列的当前高度
    var columnHeights = [CGFloat]()
    //内容的高度
    var contentHeight: CGFloat = 0.0
    var columnCount: CGFloat?
    var columnMargin: CGFloat?
    var rowMargin: CGFloat?
    var edgeInsets: UIEdgeInsets?
    //初始化
    override func prepareLayout() {
        super.prepareLayout()
        if let _columnCount = delegate?.columnCountInWaterflowLayout?(self) {
            columnCount = CGFloat(_columnCount)
        }else{
            columnCount = CGFloat(defaultColumnCount)
        }
        if let _columnMargin = delegate?.columnMarginInWaterflowLayout?(self){
            columnMargin = _columnMargin
        }else{
            columnMargin = defaultColumnMargin
        }
        if let _rowMargin = delegate?.rowMarginInWaterflowLayout?(self){
            rowMargin = _rowMargin
        }else{
            rowMargin = defaultRowMargin
        }
        edgeInsets = delegate?.edgeInsetsInWaterflowLayout?(self) ?? defaultEdgeInsets
        contentHeight = 0
        // 清除以前计算的所有高度
        columnHeights.removeAll()
        for _ in 0..<defaultColumnCount{
            columnHeights.append(defaultEdgeInsets.top)
        }
        // 清除之前所有的布局属性
        attrsArray.removeAll()
        // 开始创建每一个cell对应的布局属性
        let count = collectionView!.numberOfItemsInSection(0)
        for i in 0..<count{
            // 创建位置
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            // 获取indexPath位置cell对应的布局属性
            let attrs = layoutAttributesForItemAtIndexPath(indexPath)
            attrsArray.append(attrs!)
        }
    }
    //决定cell的排布
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }
    //返回indexPath位置cell对应的布局属性
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        // 创建布局属性
        let attrs = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        // collectionView的宽度
        let collectionViewW = self.collectionView!.frame.size.width
        // 设置布局属性的frame
        let w  = (collectionViewW - edgeInsets!.left - edgeInsets!.right - (columnCount! - 1) * columnMargin!) / columnCount!
        let h = delegate?.waterflowLayout(self, heightForItemAtIndex: indexPath.item, itemWidth: w)
        // 找出高度最短的那一列
        var destColumn = 0
        var minColumnHeight = columnHeights[0]
        for i in 1..<Int(columnCount!) {
            let columnHeight = self.columnHeights[i]
            if minColumnHeight > columnHeight{
                minColumnHeight = columnHeight
                destColumn = i
            }
        }
        let x = edgeInsets!.left + CGFloat(destColumn) * (w + columnMargin!)
        var y = minColumnHeight
        if y != edgeInsets!.top{
            y += rowMargin!
        }
        attrs.frame = CGRectMake(x, y, w, h!)
        // 更新最短那列的高度
        columnHeights[destColumn] = CGRectGetMaxY(attrs.frame)
        // 记录内容的高度
        let _columnHeight = columnHeights[destColumn]
        if contentHeight < _columnHeight{
            contentHeight = _columnHeight
        }
        return attrs;
    }
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(0, contentHeight + edgeInsets!.bottom)
    }
}