//
//  BilliardsPath.swift
//  BilliardsDemo
//
//  Created by nullLuli on 2019/7/23.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import Foundation
import UIKit

class BilliardsPath {
    //vertor方向，总共可以滚动distance距离，遇到bounds会转向
    class func path(distance: CGFloat, vertor: CGVector, beginPoint: CGPoint, bounds: CGRect) -> UIBezierPath {
        let rectLineType = vertorIntersectionRect(beginP: beginPoint, vertor: vertor, rect: bounds)
        
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
        
        let motionLine = Line(a: <#T##CGFloat#>, b: <#T##CGFloat#>, c: <#T##CGFloat#>)
        
        let intersectionPoint = rectLine.intersection(line: <#T##Line#>)
    }
    
    class func vertorIntersectionRect(beginP: CGPoint, vertor: CGVector, rect: CGRect) -> LineType {
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
    
    enum Side {
        case x
        case y
    }
    
    class func whichSide(vertor: CGVector, beginP: CGPoint, endP: CGPoint) -> Side {
        if endP.y - beginP.y == 0 || endP.x - beginP.x == 0 {
            assertionFailure()
            return Side.x
        }
        let limitSlop = (endP.y - beginP.y) / (endP.x - beginP.x)
        let slop = vertor.dy / vertor.dx
        if abs(limitSlop) > abs(slop) {
            //y
            return Side.y
        } else {
            //x
            return Side.x
        }
    }
}

extension CGRect {
    func topLine() -> Line {
        return Line(a: 0, b: 1, c: -minY)
    }
    
    func bottomLine() -> Line {
        return Line(a: 0, b: 1, c: -maxY)
    }
    
    func leftLine() -> Line {
        return Line(a: 1, b: 0, c: -minX)
    }
    
    func rightLine() -> Line {
        return Line(a: 1, b: 0, c: -maxX)
    }
}

enum LineType {
    case top
    case bottom
    case left
    case right
}
