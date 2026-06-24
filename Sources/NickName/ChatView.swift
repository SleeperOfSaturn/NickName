import SwiftUI

struct ChatView: View {
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
                    
                    }) {
                        Image(systemName: "arrow.up")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                    }
                    .background(Capsule().fill(.blue.gradient))
                    .padding(.trailing, 10)
                }
                .padding(.vertical, 8) 
                .frame(maxWidth: .infinity)
                .clipped()
                .glassEffect(.regular.interactive(), in: .capsule(style: .continuous))
                .padding([.horizontal, .top])
                .padding(.bottom, isInputFieldFocused ? 10 : 0)
            }
            .navigationTitle("ChannelNameHere")
            .navigationBarTitleDisplayMode(.inline)
    }
}