import SwiftUI

struct ChatBufferView: View {
    @ObservedObject var chatEngine = engine
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(chatEngine.logs, id: \.self) { logLine in
                        let parts = logLine.components(separatedBy: " : ")
                        let username = parts[0]
                        let msgBody = parts.dropFirst().joined(separator: " : ")
                        HStack {
                            Text("\(username) :")
                                .foregroundStyle(.green)
                                .fontWeight(.bold)
                                .font(.system(.subheadline, design: .monospaced, weight: .light))
                            Text(msgBody)
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
