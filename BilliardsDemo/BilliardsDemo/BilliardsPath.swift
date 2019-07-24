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
    //vertor方向，总共可以滚动distance距离，遇到bounds会转向
    public class func path(distance: CGFloat, vector: CGVector, beginPoint: CGPoint, bounds: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        BilliardsPath._path(distance: distance, vector: vector, beginPoint: beginPoint, bounds: bounds, path: path)
        return path
    }
    
    public class func _path(distance: CGFloat, vector: CGVector, beginPoint: CGPoint, bounds: CGRect, path: UIBezierPath) {
        let rectLineType = whichRectLineVectorInsection(beginP: beginPoint, vertor: vector, rect: bounds)
        
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
            let endPoint = CGPoint(x: intersectionPoint.x * (consumDistance / distance), y: intersectionPoint.y * (consumDistance / distance))
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
    
    public class func whichRectLineVectorInsection(beginP: CGPoint, vertor: CGVector, rect: CGRect) -> LineType {
        if vertor.dx > 0, vertor.dy > 0 {
            //right | bottom
            let side = whichSide(vertor: vertor, beginP: beginP, endP: CGPoint(x: rect.maxX, y: rect.maxY))
            switch side {
            case .y:
                return LineType.bottom
            case .x:
                return LineType.right
            }
        } else if vertor.dx > 0, vertor.dy < 0 {
            //top | right
            let side = whichSide(vertor: vertor, beginP: beginP, endP: CGPoint(x: rect.maxX, y: rect.minY))
            switch side {
            case .y:
                return LineType.top
            case .x:
                return LineType.right
            }
        } else if vertor.dx < 0, vertor.dy > 0 {
            //left | bottom
            let side = whichSide(vertor: vertor, beginP: beginP, endP: CGPoint(x: rect.minX, y: rect.maxY))
            switch side {
            case .y:
                return LineType.bottom
            case .x:
                return LineType.left
            }
        } else if vertor.dx < 0, vertor.dy < 0 {
            //left | top
            let side = whichSide(vertor: vertor, beginP: beginP, endP: CGPoint(x: rect.minX, y: rect.minY))
            switch side {
            case .y:
                return LineType.top
            case .x:
                return LineType.left
            }
        } else if vertor.dx == 0, vertor.dy != 0 {
            //top | bottom
            if vertor.dy > 0 {
                return LineType.bottom
            } else {
                return LineType.top
            }
        } else if vertor.dy == 0, vertor.dx != 0 {
            //left | right
            if vertor.dx > 0 {
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
    
    public class func whichSide(vertor: CGVector, beginP: CGPoint, endP: CGPoint) -> Side {
        if endP.y - beginP.y == 0 || endP.x - beginP.x == 0 {
            assertionFailure()
            return Side.x
        }
        if vertor.dx == 0 {
            return Side.y
        }
        let unitY = (endP.y - beginP.y) * (vertor.dx / (endP.x - beginP.x))
        if abs(vertor.dy) > abs(unitY) {
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
        let vertorEndP = CGPoint(x: dx + beginP.x, y: dy + beginP.y)
        let c = -line.b * vertorEndP.x + line.a * vertorEndP.y
        let verticalLine = Line(a: line.b, b: -line.a, c: c)
        //向量垂直于line的点
        guard let intersectionP = line.intersection(line: verticalLine) else {
            assertionFailure()
            return CGVector(dx: 0, dy: 0)
        }
        let reflexP = CGPoint(x: 2 * intersectionP.x - vertorEndP.x, y: 2 * intersectionP.y - vertorEndP.y)
        let reflexVector = CGVector(dx: reflexP.x - beginP.x, dy: reflexP.y - beginP.y)
        return reflexVector
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
