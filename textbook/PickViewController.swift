//
//  PickViewController.swift
//  textbook
//
//  Created by John Wong on 4/22/15.
//  Copyright (c) 2015 John Wong. All rights reserved.
//

import UIKit

class PickViewController: UICollectionViewController {
    
    struct StoryBoard {
        struct Cells {
            static let cell = "Cell"
        }
        
        struct SectionHeader {
            static let Identifier = "SectionHeader"
            static let LabelTag = 100
        }
        
        struct Segues {
//            static let showDetail = "showDetail"
        }
    }

    var categoryRequest = CategoryRequest()
    var categoryItems = Array<CategoryItem>()
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.segmentedControl.isHidden = true
        self.segmentedControl.addTarget(self, action: #selector(PickViewController.onSegmentedControlChanged), for: UIControlEvents.valueChanged)
        self.reloadData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.cancelSGProgress()
    }
    
    func reloadData() {
        self.categoryRequest.loadWithCompletion(
            {
                [unowned self](dict, error) -> Void in
                if let dict = dict {
                    self.categoryItems = CategoryItem.arrayWithDict(dict)
                    self.reloadViews()
                } else {
                    AppConfiguration.showError("数据加载失败", subtitle: error?.localizedDescription)
                }
            }, progress: {
                [unowned self](percent) -> Void in
                self.navigationController?.setSGProgressPercentage(percent, andTitle: "加载中...")
            })
    }
    
    func reloadViews() {
        segmentedControl.removeAllSegments()
        segmentedControl.isHidden = false
        for category in categoryItems {
            segmentedControl.insertSegment(withTitle: category.name, at: segmentedControl.numberOfSegments, animated: true)
        }        
        segmentedControl.selectedSegmentIndex = 0
        self.collectionView?.reloadData()
    }
    
    func onSegmentedControlChanged() {
        self.collectionView?.contentOffset = CGPoint(x: 0, y: 0)
        self.collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if categoryItems.count > segmentedControl.selectedSegmentIndex {
            return categoryItems[segmentedControl.selectedSegmentIndex].items.count
        } else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItems[segmentedControl.selectedSegmentIndex].items[section].rows.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryBoard.Cells.cell, for: indexPath) as! CategoryCell
        cell.setItem(categoryItems[segmentedControl.selectedSegmentIndex].items[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StoryBoard.SectionHeader.Identifier, for: indexPath) 
        let label = header.viewWithTag(StoryBoard.SectionHeader.LabelTag) as? UILabel
        label?.text = categoryItems[segmentedControl.selectedSegmentIndex].items[(indexPath as NSIndexPath).section].header
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = categoryItems[segmentedControl.selectedSegmentIndex].items[(indexPath as NSIndexPath).section].rows[(indexPath as NSIndexPath).row]
        UserDefaults.setObject(item, forKey: UserDefaults.Keys.selectedBook)
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: AppConfiguration.Notifications.BookUpdate), object: nil))
        self.navigationController?.popViewController(animated: true)
    }

}
