//
//  CircleView.swift
//  Pickle
//
//  Created by 최소정 on 2023/09/26.
//

//  나중에 피자로 변경..

import SwiftUI

struct CircleView: View {
    let slices: Int

    var body: some View {
        ZStack {
            ForEach(0..<slices, id: \.self) { sliceIndex in
                let startAngle = Angle(degrees: Double(sliceIndex) * 45)
                let endAngle = Angle(degrees: Double(sliceIndex + 1) * 45)
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 100))
                    path.addArc(center: CGPoint(x: 100, y: 100), radius: 100, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    path.closeSubpath()
                }
                .fill(Color.blue)
            }
        }
        .rotationEffect(.degrees(-90))
        .animation(.easeInOut)
    }
}

struct CircleView_Previews: PreviewProvider {
    static var previews: some View {
        CircleView(slices: 1)
    }
}
