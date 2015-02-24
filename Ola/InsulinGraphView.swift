//
//  InsulinGraphView.swift
//  Ola
//
//  Created by Lucille Benoit on 2/4/15.
//  Copyright (c) 2015 cs147. All rights reserved.
//

import UIKit

@IBDesignable
class InsulinGraphView: UIView {
    var scale: CGFloat = 1.0 { didSet {setNeedsDisplay()}}
    var axesDrawer = AxesDrawer()
    var lineWidth: CGFloat = 2
    var color: UIColor = UIColor.blackColor()
    var origin: CGPoint? = nil {didSet {setNeedsDisplay()}}
    
    private var centerPoint: CGPoint {
        return convertPoint(center, fromView: superview)
    }
    override func drawRect(rect: CGRect) {
        if origin == nil {
            origin = centerPoint
        }
        let dx = Double(self.bounds.size.width)
        let dy = Double(self.bounds.size.height) - 25.0
        axesDrawer.drawTwoAxes(dx, dy: dy, bounds: rect, pointsPerUnit: scale)
        axesDrawer.drawInsulinGraph(dx, dy: dy)
        //axesDrawer.drawAxesInRect(rect, origin: origin!, pointsPerUnit: scale)
    }
}
