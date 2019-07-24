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
        let v0: CGFloat = 200
        let a: CGFloat = 10
        let vector = CGVector(dx: 1, dy: 1)
        let sMax = (v0 * v0) / (2 * a)
        let tMax = v0 / a
        let path = BilliardsPath.path(distance: sMax, vector: vector, beginPoint: colorView.layer.position, bounds: view.bounds)
        let timeFunc = BilliardsTimeFunc.timeFuncFromMotion(v0: v0, a: a)
        
        let animate = CAKeyframeAnimation(keyPath: "postion")
        animate.path = path.cgPath
        animate.timingFunctions = [timeFunc]
        animate.duration = CFTimeInterval(tMax)
        animate.isRemovedOnCompletion = true
        colorView.layer.add(animate, forKey: nil)
    }
}

