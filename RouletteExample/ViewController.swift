//
//  ViewController.swift
//  RouletteExample
//
//  Created by 박준현 on 2022/06/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spinWheelView: SpinWheelView!
    @IBOutlet weak var indexPickerView: UIPickerView!
    
    let texts = ["blue", "red", "green", "brown", "black", "darkGray", "orange", "purple"]
    let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.brown, UIColor.black, UIColor.darkGray, UIColor.orange, UIColor.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinWheelView.delegate = self
        spinWheelView.items = randomItems()
        spinWheelView.ringImage = testRingImage()
        spinWheelView.ringLineWidth = 10
        
        indexPickerView.delegate = self
        indexPickerView.dataSource = self
    }

    @IBAction func randomize(_ sender: Any) {
        spinWheelView.items = randomItems()
        indexPickerView.reloadAllComponents()
    }
    
    @IBAction func spin(_ sender: Any) {
        let index = indexPickerView.selectedRow(inComponent: 0)
        print("spin wheel \(spinWheelView.items[index].text)")
        spinWheelView.spinWheel(index)
    }
    
    func randomItems() -> [SpinWheelItemModel] {
        let shuffledColor = colors.shuffled()
        return shuffledColor.compactMap({ color in
            SpinWheelItemModel(text: color.toText(), backgroundColor: color, value: 1000)
        })
    }
    
    func testRingImage() -> UIImage {
        let lineWidth: CGFloat = 10
        let width: CGFloat = 300
        let height: CGFloat = 300
        let center: CGPoint = CGPoint(x: width / 2, y: height / 2)
        
        let radius: CGFloat = min(width / 2, height / 2) - lineWidth / 2
        
        
        let ringLayer = CAShapeLayer()
        ringLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        ringLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: false).cgPath
        ringLayer.lineWidth = lineWidth
        ringLayer.strokeColor = UIColor.cyan.cgColor
        ringLayer.fillColor = UIColor.clear.cgColor
        ringLayer.strokeStart = 0
        ringLayer.strokeEnd = 1
        ringLayer.setNeedsDisplay()
        
        let image = ringLayer.captureScreen()
        return image
    }
}
// MARK: SpinWheelViewDelegate
extension ViewController: SpinWheelViewDelegate {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView) {
        print("will start")
    }
    
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView, at item: SpinWheelItemModel) {
        print("did end at \(item.text)")
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        spinWheelView.items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        spinWheelView.items[row].text
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

// MARK: image capture
extension CALayer {

    func captureScreen() -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 300), false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        self.render(in: ctx)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()
        let image = UIImage(cgImage: ctx.makeImage()!, scale: UIScreen.main.scale, orientation: outputImage.imageOrientation)
        return image
    }
}

// MARK: UIColor Text
extension UIColor {
    func toText() -> String {
        switch self {
        case .blue:
            return "blue"
        case .red:
            return "red"
        case .green:
            return "green"
        case .brown:
            return "brown"
        case .black:
            return "black"
        case .darkGray:
            return "darkGray"
        case .orange:
            return "orange"
        case .purple:
            return "purple"
        default:
            return ""
        }
    }
}

