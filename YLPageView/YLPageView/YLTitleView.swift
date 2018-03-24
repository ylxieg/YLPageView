 //
//  YLTitleView.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/17.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit


protocol YLTitleViewDelegate: class{
    func titleView(_ pageView: YLTitleView, currentIndex: Int)
}

class YLTitleView: UIView {

    // MARK: 定义属性
    weak var delegate: YLTitleViewDelegate?
    
    fileprivate var style: YLPageStyle
    fileprivate var titles: [String]
    fileprivate var currentIndex: Int = 0
    
    typealias ColorRGB = (red: CGFloat, green: CGFloat, blue: CGFloat)
    fileprivate lazy var titleLabels: [UILabel] = [UILabel]()
    fileprivate lazy var normalRGB: ColorRGB = style.normalColor.getRGB()
    fileprivate lazy var selectedRGB: ColorRGB = style.selectedColor.getRGB()
    fileprivate lazy var deltaRGB: ColorRGB = {
        let deltaR = self.selectedRGB.red - self.normalRGB.red
        let deltaG = self.selectedRGB.green - self.normalRGB.green
        let deltaB = self.selectedRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
    }()
    fileprivate lazy var coverView: UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        return coverView
    }()
    fileprivate lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    // MARK: 构造函数
    init(frame: CGRect, style: YLPageStyle, titles: [String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension YLTitleView {
    
    // MARK: 设置UI
    fileprivate func setUpUI() {
        // 添加一个UIScrollView
        addSubview(scrollView)
        
        // 展示title
        setUpTitleLabels()
        
        // 设置label的frame
        setUpLabelsFrame()
        
        setUpBottomLine()
        
        setUpCoverView()
    }
    
    private func setUpCoverView() {
        guard style.isShowCoverView else {
            return
        }
        
        scrollView.insertSubview(coverView, at: 0)
        let firstLabel = titleLabels.first!
        var coverW = firstLabel.bounds.width
        let coverH = style.coverHeight
        var coverX = firstLabel.frame.origin.x
        let coverY = (firstLabel.frame.height - coverH) * 0.5
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += 2 * style.coverMargin
        }
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
    }
    
    private func setUpBottomLine() {
        guard style.isShowBottomLine else {
            return
        }
        
        scrollView.addSubview(bottomLine)
        
        bottomLine.frame.origin.x = titleLabels.first!.frame.origin.x
        bottomLine.frame.size.width = titleLabels.first!.frame.width
    }
    
    private func setUpLabelsFrame() {
        
        let labelH = style.titleHeight
        var labelW: CGFloat = 0
        let labelY: CGFloat = 0
        var labelX: CGFloat = 0
        
        let count = titleLabels.count
        for (i, titleLabel) in titleLabels.enumerated() {

            if style.isScrollEnable {
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : titleLabel.font], context: nil).width
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i-1].frame.maxX + style.titleMargin)
            }else{
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            }
            titleLabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        // 设置scale属性
        if style.isScaleEnable{
            // ?.在等号的左边，那么系统会自动判断可选类型是否有值
            // ？.在等号的右边，那么如果可选类型没值，该语句返回nil
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        
        // 设置contentSize
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    private func setUpTitleLabels() {
        for (i ,title) in titles.enumerated() {
            // 创建Label
            let label = UILabel()
            
            // 设置label属性
            label.tag = i;
            label.text = title;
            label.textColor = i == 0 ? style.selectedColor : style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            // 将label添加到scrollView上
            scrollView.addSubview(label)
            
            // 将label添加到数组中
            titleLabels.append(label)
            
            // 监听label的点击
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
        }
    }
}

// MARK: 点击事件
extension YLTitleView {
    // @objc 如果在函数前面加载@objc，那么会保留OC的特性
    // OC在调用方法时，本质是发送消息
    // 将方法包装成@SEL --> 根据 @SEL去类中的方法映射表 --> IMP指针
    @objc fileprivate func titleLabelClick(_ tapGes: UITapGestureRecognizer) {
        // 校验Label
        guard let targetLabel = tapGes.view as? UILabel else {
            return
        }
        
        guard targetLabel.tag != currentIndex else {
            return
        }
        // 取出原来的label
        let sourceLabel = titleLabels[currentIndex]
        
        // 改变label的颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectedColor
        
        // 记录最新的index
        currentIndex = targetLabel.tag
        
        // 让点击的label居中显示
        adjustLabelPosition(targetLabel)
        
        // 通知代理
        delegate?.titleView(self, currentIndex: currentIndex)
        
        // 调整scale缩放
        if  style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: {
                sourceLabel.transform = CGAffineTransform.identity
                targetLabel.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        // 调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetLabel.frame.origin.x
                self.bottomLine.frame.size.width = targetLabel.frame.width
            })
        }
        
        // 调整coverView
        if style.isShowCoverView {
            let coverX = style.isScrollEnable ? (targetLabel.frame.origin.x - style.coverMargin) : targetLabel.frame.origin.x
            let coverW = style.isScrollEnable ? (targetLabel.frame.width + style.coverMargin * 2) : targetLabel.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
    
    fileprivate func adjustLabelPosition(_ targetLabel: UILabel) {
        guard style.isScrollEnable else {
            return
        }
        
        // 计算offsetX
        var offsetX =  targetLabel.center.x - bounds.width * 0.5
        
        // 临界值判断
        if offsetX < 0 {
            offsetX = 0
        }
        
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        // 设置scrollView的contentOffset
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}

extension YLTitleView: YLContentViewDelegate {
    func contentView(_ contentView: YLContentView, inIndex: Int) {
        // 记录最新的currentIndex
        currentIndex = inIndex
        
        // 让targetLabel居中显示
        adjustLabelPosition(titleLabels[currentIndex])
    }
    
    func contentView(_ contentView: YLContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        // 获取soureLabel&targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 颜色渐变
        sourceLabel.textColor = UIColor(r: selectedRGB.red - progress * deltaRGB.red, g: selectedRGB.green - progress * deltaRGB.green, b: selectedRGB.blue - progress * deltaRGB.blue)
        targetLabel.textColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        
        // 调整scale
        if style.isScaleEnable {
            let deltaScale = style.maxScale - 1.0
            
            sourceLabel.transform = CGAffineTransform(scaleX: style.maxScale - progress * deltaScale, y: style.maxScale - progress * deltaScale)
            targetLabel.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        // 调整bottomLine
        if style.isShowBottomLine {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            bottomLine.frame.origin.x = sourceLabel.frame.origin.x + progress * deltaX
            bottomLine.frame.size.width = sourceLabel.frame.width + progress * deltaW
        }
        
        // coverView调整
        if style.isShowCoverView {
            let deltaX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
            let deltaW = targetLabel.frame.width - sourceLabel.frame.width
            
            coverView.frame.size.width = style.isScrollEnable ? (sourceLabel.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceLabel.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceLabel.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceLabel.frame.origin.x + deltaX * progress)
            
            
        }
    }
}




