//
//  YLPageView.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/17.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

class YLPageView: UIView {

    // MARK: 定义属性
    fileprivate var style: YLPageStyle
    fileprivate var titles: [String]
    fileprivate var childVcs: [UIViewController]
    fileprivate var parentVc: UIViewController
    
    // MARK: 构造函数
    init(frame: CGRect, style: YLPageStyle, titles: [String], childVcs: [UIViewController], parentVc: UIViewController) {
        // 在super.init()之前，需要保证所有的属性有被初始化
        self.style = style
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setUpUI()
    }
    
    // 在swift中，如果子类有自定义构造函数，或者覆盖父类的构造函数，那么必须实现父类中使用required修饰的构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension YLPageView {
    fileprivate func setUpUI() {
        
        // 创建titleView
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
        let titleView = YLTitleView(frame: titleFrame, style: style, titles: titles)
        titleView.backgroundColor = UIColor(r: 80, g: 200, b: 100)
        addSubview(titleView)
        
        // 创建contentView
        let contentFrame = CGRect(x: 0, y: style.titleHeight, width: bounds.width, height: bounds.height - style.titleHeight)
        let contentView = YLContentView(frame: contentFrame, childVcs: childVcs, parentVc: parentVc)
        contentView.backgroundColor = UIColor.cyan
        addSubview(contentView)
        
        // 让titleView与contnetView交互
        titleView.delegate = contentView
        contentView.delegate = titleView
        
    }
}
