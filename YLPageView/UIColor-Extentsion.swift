//
//  UIColor-Extentsion.swift
//  YLLive
//
//  Created by 谢英亮 on 2018/3/21.
//  Copyright © 2018年 谢英亮. All rights reserved.
//

import UIKit

// MARK: 全局函数
//func randomColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
//    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
//}

/*
 函数重载:
 1.函数名称相同，但是参数不同(类型不同、个数不同)
 */

extension UIColor {
    
    // MARK: 类方法
    class func randomColorFunc() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    // MARK: 类属性 - 计算属性: 只读属性
    class var randomColor: UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    
    // MARK: 从颜色中获取RGB值
    func getRGB() -> (CGFloat,CGFloat,CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
    
    /*
     在extension中扩充构造函数，只能扩充便利构造函数:
     1.在init前需加上关键字convenience
     2.在自定义的构造函数内部，必须明确的通过self.init()调用其他构造函数
    */
    /// 自定义颜色 - 默认参数
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }
    
    /// 十六进制颜色
    // ff0011
    // oxFF0011
    // ##ff0011
    convenience init?(hexString: String, alpha: CGFloat = 1.0) {
        
        // 判断字符串长度是否符合16进制数
        guard hexString.count >= 5 else {
            return nil
        }
        
        // 将所有字符串转成大写
        var hex = hexString.uppercased()

        // 判断是否以0x/##开头
        if hex.hasPrefix("0x") || hex.hasPrefix("##") {
            hex = (hex as NSString).substring(from: 2)
        }
        
        // 判断是否以#开头
        if hex.hasPrefix("#") {
            hex = (hex as NSString).substring(from: 1)
        }
        
        // 获取RGB的字符串
        var range = NSRange(location: 0, length: 2)
        let rStr = (hex as NSString).substring(with: range)
        
        range.location = 2
        let gStr = (hex as NSString).substring(with: range)
        
        range.location = 4
        let bStr = (hex as NSString).substring(with: range)
        
        // 转成10进制值
        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }
    
}
