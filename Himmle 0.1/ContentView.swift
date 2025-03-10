//
//  ContentView.swift
//  Himmle 0.1
//
//  Created by Никита Ободовской on 09.03.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var isChatOpen = false
    @State private var currentChat: (ChatModel, MessageDataService)? = nil
    
    var body: some View {
        ZStack {
            // Основное представление с вкладками (отображается, когда чат не открыт)
            if !isChatOpen {
                TabView(selection: $selectedTab) {
                    // Вкладка Чаты с передачей обработчика для открытия чата
                    ChatsTabWrapper(openChat: { chat, service in
                        currentChat = (chat, service)
                        isChatOpen = true
                    })
                    .tabItem {
                        Label("Chats", systemImage: "message.fill")
                    }
                    .tag(0)
                    
                    // Вкладка Search
                    SearchView()
                        .tabItem {
                            Label("Main", systemImage: "magnifyingglass")
                        }
                        .tag(1)
                    
                    // Вкладка Profile - заменяем ProfileScreenView на ProfileView
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .tag(2)
                }
            } else if let chatData = currentChat {
                // Полноэкранный чат (отображается при открытии чата)
                ChatDetailView(chat: chatData.0, messageService: chatData.1, onBack: {
                    // Обработчик закрытия чата
                    isChatOpen = false
                    currentChat = nil
                })
            }
        }
    }
}

// Обертка для ChatsView для передачи callback на открытие чата
struct ChatsTabWrapper: View {
    var openChat: (ChatModel, MessageDataService) -> Void
    
    var body: some View {
        ChatsView(onOpenChat: openChat)
    }
}

struct SearchView: View {
    var body: some View {
        VStack {
            Text("Empty")
                .foregroundColor(Color.gray)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
