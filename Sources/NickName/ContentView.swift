import SwiftUI

struct ContentView: View {
    @State private var textmessage = ""
    
    var body: some View {
        ZStack {
            ChatBufferView()
            
            VStack(alignment: .leading) {
                Button(action: {
                    
                }) {
                    Image(systemName: "chevron.left")
                        .padding() 
                }
                .glassEffect(.regular.interactive(), in: .circle)
                .padding(.leading)
                
                Spacer()
                
                HStack {
                    TextField("Message", text: $textmessage)
                        .monospaced()
                        .padding(.leading)
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.up")
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                    .background(Capsule().fill(.blue.gradient))
                    .padding(.trailing, 6)
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
                .clipped()
                .glassEffect(.regular.interactive(), in: .capsule(style: .continuous))
                .padding(.horizontal)
            }
        }
    }
}