import SwiftUI

struct ChatView: View {
    let channelName: String
    @State private var textmessage = ""
    @FocusState private var isInputFieldFocused: Bool
    
    var body: some View {
        ChatBufferView()
            .safeAreaBar(edge: .bottom) {
                HStack {
                    TextField("Message", text: $textmessage)
                        .monospaced()
                        .padding(.leading)
                        .focused($isInputFieldFocused)
                    
                    Button(action: {
                        if let textpacket = encodePacket(channel: channelName, text: textmessage) {
                            sendPacket(pipe: netpipe, packet: textpacket)
                            engine.logs.append("SleeperOfSaturn : \(textmessage)")
                            textmessage = ""
                        }
                    }) {
                        Image(systemName: "arrow.up")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                    }
                    .background(Capsule().fill(.green.gradient))
                    .padding(.trailing, 10)
                }
                .padding(.vertical, 8) 
                .frame(maxWidth: .infinity)
                .clipped()
                .glassEffect(.regular.interactive(), in: .capsule(style: .continuous))
                .padding([.horizontal, .top])
                .padding(.bottom, isInputFieldFocused ? 10 : 0)
            }
            .navigationTitle(channelName)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                joinChannel(channel: channelName)
            }
    }
}
