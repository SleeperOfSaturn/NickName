import Foundation
import Network

let host = NWEndpoint.Host("irc.libera.chat")
let port = NWEndpoint.Port(rawValue: 6667)!
let netpipe = NWConnection(host: host, port: port, using: .tcp)
let engine = ChatEngine()

class ChatEngine : ObservableObject {
    @Published var logs: [String] = []
    
    func receiveFromServer(line: String) {
        let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let pongResponse = heartbeat(incoming: cleanLine)
        if pongResponse.isEmpty {
            logs = buildChat(chat: logs, msg: parseMsg(message: cleanLine))
        } else {
            print(pongResponse) 
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

func parseMsg(message: String) -> String {
    guard !message.isEmpty else { return "" }
    
    let parts = message.components(separatedBy: ":")
    if parts.count >= 2 {
        let sender = parts[0]
        let txt = parts.dropFirst().joined(separator: ":")
        
        return "\(sender) : \(txt)"
    } else {
        return message
    }
}

func encodePacket(channel: String, text: String) -> Data? {
    guard !text.isEmpty else { return nil }
    return prepMsg(channel: channel, textmessage: text).data(using: .utf8)
}

func sendPacket(pipe: NWConnection, packet: Data) {
    pipe.send(content: packet, contentContext: .defaultMessage, isComplete: true, completion: .contentProcessed({ error in
        if let error = error {
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
            engine.receiveFromServer(line: readableText)
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
