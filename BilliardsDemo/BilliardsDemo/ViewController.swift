//
//  ViewController.swift
//  BilliardsDemo
//
//  Created by nullLuli on 2019/7/22.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var colorView = UIView()
    var animateButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        colorView.backgroundColor = UIColor.yellow
        colorView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        colorView.layer.cornerRadius = 20
        colorView.layer.masksToBounds = true
        view.addSubview(colorView)
        
        animateButton.setTitle("点击开始动画", for: .normal)
        animateButton.frame = CGRect(x: 0, y: 600, width: 80, height: 50)
        animateButton.setTitleColor(UIColor.blue, for: .normal)
        animateButton.addTarget(self, action: #selector(beginAnimate), for: .touchUpInside)
        view.addSubview(animateButton)
    }
    
    @objc func beginAnimate() {
        let a: CGFloat = 200
        let vector = CGVector(dx: 1000, dy: 1000)
        let tMax = vector.speed / a
//        let path = BilliardsPath.path(distance: sMax, vector: vector, beginPoint: colorView.layer.position, bounds: view.bounds)
//        let timeFunc = BilliardsTimeFunc.timeFuncFromMotion(v0: v0, a: a)
        let (durtimes, timeFuncs, path) = BilliardsPath.segmenteAniamtion(velocity: vector, a: a, beginPoint: colorView.layer.position, bounds: view.bounds)
        
        let sumTime = durtimes.reduce(0) { (result, item) -> CGFloat in
            return result + item
        }
        
        let accumTimes = durtimes.reduce([CGFloat]()) { (result, item) -> [CGFloat] in
            var resultV = result
            if result.count > 0 {
                let last = result[result.count - 1]
                resultV.append(last + item)
            } else {
                resultV.append(item)
            }
            return resultV
        }
        
        let keyTimes = accumTimes.map { (item) -> NSNumber in
            return NSNumber(floatLiteral: Double(item/sumTime))
        }
        
        let animate = CAKeyframeAnimation(keyPath: "position")
        animate.path = path.cgPath
        animate.keyTimes = keyTimes
        animate.timingFunctions = timeFuncs
        animate.duration = CFTimeInterval(tMax)
        animate.isRemovedOnCompletion = true
        colorView.layer.add(animate, forKey: "position")
    }
    
    
}

