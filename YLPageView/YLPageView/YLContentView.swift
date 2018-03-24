//
//  YLContentView.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/17.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

protocol YLContentViewDelegate: class {
    func contentView(_ contentView: YLContentView, inIndex: Int)
    func contentView(_ contentView: YLContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat)
}

private let cellID = "identifier"

class YLContentView: UIView {

    weak var delegate: YLContentViewDelegate?
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isForbidDelegate: Bool = false
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.scrollsToTop = false
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView .register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        return collectionView
    }()
    
    init(frame: CGRect, childVcs: [UIViewController], parentVc: UIViewController) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension YLContentView {
    fileprivate func setUpUI() {
        addSubview(collectionView)
        
        // 将子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc.addChildViewController(childVc)
        }
    }
}


extension YLContentView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            collectionViewDidEndScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {// 如果没有减速
            collectionViewDidEndScroll()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 判断是否需要继续执行
        if  scrollView.contentOffset.x == startOffsetX || isForbidDelegate{
            return
        }
        
        var progress: CGFloat = 0
        let sourceIndex: Int = Int(startOffsetX / collectionView.bounds.width)
        var targetIndex: Int = 0
        
        // 判断用户是左/右滑动
        if collectionView.contentOffset.x > startOffsetX {// 左滑动
            targetIndex = sourceIndex + 1
            progress = (collectionView.contentOffset.x - startOffsetX) / collectionView.bounds.width
        }else{// 右滑动
            targetIndex = sourceIndex - 1
            progress = (startOffsetX - collectionView.contentOffset.x) / collectionView.bounds.width
        }
        
        // 通知代理
        delegate?.contentView(self, sourceIndex: sourceIndex, targetIndex: targetIndex, progress: progress)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func collectionViewDidEndScroll() {
        // 获取位置
        let inIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        // 通知代理
        delegate?.contentView(self, inIndex: inIndex)
    }
}


extension YLContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor
        
        for subView in cell.contentView.subviews {
            subView.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item];
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

extension YLContentView: YLTitleViewDelegate {
    func titleView(_ pageView: YLTitleView, currentIndex: Int) {
        // 设置isForbidDelegate为true
        isForbidDelegate = true
        
        // 根据currentIndex获取indexPath
        let indexPath = IndexPath(item: currentIndex, section: 0)
        
        // 滚动到正确的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
}
