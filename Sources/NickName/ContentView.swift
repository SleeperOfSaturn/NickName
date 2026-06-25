import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ChatView(channelName: "##general")) {
                    HStack(spacing: 12) {
                        Image(systemName: "number")
                            .foregroundStyle(.green.gradient)
                            .frame(width: 24)
                        
                        Text("##general")
                            .font(.headline)
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("SleeperOfSaturn"
            .onAppear {
                connectToIRC()
            }
        }
    }
}
