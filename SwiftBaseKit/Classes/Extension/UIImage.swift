import UIKit

public extension UIImage {

    /// 初始化 UIImage
    ///
    /// - Parameter view: 视图
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            if let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
                self.init(cgImage: cgImage)
                UIGraphicsEndImageContext()
                return
            }
        }
        self.init()
    }
    
    /// 初始化 UIImage
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), imageScale: CGFloat = 0.0) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, imageScale)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    /// 改变 UIImage 主色调
    ///
    /// - Parameter color: 颜色
    /// - Returns: 着色后的 UIImage
    func tinted(color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        color.set()
        UIRectFillUsingBlendMode(rect, .sourceAtop)
        let tintImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return tintImage
    }
    
    /// 旋转 UIImage
    ///
    /// - Parameter rotationAngle: 旋转角度
    /// - Returns: 旋转后的 UIImage
    func rotated(by rotationAngle: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: self.size))
        rotatedViewBox.transform = CGAffineTransform(rotationAngle: rotationAngle)
        
        let size = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(size)
        
        if let bitmap = UIGraphicsGetCurrentContext() {
            bitmap.translateBy(x: size.width / 2.0, y: size.height / 2.0)
            bitmap.rotate(by: rotationAngle)
            bitmap.scaleBy(x: 1.0, y: -1.0)
            
            let origin = CGPoint(x: -self.size.width / 2.0, y: -self.size.height / 2.0)
            
            bitmap.draw(cgImage, in: CGRect(origin: origin, size: self.size))
        }
        
        if let newImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return newImage
        } else {
            UIGraphicsEndImageContext()
            return nil
        }
    }
    
    /// 伸缩 UIImage
    ///
    /// - Parameter size: 图片大小
    /// - Returns: 伸缩后的图片
    func resize(size: CGSize) -> UIImage? {
        var width = self.size.width
        var height = self.size.height
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        
        let scaleX = width/size.width
        let scaleY = height/size.height
        
        width /= min(scaleX, scaleY)
        height /= min(scaleX, scaleY)
        
        let originX = (size.width - width) / 2.0
        let originY = (size.height - height) / 2.0
        self.draw(in: CGRect(x: originX, y: originY, width: width, height: height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    /// 标准化 UIImage, 去除旋转影响
    ///
    /// - Returns: 标准化后的 UIImage
    func normalized() -> UIImage? {
        if (self.imageOrientation == UIImage.Orientation.up) {
            return self;
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.draw(in: rect)
        
        if let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return nil
        }
    }
    
    /// 裁剪 UIImage
    ///
    /// - Parameter bounds: 裁剪范围
    /// - Returns: 裁剪后的 UIImage
    func cropped(bounds: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: bounds) else { return nil }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    /// 返回 UIImage 像素数据
    ///
    /// - Returns: UIImage 像素数据
    func pixelData() -> [UInt8]? {
        let size = self.size
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
        guard let cgImage = self.cgImage else { return nil }
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        return pixelData
    }
    
}
