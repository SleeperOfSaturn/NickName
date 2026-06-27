import SwiftUI

struct ChatBufferView: View {
    @ObservedObject var chatEngine = engine
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(chatEngine.logs, id: \.self) { logLine in
                        let parts = logLine.components(separatedBy: " : ")
                        let username = parts[0]
                        let msgBody = parts.dropFirst().joined(separator: " : ")
                        
                        VStack(alignment: .leading, spacing: 4) { 
                            Text("\(username) :")
                                .foregroundStyle(.green)
                                .fontWeight(.bold)
                                .font(.system(.subheadline, design: .monospaced, weight: .light))
                            
                            Text(msgBody)
                                .font(.system(.body, design: .monospaced))
                        }
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
