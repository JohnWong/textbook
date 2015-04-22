//
//  CategoryCell.swift
//  textbook
//
//  Created by John Wong on 4/22/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    func setItem(item: CollectItem) {
        image.setImageWithURL(NSURL(string: item.img), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        label.text = item.title
    }
}
