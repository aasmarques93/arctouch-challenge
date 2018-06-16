//
//  CollectionView.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

import UIKit

@objc protocol CollectionViewDelegate: class {
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    @objc optional func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    @objc optional func didSelect(_ collectionView: UICollectionView, itemAt indexPath: IndexPath)
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView)
    @objc optional func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
}

class CollectionView: UICollectionView {
    @IBInspectable var numberOfColumns: CGFloat = 2
    @IBInspectable var itemHeight: CGFloat = 70
    @IBInspectable var itemWidth: CGFloat = 70
    @IBInspectable var isHorizontal: Bool = false
    @IBInspectable var margin: CGFloat = 2
    
    weak var collectionDelegate: CollectionViewDelegate!
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
        
        if !isHorizontal {
            configureCollectionViewLayout()
            showsVerticalScrollIndicator = false
            showsHorizontalScrollIndicator = false
        }
    }
    
    func numberOfLines(totalObjects: Int) -> Int {
        var lines = totalObjects / Int(numberOfColumns)
        if totalObjects % 2 != 0 { lines += 1 }
        return lines
    }
    
    private func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        itemWidth = (SCREEN_WIDTH - (margin * numberOfColumns + 1)) / numberOfColumns
        itemWidth -= margin / 2
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.minimumInteritemSpacing = margin
        layout.minimumLineSpacing = margin
        
        collectionViewLayout = layout
    }
}

extension CollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionDelegate.numberOfSections(in: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionDelegate.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionDelegate.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin,
                            left: margin,
                            bottom: margin,
                            right: margin)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionDelegate.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionDelegate.scrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionDelegate.scrollViewDidEndDecelerating?(scrollView)
    }
}

extension CollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let method = collectionDelegate.didSelect { method(collectionView, indexPath) }
    }
}
