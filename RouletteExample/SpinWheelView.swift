//
//  SpinWheelView.swift
//  RouletteExample
//
//  Created by 박준현 on 2022/06/25.
//

import UIKit

protocol SpinWheelViewDelegate: AnyObject {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView)
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView, at index: Int)
}

class SpinWheelView: UIView {
    override class var layerClass: AnyClass {
        return SpinWheelLayer.self
    }
    weak var delegate: SpinWheelViewDelegate?
    
    var spinWheelLayer: SpinWheelLayer? {
        return layer as? SpinWheelLayer
    }
    
    func beginTo(_ index: Int) {
        delegate?.spinWheelWillStart(self)
        
    }
    
}


class SpinWheelLayer: CALayer {
    
    override func draw(in ctx: CGContext) {
        
    }
}

class SliceLayer: CALayer {
    
}
