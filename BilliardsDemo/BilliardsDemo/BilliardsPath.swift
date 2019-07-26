//
//  BilliardsPath.swift
//  BilliardsDemo
//
//  Created by nullLuli on 2019/7/23.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import Foundation
import UIKit

public class BilliardsPath {
    public class func segmenteAniamtion(velocity: CGVector, a: CGFloat, beginPoint: CGPoint, bounds: CGRect, path: UIBezierPath = UIBezierPath()) -> ([CGFloat], [CAMediaTimingFunction], UIBezierPath) {
        let rectLineType = whichRectLineVectorInsection(beginP: beginPoint, vector: velocity, rect: bounds)
        
        var rectLine: Line
        switch rectLineType {
        case .top:
            rectLine = bounds.topLine()
        case .bottom:
            rectLine = bounds.bottomLine()
        case .left:
            rectLine = bounds.leftLine()
        case .right:
            rectLine = bounds.rightLine()
        }
        
        let motionLine = Line(a: velocity.dy, b: -velocity.dx, c: velocity.dx * beginPoint.y - velocity.dy * beginPoint.x)
        
        guard let intersectPoint = rectLine.intersection(line: motionLine) else {
            assertionFailure()
            return ([], [], UIBezierPath())
        }
        
        var timeFuncs: [CAMediaTimingFunction] = []
        var durtimes: [CGFloat] = []
        var consumDistances: [CGFloat] = []
        
        let speed = velocity.speed
        let maxDistance = (pow(velocity.dx, 2) + pow(velocity.dy, 2)) / (2 * a)
        let consumDistance = sqrt(pow(intersectPoint.y - beginPoint.y, 2) + pow(intersectPoint.x - beginPoint.x, 2))
        
        if consumDistance >= maxDistance {
            let endPoint = CGPoint(x: beginPoint.x + (intersectPoint.x - beginPoint.x) * (maxDistance / consumDistance), y: beginPoint.y + (intersectPoint.y - beginPoint.y) * (maxDistance / consumDistance))
            if path.isEmpty {
                path.move(to: beginPoint)
            }
            path.addLine(to: endPoint)
            
            let timeFunc = BilliardsTimeFunc.timeFuncFromSegmentMotion(v0: speed, a: a, vEnd: 0)
            timeFuncs.append(timeFunc)
            let durtime: CGFloat = (speed - sqrt(pow(velocity.dx, 2) + pow(velocity.dy, 2) - 2 * a * maxDistance)) / a //利用抛物线的根公式求当前时间
            durtimes.append(durtime)
            assert(!durtime.isNaN)

        } else {
            if path.isEmpty {
                path.move(to: beginPoint)
            }
            path.addLine(to: intersectPoint)
            
            let durtime: CGFloat = (speed - sqrt(pow(velocity.dx, 2) + pow(velocity.dy, 2) - 2 * a * consumDistance)) / a //利用抛物线的根公式求当前时间
            assert(!durtime.isNaN)
            let remainSpeed = speed - a * durtime
            var remainVelocity = CGVector(dx: velocity.dx * remainSpeed / speed, dy: velocity.dy * remainSpeed / speed)
            remainVelocity = remainVelocity.reflexVector(line: rectLine)
            let timeFunc = BilliardsTimeFunc.timeFuncFromSegmentMotion(v0: speed, a: a, vEnd: remainSpeed)
            timeFuncs.append(timeFunc)
            durtimes.append(durtime)
            let (laterDurtimes, laterTimeFuncs, _) = BilliardsPath.segmenteAniamtion(velocity: remainVelocity, a: a, beginPoint: intersectPoint, bounds: bounds, path: path)
            timeFuncs.append(contentsOf: laterTimeFuncs)
            durtimes.append(contentsOf: laterDurtimes)
        }
        
        return (durtimes, timeFuncs, path)
    }
    
    //vector方向，总共可以滚动distance距离，遇到bounds会转向
    public class func path(distance: CGFloat, vector: CGVector, beginPoint: CGPoint, bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        BilliardsPath._path(distance: distance, vector: vector, beginPoint: beginPoint, bounds: bounds, path: path)
        return path
    }
    
    public class func _path(distance: CGFloat, vector: CGVector, beginPoint: CGPoint, bounds: CGRect, path: UIBezierPath) {
        let rectLineType = whichRectLineVectorInsection(beginP: beginPoint, vector: vector, rect: bounds)
        
        var rectLine: Line
        switch rectLineType {
        case .top:
            rectLine = bounds.topLine()
        case .bottom:
            rectLine = bounds.bottomLine()
        case .left:
            rectLine = bounds.leftLine()
        case .right:
            rectLine = bounds.rightLine()
        }
        
        let motionLine = Line(a: vector.dy, b: -vector.dx, c: vector.dx * beginPoint.y - vector.dy * beginPoint.x)
        
        guard let intersectionPoint = rectLine.intersection(line: motionLine) else {
            assertionFailure()
            return
        }
        
