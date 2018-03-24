//
//  YLPageStyle.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/17.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

struct YLPageStyle {
    
    var titleHeight: CGFloat = 44
    var normalColor: UIColor = UIColor.white
    var selectedColor: UIColor = UIColor.orange
    var fontSize: CGFloat = 15.0
    var titleMargin: CGFloat = 30
    
    /// 是否可以滚动
    var isScrollEnable: Bool = false
    
    /// 是否显示滚动条
    var isShowBottomLine: Bool = false
    var bottomLineColor: UIColor = UIColor.orange
    var bottomLineHeight: CGFloat = 2
    
    /// 是否需要缩放
    var isScaleEnable: Bool = false
    var maxScale: CGFloat = 1.2
    
    /// 是否显示遮盖
    var isShowCoverView: Bool = false
    var coverBgColor: UIColor = UIColor.black
    var coverAlpha: CGFloat = 0.4
    var coverMargin: CGFloat = 8
    var coverHeight: CGFloat = 25
    var coverRadius: CGFloat = 12
}
