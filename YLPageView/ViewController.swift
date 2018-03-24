//
//  ViewController.swift
//  YLPageView
//
//  Created by 谢英亮 on 2018/3/24.
//  Copyright © 2018年 ylxie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hexString: "##50bbf8")
        automaticallyAdjustsScrollViewInsets = false
        
        let statusBarFrame: CGRect = UIApplication.shared.statusBarFrame
        let navigationBarFrame: CGRect = (self.navigationController?.navigationBar.frame)!
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "YLPageView"
        
        var style = YLPageStyle()
        style.isShowBottomLine = true
        style.isScrollEnable = true
        //        style.isScaleEnable = true
        style.isShowCoverView = true
        
        
        let titles = ["推荐","王者荣耀","绝地求生","LOL","一起看","星秀","娱乐"]
        
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc  = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor
            childVcs.append(vc)
            
        }
        
        let headerHeight: CGFloat = statusBarFrame.height + navigationBarFrame.height
        let pageFrame = CGRect(x: 0, y:headerHeight , width: view.bounds.width, height: view.bounds.height - headerHeight)
        let pageView = YLPageView(frame: pageFrame, style: style, titles: titles, childVcs: childVcs, parentVc: self)
        pageView.backgroundColor = UIColor.blue
        view.addSubview(pageView)
    }
}

