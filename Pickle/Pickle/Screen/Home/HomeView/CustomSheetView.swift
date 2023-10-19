//
//  TestGesture.swift
//  Pickle
//
//  Created by 박형환 on 10/15/23.
//

import SwiftUI

enum DragInfo {
    case inactive
    case active(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .active(let t):
            return t
        }
    }
    
    var isActive: Bool {
        switch self {
        case .inactive: return false
        case .active: return true
        }
    }
}

struct CustomSheetView<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    // Gesture properties
    @State private var offset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    
    @GestureState private var gestureOffset: CGFloat = 0
    @GestureState private var dragInfo = DragInfo.inactive
    @State private var yVelocity: Double = 0.0
    @State private var previousDragValue: DragGesture.Value?
    @Binding var isPresented: Bool
    
    @ViewBuilder let content: () -> Content
    
    private let defaultHeight: CGFloat = CGFloat.screenHeight / 3
    private let defaultMidHeight: CGFloat = CGFloat.screenHeight / 2 - 80
    private let defaultTopHeight: CGFloat = 0

    init(isPresented: Binding<Bool>, content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.content = content
    }
    
    func calcDragVelocity(previousValue: DragGesture.Value, currentValue: DragGesture.Value) -> (Double, Double) {
        let timeInterval = currentValue.time.timeIntervalSince(previousValue.time)
        
        let diffXInTimeInterval = Double(currentValue.translation.width - previousValue.translation.width)
        let diffYInTimeInterval = Double(currentValue.translation.height - previousValue.translation.height)
        
        let velocityX = diffXInTimeInterval / timeInterval
        let velocityY = diffYInTimeInterval / timeInterval
        return (velocityX, velocityY)
    }
    
    var body: some View {
        ZStack {
            // For getting height for drag gesture
            GeometryReader { proxy -> AnyView in
                // let height = proxy.frame(in: .global).height
                let yOffset_height: CGFloat = defaultMidHeight
                return AnyView(
                    ZStack {
                        Theme.colorMode(colorScheme)
                            .clipShape(CustomCorner(corners: [.topLeft, .topRight], radius: 30))
                        
                        VStack {
                            Capsule()
                                .fill(Theme.colorMode2(colorScheme))
                                .frame(width: 60, height: 4)
                                .padding(.top, 10)
                            
                            content()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .offset(y: yOffset_height)
                    .offset(y: -offset > 0 ? -offset <= (yOffset_height) ? offset : -(yOffset_height) : offset)
                    .gesture(
                        DragGesture().updating($gestureOffset, body: { value, state, _ in
                            // save previous value
                            DispatchQueue.main.async {
                                self.previousDragValue = value
                            }
                            state = value.translation.height
                        })
                        .onChanged { value in
                            self.offset = gestureOffset + lastOffset
                            if let previousValue = self.previousDragValue {
                                // 계산 velocity using currentValue and previousValue
                                let ( _, yOffset) = self.calcDragVelocity(previousValue: previousValue, currentValue: value)
                                self.yVelocity = yOffset
                            }
                        }
                            .onEnded { _ in
                                let maxHeight = yOffset_height
                                withAnimation {
                                    
                                    Log.debug("self.previousDragValue: \(String(describing: self.previousDragValue?.translation))")
                                    Log.debug("yVelocity: \(String(describing: yVelocity)))")
                                    Log.debug("-offset: \(String(describing: -offset)))")
                                    Log.debug("gestureOffset: \(String(describing: gestureOffset)))")
                                    
                                    // 탑
                                    if -offset > maxHeight / 2 {
                                        offset = -maxHeight
                                    } else {
                                        // 바텀
                                        if offset > 120 {
                                            withAnimation {
                                                isPresented.toggle()
                                            }
                                        }
                                        offset = 0
                                    }
                                }
                                // Storing last offset, so that the gesture can continue from the last position
                                lastOffset = offset
                            })
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    // Blur radius for background
    func getBlurRadius() -> CGFloat {
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        return progress * 30
    }
}

struct CustomCorner: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, 
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
