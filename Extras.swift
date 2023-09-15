//
//  Extras.swift
//  RevealModifier
//
//  Created by Christian Hoock on 15.09.23.
//

import SwiftUI

extension View {
  func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
    background(
      GeometryReader { geometryProxy in
        Color.clear
          .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
      }
    )
    .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
  }
}

struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension CGSize {
  public enum Direction {
    case vertical
    case horizontal
  }
  
  var direction: Direction {
    let angle = atan2(self.height, self.width)
    if (abs(angle) > .pi / 4 && abs(angle) < 3 * .pi / 4) {
      return .vertical
    } else {
      return .horizontal
    }
  }
}
