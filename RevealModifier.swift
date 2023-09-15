//
//  RevealModifier.swift
//  RevealModifier
//
//  Created by Christian Hoock on 15.09.23.
//

import SwiftUI

struct RevealModifier: ViewModifier {
  var leadingView: AnyView
  var trailingView: AnyView
  
  @State private var offset: CGFloat = 0.0
  @State private var offsetAnimated: CGFloat = 0.0
  @State private var offsetLeftovers: CGFloat = 0.0
  @State private var offsetShouldAnimate: Bool = false
  @State private var leftRevealViewWidth: CGFloat = 60.0
  @State private var rightRevealViewWidth: CGFloat = 60.0
  @State private var resetOffsetWorkItem: DispatchWorkItem?
  
  init(leading: AnyView, trailing: AnyView) {
    self.leadingView = leading
    self.trailingView = trailing
    print("Modifier initiated")
  }
  
  var calcOffset: CGFloat {
    offsetShouldAnimate ? offsetAnimated : offset
  }
  
  private func scheduleResetOffset() {
    resetOffsetWorkItem = DispatchWorkItem {
      offsetAnimated = 0
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: resetOffsetWorkItem!)
  }
  
  func body(content: Content) -> some View {
    
    let swipeContentWidth = calcOffset >= 0 ? leftRevealViewWidth : rightRevealViewWidth
    
    ZStack {
      // Trailing View
      HStack {
        Spacer()
        trailingView
          .frame(maxHeight: .infinity)
          .foregroundColor(.white)
          .background(Color.red)
          .readSize(onChange: { size in
            self.rightRevealViewWidth = size.width
          })
          .opacity(calcOffset / -rightRevealViewWidth)
          .scaleEffect(max(min(1.0, calcOffset / -rightRevealViewWidth), 0.00001))
      }
      .offset(x: max(calcOffset + rightRevealViewWidth, 0))
      .animation(offsetShouldAnimate ? .default : nil, value: offsetAnimated)
      
      // Leading View
      HStack {
        leadingView
          .frame(maxHeight: .infinity)
          .foregroundColor(.white)
          .readSize(onChange: { size in
            self.leftRevealViewWidth = size.width
          })
          .opacity(calcOffset/leftRevealViewWidth)
          .scaleEffect(max(min(1.0, calcOffset/leftRevealViewWidth), 0.00001))
        Spacer()
      }
      .offset(x: min(calcOffset - leftRevealViewWidth, 0))
      .animation(offsetShouldAnimate ? .default : nil, value: offsetAnimated)
      
      // Main Content
      content
        .offset(x: calcOffset)
        .animation(offsetShouldAnimate ? .default : nil, value: offsetAnimated)
        .gesture(
          DragGesture(minimumDistance: 15, coordinateSpace: .local)
            .onChanged { value in
              print(value)
              // Cancel any pending work items
              resetOffsetWorkItem?.cancel()
              
              if offsetShouldAnimate {
                offsetLeftovers = offsetAnimated
                withAnimation(nil) {
                  offsetAnimated = offsetLeftovers + value.translation.width
                }
                offsetShouldAnimate = false
              }
              
              if value.translation.direction == .horizontal {
                offset = offsetLeftovers + value.translation.width
              }
            }
            .onEnded { value in
              // Cancel any pending work items
              resetOffsetWorkItem?.cancel()
              
              offsetShouldAnimate = true
              if value.translation.direction == .vertical {
                offsetAnimated = 0
              } else {
                if (value.translation.width >= swipeContentWidth) {
                  offsetAnimated = swipeContentWidth
                  scheduleResetOffset()
                } else if (value.translation.width <= -swipeContentWidth) {
                  offsetAnimated = -swipeContentWidth
                  scheduleResetOffset()
                } else {
                  offsetAnimated = 0
                }
              }
            }
        )
    }
    .background {
      if (offset >= 0) {
        Color.blue
      } else if (offset <= 0) {
        Color.red
      }
    }
    .clipped(antialiased: true)
    .cornerRadius(3.0, antialiased: true)
  }
}

extension View {
  func reveal(
    @ViewBuilder leading: () -> AnyView = { AnyView(EmptyView()) },
    @ViewBuilder trailing: () -> AnyView = { AnyView(EmptyView()) }
  ) -> some View {
    self.modifier(RevealModifier(leading: leading(), trailing: trailing()))
  }
}