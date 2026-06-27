import SwiftUI

struct ContentView: View {
    @AppStorage("animationsEnabled") private var animationsEnabled = true
    @State private var selectedTab = 0
    @Namespace private var glassMenuNamespace
    @State private var isMenuExpanded = false
    @State private var showSettings = false
    @State private var showServerConfig = false
    @StateObject private var viewModel = IRCViewModel()
    var body: some View {
        TabView(selection: $selectedTab) {
            
            NavigationStack {
                HomeView()
                    .environmentObject(viewModel)
                    .navigationTitle("NickName")
                    .toolbar {
                        menuToolbar
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)
            
            NavigationStack {
                SearchView()
                    .environmentObject(viewModel)
                    .navigationTitle("Console")
                    .toolbar {
                        menuToolbar
                    }
            }
            .tabItem {
                Label("Console", systemImage: "terminal.fill")
            }
            .tag(1)
        }
        .animation(
            animationsEnabled ? .snappy(duration: 0.4) : .none,
            value: selectedTab
        )
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                VStack {
                    Text("App Preferences & Customization")
                        .font(.system(.body, design: .monospaced))
                }
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $showServerConfig) {
            NavigationStack {
                VStack {
                    Text("Active IRC Network Host Configurations")
                        .font(.system(.body, design: .monospaced))
                }
                .navigationTitle("Change Server")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
    }
    
    @ToolbarContentBuilder
    private var menuToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            GlassEffectContainer(spacing: 8) {
                if !isMenuExpanded {
                    Button {
                        withAnimation(.spring(response: 0.32, dampingFraction: 0.75)) {
                            isMenuExpanded = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .font(.body.bold())
                            .foregroundStyle(.green)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                    }
                    .glassEffect(in: .capsule)
                    .glassEffectID("hamburger_core", in: glassMenuNamespace)
                    
                } else {
                    
                    HStack(spacing: 8) {
                        Button {
                            showSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .padding(8)
                        }
                        .glassEffect(in: .circle)
                        .glassEffectID("settings_node", in: glassMenuNamespace)
                        
                        Button {
                            showServerConfig = true
                        } label: {
                            Image(systemName: "server.rack")
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                                .padding(8)
                        }
                        .glassEffect(in: .circle)
                        .glassEffectID("server_node", in: glassMenuNamespace)
                        
                        Button {
                            withAnimation(.spring(response: 0.32, dampingFraction: 0.75)) {
                                isMenuExpanded = false
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                                .padding(8)
                        }
                        .glassEffect(in: .circle)
                        .glassEffectID("hamburger_core", in: glassMenuNamespace)
                    }
                }
            }
        }
    }
}
