//
//  ExpandImageView.swift
//  Alamofire
//
//  Created by dannyluo on 2021/2/2.
//

import UIKit

open class ExpandImageView: UIImageView {

    public var expandWidth: CGFloat = 44.0
    public var expandHeight: CGFloat = 44.0

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let widthDelta = max(expandWidth - bounds.width, 0.0)
        let heightDelta = max(expandHeight - bounds.height, 0.0)

        let expandBounds = self.bounds.insetBy(dx: -0.5*widthDelta, dy: -0.5*heightDelta)

        return expandBounds.contains(point)
    }
    
}
