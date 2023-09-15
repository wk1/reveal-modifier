import SwiftUI

struct ContentView: View {
  var body: some View {
    List {
      ForEach(1...30, id: \.self) { num in
        Text("Row \(num)")
          .padding()
          .listRowInsets(EdgeInsets())
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(.yellow)
          .listRowBackground(Color.clear)
          .reveal( trailing:  {
            AnyView(
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
                .font(.system(size: 12))
                .padding(10)
                .background(.blue)
            )
          })
      }
    }
  }
}
