import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      ForEach(1...30, id: \.self) { index in
        Text("Row \(index)")
          .padding()
          .listRowInsets(EdgeInsets())
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.yellow)
          .listRowBackground(Color.clear)
          .reveal(
            leading: {
              AnyView (DeleteView())
            },
            leadingAvailable: true,
            leadingBackgroundColor: .pink,
            trailing:  {
              AnyView(TimeRangeView())
            },
            trailingAvailable: true
          )
      }
    }
  }
}

struct DeleteView: View {
  var body: some View {
    Image(systemName: "trash")
      .padding()
      .font(.system(size: 12, weight: .bold))
      .foregroundColor(.white)
  }
}

struct TimeRangeView: View {
  var body: some View {
    VStack(spacing: 5) {
      HStack {
        Image(systemName: "stopwatch")
        Text("09:23")
      }
      HStack {
        Image(systemName: "stopwatch.fill")
        Text("13:54")
      }
    }
    .font(.system(size: 12, weight: .bold))
    .padding(10)
    .foregroundColor(.primary)
  }
}
