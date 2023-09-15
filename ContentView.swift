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
      }
    }
  }
}
