import SwiftUI

@MainActor
class IRCViewModel: ObservableObject {
    private let joinedChannelsKey = "JoinedChannels"
    @Published var channels: [Channel] = []
    @Published var selectedChannelIDs: Set<String> = []
    var joinedChannels: [Channel] {
        channels.filter { channel in
            selectedChannelIDs.contains(channel.id)
        }
    }
    @Published var hasFetchedList = false
    @Published var isLoadingChannels = false
    init() {
        engine.viewModel = self
        
        if let saved = UserDefaults.standard.array(forKey: joinedChannelsKey) as? [String] {
            selectedChannelIDs = Set(saved)
        }
    }
    private func saveJoinedChannels() {
        UserDefaults.standard.set(Array(selectedChannelIDs), forKey: joinedChannelsKey)
    }
    func fetchChannelList() {
        guard !hasFetchedList else { return }
        print("Sent LIST command to server")
        channels.removeAll()
        engine.beginChannelList()
        isLoadingChannels = true
        if let listData = "LIST\r\n".data(using: .utf8) {
            sendPacket(pipe: netpipe, packet: listData)
            hasFetchedList = true
        }
    }
    
    func toggleJoin(for channel: Channel) {
        if selectedChannelIDs.contains(channel.id) {
            selectedChannelIDs.remove(channel.id)
            if let partData = "PART \(channel.id)\r\n".data(using: .utf8) {
                sendPacket(pipe: netpipe, packet: partData)
            }
        } else {
            selectedChannelIDs.insert(channel.id)
            joinChannel(channel: channel.id)
        }
    }
}