        // 计算beginPoint到intersectionPoint的距离
        let consumDistance = sqrt(pow(intersectionPoint.y - beginPoint.y, 2) + pow(intersectionPoint.x - beginPoint.x, 2))
        if consumDistance >= distance {
            let endPoint = CGPoint(x: intersectionPoint.x * (distance / consumDistance), y: intersectionPoint.y * (distance / consumDistance))
            if path.isEmpty {
                path.move(to: beginPoint)
            }
            path.addLine(to: endPoint)
        } else {
            if path.isEmpty {
                path.move(to: beginPoint)
            }
            path.addLine(to: intersectionPoint)
            
            let remainDistance = distance - consumDistance
            BilliardsPath._path(distance: remainDistance, vector: vector.reflexVector(line: rectLine), beginPoint: intersectionPoint, bounds: bounds, path: path)
        }
    }
    
    public class func whichRectLineVectorInsection(beginP: CGPoint, vector: CGVector, rect: CGRect) -> LineType {
        if vector.dx > 0, vector.dy > 0 {
            //right | bottom
            let side = whichSide(vector: vector, beginP: beginP, endP: CGPoint(x: rect.maxX, y: rect.maxY))
            switch side {
            case .y:
                return LineType.bottom
            case .x:
                return LineType.right
            }
        } else if vector.dx > 0, vector.dy < 0 {
            //top | right
            let side = whichSide(vector: vector, beginP: beginP, endP: CGPoint(x: rect.maxX, y: rect.minY))
            switch side {
            case .y:
                return LineType.top
            case .x:
                return LineType.right
            }
        } else if vector.dx < 0, vector.dy > 0 {
            //left | bottom
            let side = whichSide(vector: vector, beginP: beginP, endP: CGPoint(x: rect.minX, y: rect.maxY))
            switch side {
            case .y:
                return LineType.bottom
            case .x:
                return LineType.left
            }
        } else if vector.dx < 0, vector.dy < 0 {
            //left | top
            let side = whichSide(vector: vector, beginP: beginP, endP: CGPoint(x: rect.minX, y: rect.minY))
            switch side {
            case .y:
                return LineType.top
            case .x:
                return LineType.left
            }
        } else if vector.dx == 0, vector.dy != 0 {
            //top | bottom
            if vector.dy > 0 {
                return LineType.bottom
            } else {
                return LineType.top
            }
        } else if vector.dy == 0, vector.dx != 0 {
            //left | right
            if vector.dx > 0 {
                return LineType.right
            } else {
                return LineType.left
            }
        } else {
            assertionFailure()
            return LineType.top
        }
    }
    
    public enum Side {
        case x
        case y
    }
    
    public class func whichSide(vector: CGVector, beginP: CGPoint, endP: CGPoint) -> Side {
        if endP.y - beginP.y == 0 || endP.x - beginP.x == 0 {
            assertionFailure()
            return Side.x
        }
        if vector.dx == 0 {
            return Side.y
        }
        let unitY = (endP.y - beginP.y) * (vector.dx / (endP.x - beginP.x))
        if abs(vector.dy) > abs(unitY) {
            //y
            return Side.y
        } else {
            //x
            return Side.x
        }
    }
}

public extension CGVector {
    public func reflexVector(line: Line) -> CGVector {
        if line.a == 0 {
            assert(line.b != 0)
            return CGVector(dx: dx, dy: -dy)
        }
        let beginP = CGPoint(x: -line.c / line.a, y: 0) //以line和x轴的交点当作向量的起点，求对称点
        let vectorEndP = CGPoint(x: dx + beginP.x, y: dy + beginP.y)
        let c = -line.b * vectorEndP.x + line.a * vectorEndP.y
        let verticalLine = Line(a: line.b, b: -line.a, c: c)
        //向量垂直于line的点
        guard let intersectionP = line.intersection(line: verticalLine) else {
            assertionFailure()
            return CGVector(dx: 0, dy: 0)
        }
        let reflexP = CGPoint(x: 2 * intersectionP.x - vectorEndP.x, y: 2 * intersectionP.y - vectorEndP.y)
        let reflexVector = CGVector(dx: reflexP.x - beginP.x, dy: reflexP.y - beginP.y)
        return reflexVector
    }
    
    public var speed: CGFloat {
        return sqrt(pow(dx, 2) + pow(dy, 2))
    }
}

public extension CGRect {
    public func topLine() -> Line {
        return Line(a: 0, b: 1, c: -minY)
    }
    
    public func bottomLine() -> Line {
        return Line(a: 0, b: 1, c: -maxY)
    }
    
    public func leftLine() -> Line {
        return Line(a: 1, b: 0, c: -minX)
    }
    
    public func rightLine() -> Line {
        return Line(a: 1, b: 0, c: -maxX)
    }
}

public enum LineType {
    case top
    case bottom
    case left
    case right
}
