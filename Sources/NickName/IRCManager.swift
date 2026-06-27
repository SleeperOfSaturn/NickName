import Foundation
import Network

let host = NWEndpoint.Host("irc.libera.chat")
let port = NWEndpoint.Port(rawValue: 6667)!
let netpipe = NWConnection(host: host, port: port, using: .tcp)

@MainActor let engine = ChatEngine()
@MainActor
class ChatEngine : ObservableObject {
    @Published var logs: [String] = []
    var viewModel: IRCViewModel?
    private var pendingChannels: [Channel] = []
    func beginChannelList() {
        pendingChannels.removeAll()
    }
    func receiveFromServer(line: String) {
        print("RAW >", line)
        
        let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let pongResponse = heartbeat(incoming: cleanLine)
        
        if pongResponse.isEmpty {
            parseChannelList(rawLine: cleanLine)
            
            if cleanLine.contains(" 321 ")
                || cleanLine.contains(" 322 ")
                || cleanLine.contains(" 323 ") {
                return
            }
            
            logs = buildChat(
                chat: logs,
                msg: sanitizeIRCLine(cleanLine)
            )
        } else {
            if let pongData = pongResponse.data(using: .utf8) {
                sendPacket(pipe: netpipe, packet: pongData)
            }
            print(pongResponse)
        }
    }
    
    func parseChannelList(rawLine: String) {
        if rawLine.contains(" 322 ") {
            let components = rawLine.components(separatedBy: " ")
            
            guard components.count > 3 else { return }
            
            let channelName = components[3]
            let topic = rawLine.components(separatedBy: " :")
                .dropFirst()
                .joined(separator: " :")
            
            let newChannel = Channel(
                id: channelName,
                name: channelName,
                topic: topic
            )
            
            pendingChannels.append(newChannel)
        }
        
        if rawLine.contains(" 323 ") {
            print("Received \(pendingChannels.count) channels")
            
            viewModel?.channels = pendingChannels
            viewModel?.isLoadingChannels = false
            pendingChannels.removeAll()
        }
    }
}

func prepMsg(channel: String, textmessage: String) -> String {
    let message: String = textmessage
    if !message.isEmpty {
        return "PRIVMSG \(channel) :\(message)\r\n"
    } else {
        return ""
    }
}

func heartbeat(incoming: String) -> String {
    if incoming.hasPrefix("PING") {
        let outgoing = incoming.replacingOccurrences(of: "PING", with: "PONG")
        return "\(outgoing)\r\n"
    } else {
        return ""
    }
}

func buildChat(chat: [String], msg: String) -> [String] {
    var chatlog = chat
    if !msg.isEmpty {
        chatlog.append(msg)
        if chatlog.count > 50 {
            chatlog.removeFirst()
        }
    }
    return chatlog
}

func encodePacket(channel: String, text: String) -> Data? {
    guard !text.isEmpty else { return nil }
    return prepMsg(channel: channel, textmessage: text).data(using: .utf8)
}

func sendPacket(pipe: NWConnection, packet: Data) {
    pipe.send(content: packet, contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({ error in
        if error != nil { 
            print("Packet transmission failed")
        } else {
            print("Packet transmitted")
        }
    }))
}

func decodeToString(packetData: Data) -> String {
    if let readableString = String(data: packetData, encoding: .utf8) {
        return readableString
    } else {
        return ""
    }
}

func startListening() {
    netpipe.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, context, isComplete, error in
        if let rawBytes = data {
            let readableText = decodeToString(packetData: rawBytes)
            
            let lines = readableText.components(separatedBy: "\r\n")
            for line in lines {
                if !line.isEmpty {
                    Task { @MainActor in
                        engine.receiveFromServer(line: line)
                    }
                }
            }
        }
        if error == nil {
            startListening()
        }
    }
}

func connectToIRC() {
    netpipe.start(queue: DispatchQueue(label: "IRCQueue"))
    startListening()
    let nickCommand = "NICK SleeperOfSaturn\r\n"
    let userCommand = "USER sleeper 0 * :SaturnCaptain\r\n"
    if let nickData = nickCommand.data(using: .utf8),
       let userData = userCommand.data(using: .utf8) {
        sendPacket(pipe: netpipe, packet: nickData)
        sendPacket(pipe: netpipe, packet: userData)
    }
}

func joinChannel(channel: String) {
    guard !channel.isEmpty else { return }
    let joinCommand = "JOIN \(channel)\r\n"
    
    if let joinData = joinCommand.data(using: .utf8) {
        sendPacket(pipe: netpipe, packet: joinData)
        print("Sent join command for \(channel)")
    }
}

func sanitizeIRCLine(_ rawLine: String) -> String {
    if rawLine.contains(" PRIVMSG ") {
        let parts = rawLine.components(separatedBy: " PRIVMSG ")
        if let prefix = parts.first, let trailing = parts.last {
            var username = prefix.replacingOccurrences(of: ":", with: "")
            if let nickEnd = username.firstIndex(of: "!") {
                username = String(username[..<nickEnd])
            }
            
            if let msgColon = trailing.firstIndex(of: ":") {
                let message = String(trailing[trailing.index(after: msgColon)...])
                return "\(username) : \(message)"
            }
        }
    }
    
    if rawLine.contains(" JOIN ") {
        let parts = rawLine.components(separatedBy: " JOIN ")
        if let prefix = parts.first {
            var username = prefix.replacingOccurrences(of: ":", with: "")
            if let nickEnd = username.firstIndex(of: "!") {
                username = String(username[..<nickEnd])
            }
            return "System : \(username) joined the channel"
        }
    }
    if let lastColonIndex = rawLine.lastIndex(of: ":"), lastColonIndex != rawLine.startIndex {
        let message = String(rawLine[rawLine.index(after: lastColonIndex)...])
        return "Server : \(message)"
    }
    return "Server : \(rawLine)"
}
