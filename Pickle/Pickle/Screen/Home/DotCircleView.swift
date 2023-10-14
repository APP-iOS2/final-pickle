//
//  EmptyCircleView.swift
//  Pickle
//
//  Created by 박형환 on 10/13/23.
//

import SwiftUI

struct DotCircleView: View {
    
    private let pi = Double.pi
    private let dotCount = 30
    private let dotLength: CGFloat = 10
    @Binding var content: String
    
    var taskPercentage: Double
    var body: some View {
        GeometryReader { frame in
            ZStack {
                Text("\(content)")
                    .font(.chab)
                    .foregroundStyle(Color.defaultGray)
                    
                Circle()
                    .trim(from: taskPercentage, to: 1)
                    .stroke(Color.defaultGray,
                            style: StrokeStyle(lineWidth: 2,
                                               lineCap: .butt,
                                               lineJoin: .miter,
                                               miterLimit: 0,
                                               dash: [dotLength, getSpaceLength(radius: frame.size.width / 2)], 
                                               dashPhase: 0))
                    .rotationEffect(.degrees(-90))
                    .frame(width: frame.size.width)
                
            }.frame(width: frame.size.width)
        }
    }
    
    private func getCircleRadius(frame width: CGFloat) -> CGFloat {
        CGFloat(2.0 * pi) * width
    }
    
    private func getSpaceLength(radius: CGFloat) -> CGFloat {
        return getCircleRadius(frame: radius) / CGFloat(dotCount) - dotLength
    }
}
