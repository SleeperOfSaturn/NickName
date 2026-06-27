import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @EnvironmentObject var viewModel: IRCViewModel
    
    var filteredChannels: [Channel] {
        if searchText.isEmpty {
            viewModel.channels
        } else {
            viewModel.channels.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        List(filteredChannels) { channel in
            let isJoined = viewModel.selectedChannelIDs.contains(channel.id)
            
            HStack(spacing: 12) {
                Image(systemName: "number")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(channel.name)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.semibold)
                    
                    if let topic = channel.topic {
                        Text(topic)
                            .font(.system(.caption, design: .monospaced))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Button {
                    withAnimation(.snappy(duration: 0.3)) {
                        viewModel.toggleJoin(for: channel)
                    }
                } label: {
                    Image(systemName: isJoined ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 22))
                        .contentTransition(.symbolEffect(.replace))
                        .foregroundStyle(
                            isJoined
                            ? Color.accentColor
                            : Color.secondary.opacity(0.5)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
        }
        .listStyle(.plain)
        .overlay {
            if viewModel.isLoadingChannels {
                ProgressView("Loading channels…")
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search channels..."
        )
        .onAppear {
            viewModel.fetchChannelList()
        }
    }
}
