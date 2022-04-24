//
//  FeedbackMailSender.swift
//  SwiftUtil
//
//  Created by lsc on 2018/5/24.
//

import UIKit
import MessageUI

public class FeedbackMailSender: NSObject, MFMailComposeViewControllerDelegate {

    /// 收件人
    var recipient: String
    
    /// 结束回调
    var dismissAction: (() -> Void)?
    
    public init(recipient: String, dismissAction: (() -> Void)?) {
        self.recipient = recipient
        self.dismissAction = dismissAction
        
        super.init()
    }
    
    public func presentMailComposeViewController(from controller: UIViewController) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // 主题
        composeVC.setSubject(self.subject())
        
        // 收件人
        composeVC.setToRecipients([self.recipient])
        
        // 邮件正文
        composeVC.setMessageBody(self.mailBodyComponents().joined(separator: "\n"), isHTML: false)
        
        if MFMailComposeViewController.canSendMail() {
            controller.present(composeVC, animated: true, completion: nil)
        }
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: self.dismissAction)
    }
    
}

private extension FeedbackMailSender {
    
    /// 邮件主题
    func subject() -> String {
        if let subject = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            return subject
        }
        
        if let subject = Bundle.main.infoDictionary?["CFBundleName"] as? String {
            return subject
        }
        
        return ""
    }
    
    
    /// 邮件正文
    func mailBodyComponents() -> [String] {
        let device = UIDevice.current
        let systemInfo = "System: \(device.systemName) (\(device.systemVersion))"
        
        // 设备型号
        let model = "Device: \(Util.rawDeviceModel())"
        
        // 应用信息
        let appName = Util.appName()
        let version = Util.appVersion()
        let appInfo = "\(appName) version: \(version)"
        
        // 语言和地区
        let languageAndCountry = "Local: \(Util.languageCode()) (\(Util.countryCode()))"
        
        // 间隔
        let breaks = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
        
        return [breaks, systemInfo, model, appInfo, languageAndCountry].filter{ $0 != "" }
    }
    
}
