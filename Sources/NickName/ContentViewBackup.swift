import SwiftUI

struct ContentViewBackup: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: ChatView(channelName: "##general")) {
                    HStack(spacing: 12) {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.green.gradient)
                            .frame(width: 24)
                            .font(.subheadline)
                        VStack {
                            Text("General")
                                .font(.headline)
                            Text("##general")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .listStyle(.insetGrouped)
            .onAppear {
                connectToIRC()
            }
            .navigationTitle("NickName")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    HStack (spacing: 15) {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "gear")
                        }
                        Button(action: {
                            
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
        
    }
}
