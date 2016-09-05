//
//  ShopCell.swift
//  WaterFlow
//
//  Created by zhoucj on 16/9/5.
//  Copyright © 2016年 zhoucj. All rights reserved.
//

import UIKit

class ShopCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    var shop: ShopModel?{
        didSet{
            guard let _shop = shop else{
                return
            }
            imageView.sd_setImageWithURL(NSURL(string: _shop.img!), placeholderImage: UIImage(named: "loading"))
            priceLbl.text = _shop.price
        }
    }


}
