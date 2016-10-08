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
    
    func setItem(_ item: CollectItem) {
        image.setImageWith(URL(string: item.img), usingActivityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        label.text = item.title
    }
}
