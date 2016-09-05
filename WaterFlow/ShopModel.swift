//
//  ShopModel.swift
//  WaterFlow
//
//  Created by zhoucj on 16/9/5.
//  Copyright © 2016年 zhoucj. All rights reserved.
//

import UIKit

class ShopModel: NSObject {
    var w: NSNumber?
    var img: String?
    var price: String?
    var h: NSNumber?

    init(dict: [String: AnyObject]){
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {

    }
    override var description : String {
        let pops = ["h", "img", "price", "w"]
        let dict = dictionaryWithValuesForKeys(pops)
        return "\(dict)"
    }
    static let shops: [ShopModel] = ShopModel.loadAllShop()
    class func loadAllShop()->[ShopModel] {
        let path = NSBundle.mainBundle().pathForResource("shops.plist", ofType: nil)
        guard let filepath = path else{
            return [ShopModel]()
        }
        let dict = NSArray(contentsOfFile: filepath)!
        var shops = [ShopModel]()
        for i in 0..<dict.count {
            let shop = ShopModel(dict: dict[i] as! [String: AnyObject])
            shops.append(shop)
        }
        return shops
    }
}
