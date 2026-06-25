import Foundation
import Network

class ChatEngine {
    var logs: [String] = []
    
    func receiveFromServer(line: String) {
        let cleanLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
        let pongResponse = heartbeat(incoming: cleanLine)
        if pongResponse.isEmpty {
            logs = buildchat(chat: logs, msg: parsemsg(message: cleanLine))
        } else {
            print(pongResponse) 
        }
    }
}

func prepmsg(channel: String, textmessage: String) -> String {
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
        // Safe now because cleanLine stripped the original line breaks!
        return "\(outgoing)\r\n"
    } else {
        return ""
    }
}

func buildchat(chat: [String], msg: String) -> [String] {
    var chatlog = chat
    if !msg.isEmpty {
        chatlog.append(msg)
        if chatlog.count > 50 {
            chatlog.removeFirst()
        }
    }
    return chatlog
}

func parsemsg(message: String) -> String {
    guard !message.isEmpty else { return "" }
    
    let parts = message.components(separatedBy: ":")
    if parts.count >= 2 {
        let sender = parts[0]
        let txt = parts[1]
        return "\(sender) : \(txt)"
    } else {
        return message
    }
}
