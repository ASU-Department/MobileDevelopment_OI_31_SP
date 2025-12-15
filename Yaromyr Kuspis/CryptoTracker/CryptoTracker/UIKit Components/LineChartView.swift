//
//  LineChartView.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 19.11.2025.
//

import SwiftUI
import UIKit

struct LineChartView: UIViewRepresentable {
    var data: [Double]

    func makeUIView(context: Context) -> LineChartUIView {
        let uiView = LineChartUIView()
        uiView.data = self.data
        return uiView
    }

    func updateUIView(_ uiView: LineChartUIView, context: Context) {
        uiView.data = self.data
        uiView.setNeedsDisplay() // Redraw the view when data changes
    }
}

class LineChartUIView: UIView {
    var data: [Double] = []

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard !data.isEmpty, let context = UIGraphicsGetCurrentContext() else { return }

        let path = UIBezierPath()
        
        // Calculate scaling factors for the chart
        let height = rect.height
        let width = rect.width
        let maxPoint = data.max() ?? 1.0
        let minPoint = data.min() ?? 0.0
        
        let xStep = width / CGFloat(data.count - 1)
        let yRatio = (height - 20) / CGFloat(maxPoint - minPoint)

        for (index, point) in data.enumerated() {
            let x = CGFloat(index) * xStep
            let y = height - (CGFloat(point - minPoint) * yRatio) - 10
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        context.setStrokeColor(UIColor.systemBlue.cgColor)
        context.setLineWidth(2.0)
        path.stroke()
    }
}
