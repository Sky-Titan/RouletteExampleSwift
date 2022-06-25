//
//  SpinWheelView.swift
//  RouletteExample
//
//  Created by 박준현 on 2022/06/25.
//

import UIKit

class SpinWheelView: UIView {
    override class var layerClass: AnyClass {
        return SpinWheelLayer.self
    }
    
    var spinWheelLayer: SpinWheelLayer? {
        return layer as? SpinWheelLayer
    }
    
}


class SpinWheelLayer: CALayer {
    
}
