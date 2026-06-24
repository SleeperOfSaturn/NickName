import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ChatView()) {
                    HStack(spacing: 12) {
                        Image(systemName: "number")
                            .foregroundStyle(.blue.gradient)
                            .frame(width: 24)
                        
                        Text("ChannelNameHere")
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("NickName")
        }
    }
}