import SwiftUI

struct ChatBufferView: View {
    @State private var messages = [
        (user: "SleeperOfSaturn", text: "Hello, World! Welcome to NickName."),
        (user: "irc_ghost", text: "Hey! Nice to see a terminal-style client running smoothly here."),
        (user: "operator", text: "Please keep the channel on-topic. Links are allowed.")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(0..<messages.count, id: \.self) { index in
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text("\(messages[index].user):")
                                .foregroundStyle(.red)
                                .fontWeight(.bold)
                            
                            Text(messages[index].text)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.system(.subheadline, design: .monospaced, weight: .light))
                    }
                }
                .padding()
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
