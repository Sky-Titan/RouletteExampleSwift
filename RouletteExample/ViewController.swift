//
//  ViewController.swift
//  RouletteExample
//
//  Created by 박준현 on 2022/06/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var spinWheelView: SpinWheelView!
    
    let texts = ["blue", "red", "green", "brown", "black", "darkGray", "orange", "purple"]
    let colors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.brown, UIColor.black, UIColor.darkGray, UIColor.orange, UIColor.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        spinWheelView.delegate = self
        spinWheelView.items = randomItems()
    }

    @IBAction func randomize(_ sender: Any) {
        spinWheelView.items = randomItems()
    }
    
    @IBAction func spin(_ sender: Any) {
        spinWheelView.spinWheel(3)
    }
    
    func randomItems() -> [SpinWheelItemModel] {
        let shuffledColor = colors.shuffled()
        return shuffledColor.compactMap({ color in
            SpinWheelItemModel(text: color.toText(), backgroundColor: color, value: 1000)
        })
    }
}
extension ViewController: SpinWheelViewDelegate {
    func spinWheelWillStart(_ spinWheelView: SpinWheelView) {
        print("start")
    }
    
    func spinWheelDidEnd(_ spinWheelView: SpinWheelView) {
        print("stop")
    }
}

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

