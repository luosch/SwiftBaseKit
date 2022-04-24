import UIKit

public class Util: NSObject {

    /// Document 目录
    public static var documentsPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }
    
    /// Library 目录
    public static var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
    }
    
    /// Caches 目录
    public static var cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
    }
    
    /// 根据文件大小返回可读的字符串
    public static func formattedSize(size: UInt) -> String {
        let kb = Double(size) / 1024
        let mb = Double(size) / 1024.0 / 1024.0
        let gb = Double(size) / 1024.0 / 1024.0 / 1024.0
        
        if gb > 1.0 {
            return String(format: "%.1lfG", gb)
        }
        
        if mb > 1.0 {
            return String(format: "%.1lfM", mb)
        }
        
        if kb > 1.0 {
            return String(format: "%.1lfK", kb)
        }
        
        return "0K"
    }
    
    /// 返回格式化的时间字符串
    public static func formattedTime(from time: Int) -> String {
        let hours = time / 3600
        let minutes = time / 60 % 60
        let seconds = time % 60
        
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    /// 返回格式化的时间字符串
    public static func formattedMinuteTimeString(from time: Int) -> String {
        let minutes = (time / 60)
        let seconds = time % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    /// 返回最顶层的 view controller
    public static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
    
    /// 本地化的app名称
    public static func appName() -> String {
        if let appName = Bundle.main.localizedInfoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        } else if let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return appName
        } else {
            return Bundle.main.infoDictionary?["CFBundleName"] as! String
        }
    }
    
    /// 版本号
    public static func appVersion() -> String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    
    /// 国家代码
    public static func countryCode() -> String {
        return NSLocale.current.regionCode ?? ""
    }
    
    /// 语言代码
    public static func languageCode() -> String {
        let supportLangs = ["en", "zh-Hans", "zh-Hant", "ja", "ko", "fr", "de", "es", "it", "pt", "ru", "nl", "da", "nb", "sv", "pl", "tr", "ar", "th", "cs", "hu", "ca", "hr", "el", "he", "ro", "sk", "uk", "id", "ms", "vi", "hi"]
        let languageCode = NSLocale.preferredLanguages.first ?? ""
        
        // 简体中文和繁体中文特殊处理
        if languageCode.starts(with: "zh") {
            if languageCode.starts(with: "zh-Hans") {
                // 简体中文
                return "zh-Hans"
            } else {
                // 繁体中文
                return "zh-Hant"
            }
        }
        
        // 除了简体中文和繁体中文以外的语言
        for lang in supportLangs {
            if languageCode.starts(with: lang) {
                return lang
            }
        }
        
        return languageCode
    }
    
    /// 计算两个点的中点
    ///
    /// - Parameters:
    ///   - pointA: 点A
    ///   - pointB: 点B
    /// - Returns: 中点
    static public func middlePoint(_ pointA: CGPoint, _ pointB: CGPoint) -> CGPoint {
        return CGPoint(x: (pointA.x+pointB.x)*0.5, y: (pointA.y+pointB.y)*0.5)
    }
    
    /// 计算两个点的距离
    ///
    /// - Parameters:
    ///   - pointA: 点A
    ///   - pointB: 点B
    /// - Returns: 距离
    static public func distance(_ pointA: CGPoint, _ pointB: CGPoint) -> CGFloat {
        let disX = abs(pointA.x - pointB.x)
        let disY = abs(pointA.y - pointB.y)
        
        return sqrt(disX*disX + disY*disY)
    }
    
    /// 是否有安全区Insets
    public static var hasSafeAreaInsets: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets != .zero
        }
        return false
    }
    
    /// 安全区
    public static var safeAreaInsets: UIEdgeInsets {
        if #available(iOS 11.0, tvOS 11.0, *) {
            if let safeAreaInsets = UIApplication.shared.delegate?.window??.safeAreaInsets {
                return safeAreaInsets
            }
        }
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
    
    /// 是否有刘海
    public static var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            if let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom {
                return bottom > 0
            }
        }
        return false
    }
    
    /// 返回区间内的值
    public static func clamp(_ value: CGFloat, _ minimumValue: CGFloat, _ maximumValue: CGFloat) -> CGFloat {
        return min(maximumValue, max(value, minimumValue))
    }
    
    /// 判断设备是否为 iPad
    public static func isPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    /// 屏幕宽度
    public static var screenWidth: CGFloat {
        return min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
        
    /// 屏幕高度
    public static var screenHeight: CGFloat {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
    }
    
    /// 震动反馈
    public static func impactFeedback() {
        if #available(iOS 10.0, *) {
            let lightImpactFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
            lightImpactFeedbackGenerator.prepare()
            lightImpactFeedbackGenerator.impactOccurred()
        }
    }
    
}

/// Logging
public func po(_ items: Any...,
    file: String = #file,
    method: String = #function,
    line: Int = #line)
{
    #if DEBUG
    var output = ""
    for item in items {
        output += "\(item) "
    }
    output += "\n"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = dateFormatter.string(from: Date())
    print("\(timestamp) | \((file as NSString).lastPathComponent)[\(line)] > \(method): ")
    print(output)
    #endif
}

public func DLog(_ items: Any...,
    file: String = #file,
    method: String = #function,
    line: Int = #line)
{
    #if DEBUG
    var output = ""
    for item in items {
        output += "\(item) "
    }
    output += "\n"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss:SSS"
    let timestamp = dateFormatter.string(from: Date())
    print("\(timestamp) | \((file as NSString).lastPathComponent)[\(line)] > \(method): ")
    print(output)
    #endif
}

/// Localizations
public func Localize(_ text: String) -> String {
    return NSLocalizedString(text, tableName: "i18n", bundle: Bundle.main, value: "", comment: "")
}
