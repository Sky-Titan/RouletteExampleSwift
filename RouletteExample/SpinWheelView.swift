//
//  SpinWheelView.swift
//  RouletteExample
//
//  Created by 박준현 on 2022/06/25.
//

import UIKit

protocol SpinWheelViewDelegate: AnyObject {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView)
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView)
}

// MARK: SpinWheelView
class SpinWheelView: UIView {
    override class var layerClass: AnyClass {
        return SpinWheelLayer.self
    }
    weak var delegate: SpinWheelViewDelegate?
    var spinWheelLayer: SpinWheelLayer? {
        return layer as? SpinWheelLayer
    }
    var ringImage: UIImage? {
        get {
            spinWheelLayer?.ringImage
        }
        
        set {
            spinWheelLayer?.ringImage = newValue
            spinWheelLayer?.setNeedsDisplay()
        }
    }
    var items: [SpinWheelItemModel] {
        get {
            spinWheelLayer?.items ?? []
        }
        set {
            spinWheelLayer?.items = newValue
            spinWheelLayer?.setNeedsDisplay()
        }
    }
    
    func spinWheel(_ index: Int) {
        guard !items.isEmpty else { return }
        delegate?.spinWheelWillStart(self)
        spinWheelLayer?.add(spinAnimation(endIndex: index), forKey: "spin")
    }
    
    private func spinAnimation(endIndex: Int) -> CAAnimationGroup {
        let group = CAAnimationGroup()
        let begin = beginAnimation()
        let turn = turnAnimation(begin: begin.duration)
        
        let degressOfSlice: Degree = 360 / CGFloat(items.count)
        let beginAngle: Degree = 0
        let endAngle: Degree = (beginAngle + degressOfSlice * CGFloat(items.count - endIndex))
        
        let end = endAnimation(begin: begin.duration + turn.duration, endAngle: endAngle)
        group.animations = [begin, turn, end]
        group.beginTime = CACurrentMediaTime()
        group.duration = (begin.duration) + (turn.duration) + (end.duration)
        group.delegate = self
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        return group
    }
    
    private func beginAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Degree(360).toRadian()
        animation.duration = 1.5
        animation.beginTime = 0
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        return animation
    }
    
    private func turnAnimation(begin: Double) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = Degree(720).toRadian()
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.beginTime = begin
        return animation
    }
    
    private func endAnimation(begin: Double, endAngle: Degree) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = 0
        animation.toValue = endAngle.toRadian()
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.isRemovedOnCompletion = false
        animation.beginTime = begin
        animation.fillMode = .forwards
        
        return animation
    }
    
}
extension SpinWheelView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            delegate?.spinWheelDidEnd(self)
        }
    }
}

// MARK: SpinWheel Layer
class SpinWheelLayer: CALayer {
    fileprivate(set) var items: [SpinWheelItemModel] = []
    fileprivate(set) var ringImage: UIImage?
    
    override func draw(in ctx: CGContext) {
        self.contentsScale = UIScreen.main.scale
        guard !items.isEmpty else { return }
        
        removeAllAnimations()
        self.sublayers?.forEach({
            $0.removeFromSuperlayer()
        })
        
        let degreeOfSlice: Degree = 360 / CGFloat(items.count)
        
        let beginAngle: Degree = (-90) - (degreeOfSlice / 2)
        var startAngle: Degree = beginAngle
        var endAngle: Degree = startAngle + degreeOfSlice
        
        // Add Slices
        for index in 0 ..< items.count {
            let slice = SliceLayer(model: items[index], index: index, frame: self.bounds, radius: min(bounds.width / 2, bounds.height / 2), startAngle: startAngle, endAngle: endAngle, totalCount: items.count)
            startAngle += degreeOfSlice
            endAngle += degreeOfSlice
            slice.setNeedsDisplay()
            self.addSublayer(slice)
        }
        
        // Add Ring Image
        if let ringImage = ringImage {
            let ringImageLayer = CALayer()
            ringImageLayer.frame = self.bounds
            ringImageLayer.contentsScale = self.contentsScale
            ringImageLayer.contents = ringImage
            ringImageLayer.setNeedsDisplay()
            self.addSublayer(ringImageLayer)
        }
    }
}

// MARK: Slice
class SliceLayer: CALayer {
    let model: SpinWheelItemModel
    let startAngle: Degree
    let endAngle: Degree
    let radius: CGFloat
    let index: Int
    let totalCount: Int
    
    init(model: SpinWheelItemModel, index: Int, frame: CGRect, radius: CGFloat, startAngle: Degree, endAngle: Degree, totalCount: Int) {
        self.model = model
        self.index = index
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.radius = radius
        self.totalCount = totalCount
        super.init()
        self.frame = frame
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(in ctx: CGContext) {
        self.contentsScale = UIScreen.main.scale
        
        // Draw Slice
        let center: CGPoint = CGPoint(x: frame.width / 2, y: frame.height / 2)
        ctx.move(to: center)
        ctx.addArc(center: center, radius: radius, startAngle: startAngle.toRadian(), endAngle: endAngle.toRadian(), clockwise: false)
        ctx.setFillColor(model.backgroundColor?.cgColor ?? UIColor.white.cgColor)
        ctx.fillPath()
        
        // Add text
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: center.x, y: 0, width: frame.width / 2, height: 15)
        textLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        textLayer.position = CGPoint(x: center.x, y: center.y)
        
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.string = model.text
        textLayer.fontSize = 15
        textLayer.alignmentMode = .center
        addSublayer(textLayer)
        
        let degreeOfSlice: Degree = 360 / CGFloat(totalCount)
        textLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: (endAngle - degreeOfSlice / 2).toRadian()))
        
    }
}

struct SpinWheelItemModel {
    let text: String
    let backgroundColor: UIColor?
    let value: Int
}


// MARK: Degree
typealias Radian = CGFloat
typealias Degree = CGFloat
extension Degree {
    func toRadian() -> Radian {
        return self * .pi / 180
    }
}
extension Radian {
    func toDegree() -> Degree {
        return self * 180 / .pi
    }
}
