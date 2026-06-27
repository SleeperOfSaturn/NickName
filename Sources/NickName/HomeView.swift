import SwiftUI
struct HomeView: View {
    @EnvironmentObject var viewModel: IRCViewModel
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.joinedChannels) { channel in
                    NavigationLink(destination: ChatView(channelName: channel.name)) {
                        
                        HStack(spacing: 12) {
                            Image(systemName: "number")
                                .foregroundStyle(.green.gradient)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading) {
                                Text(channel.name)
                                    .font(.headline)
                                
                                if let topic = channel.topic {
                                    Text(topic)
                                        .font(.footnote)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .onAppear {
                connectToIRC()
            }
            .navigationTitle("NickName")
        }
        
    }
}
