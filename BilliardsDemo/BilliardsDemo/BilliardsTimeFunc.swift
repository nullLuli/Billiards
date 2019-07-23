//
//  BilliardsTimeFunc.swift
//  BilliardsDemo
//
//  Created by nullLuli on 2019/7/22.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import Foundation
import UIKit

class BilliardsTimeFunc {
    //根据初始速度和加速度，拟合出时间和进度的贝塞尔曲线
    class func transMotionToTimeBezier(v0: CGFloat, a: CGFloat) -> CAMediaTimingFunction {
        //距离和时间函数 v0*t - 1/2 * a * t^2 = s
        //起始点 s = 0, t = 0
        //终点
        let tMax = v0 / a //速度降到0所需时间
        let sMax = (v0 * v0) / (2 * a) //距离最大值
        //任意时间点的切线斜率 s' = v = v0 - at
        //起始点的切线方程
        let aBegin: CGFloat = v0
        let bBegin: CGFloat = 0 //beginP.x * v0 + b = beginP.y
        let beginTangentLine = Line(slope: aBegin, intersectionWithY: bBegin)
        //终点的切线方程
        //斜率 vEnd = v0 - a * tMax = 0
        let aEnd: CGFloat = 0
        let bEnd: CGFloat = sMax
        let endTangentLine = Line(slope: aEnd, intersectionWithY: bEnd)
        //切线的交点，根据贝塞尔定义，也就是贝塞尔的控制点
        guard let controlPInST = beginTangentLine.intersection(line: endTangentLine) else {
            return CAMediaTimingFunction(name: .linear)
        }
        let controlPInPT = CGPoint(x: controlPInST.x / tMax, y: controlPInST.y / sMax)
        return CAMediaTimingFunction(controlPoints: 0, 0, Float(controlPInPT.x), Float(controlPInPT.y))
    }
}

struct Line {
    // a*x + b*y + c = 0
    var a: CGFloat = 0
    var b: CGFloat = 0
    var c: CGFloat = 0
    
    init(slope: CGFloat, intersectionWithY: CGFloat) {
        // y = slope * x + intersectionWithY
        a = slope
        b = -1
        c = intersectionWithY
    }
    
    init(a: CGFloat, b: CGFloat, c: CGFloat) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    func intersection(line: Line) -> CGPoint? {
        guard a * line.b != line.a * b else {
            return nil
        }
        let x = (b * line.c - line.b * c) / (a * line.b - line.a * b)
        let y = (a * line.c - line.a * c) / (b * line.a - line.b * a)
        return CGPoint(x: x, y: y)
    }
}
