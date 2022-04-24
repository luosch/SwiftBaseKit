//
//  UIView.swift
//  SwiftUtil
//
//  Created by lsc on 2018/5/23.
//

import UIKit

public extension UIView {
    
    /// x 坐标
    var x: CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    /// y 坐标
    var y: CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    /// 最左端坐标
    var left: CGFloat {
        set {
            self.frame = CGRect(x: newValue, y: self.top, width: self.width, height: self.height)
        }
        get {
            return self.frame.origin.x
        }
    }
    
    /// 最顶部坐标
    var top: CGFloat {
        set {
            self.frame = CGRect(x: self.left, y: newValue, width: self.width, height: self.height)
        }
        get {
            return self.frame.origin.y
        }
    }
    
    /// 最右端坐标
    var right: CGFloat {
        set {
            self.frame = CGRect(x: newValue - self.width, y: self.top, width: self.width, height: self.height)
        }
        get {
            return self.left + self.width
        }
    }
    
    /// 最底部坐标
    var bottom: CGFloat {
        set {
            self.frame = CGRect(x: self.left, y: newValue - self.height, width: self.width, height: self.height)
        }
        get {
            return self.top + self.height
        }
    }
    
    /// 中心 x 坐标
    var centerX: CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        get {
            return self.center.x
        }
    }
    
    /// 中心 y 坐标
    var centerY: CGFloat {
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
        get {
            return self.center.y
        }
    }
    
    /// 宽度
    var width: CGFloat {
        set {
            self.frame.size = CGSize(width: newValue, height: self.frame.height)
        }
        get {
            return self.bounds.size.width
        }
    }
    
    /// 高度
    var height: CGFloat {
        set {
            self.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.width, height: newValue))
        }
        get {
            return self.bounds.size.height
        }
    }
    
    /// 宽度的一半
    var halfWidth: CGFloat {
        return self.width / 2
    }
    
    /// 高度的一半
    var halfHeight: CGFloat {
        return self.height / 2
    }
    
    /// 大小
    var size: CGSize {
        set {
            self.frame.size = newValue
        }
        get {
            return self.frame.size
        }
    }
    
}
