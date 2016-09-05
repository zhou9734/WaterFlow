//
//  WFViewController.swift
//  WaterFlow
//
//  Created by zhoucj on 16/9/5.
//  Copyright © 2016年 zhoucj. All rights reserved.
//

import UIKit
let WaterFlowReuseIdentifier = "WaterFlowReuseIdentifier"

class WFViewController: UIViewController {

    var shops = [ShopModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "瀑布流"
        setupLayout()
        setupRefresh()
    }
    private func setupLayout(){
        view.addSubview(collectionView)
    }
    private func setupRefresh(){
        collectionView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: Selector("loadNewShops"))
        collectionView.header.beginRefreshing()
        collectionView.footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: Selector("loadMoreShops"))
        collectionView.footer.hidden = true
    }
    @objc private func loadNewShops(){
        self.shops.removeAll()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue()) { () -> Void in
            self.shops = ShopModel.shops
            // 刷新数据
            self.collectionView.reloadData()
            self.collectionView.header.endRefreshing()
        }

    }
    @objc private func loadMoreShops(){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue()) { () -> Void in
             self.shops += ShopModel.shops
            // 刷新数据
            self.collectionView.reloadData()
            self.collectionView.footer.endRefreshing()
        }
    }

    private lazy var collectionView: UICollectionView = {
        let waterflow = WaterFlowLayout()
        waterflow.delegate = self
        let clv = UICollectionView(frame: self.view.bounds, collectionViewLayout: waterflow)
        clv.registerNib(UINib(nibName: "ShopCell", bundle: nil) , forCellWithReuseIdentifier: WaterFlowReuseIdentifier)
        clv.backgroundColor = UIColor.whiteColor()
        clv.dataSource = self
        return clv
    }()
}
extension WFViewController: UICollectionViewDataSource{
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionView.footer.hidden = self.shops.count == 0
        return shops.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(WaterFlowReuseIdentifier, forIndexPath: indexPath) as! ShopCell
        cell.shop = shops[indexPath.item]
        return cell
    }
}
extension WFViewController: WaterFlowLayoutDelegate{
    func waterflowLayout(waterFlow: WaterFlowLayout, heightForItemAtIndex index: Int, itemWidth: CGFloat) -> CGFloat {
        let shop = shops[index]
        return itemWidth * CGFloat(shop.h!) / CGFloat(shop.w!)
    }
}
