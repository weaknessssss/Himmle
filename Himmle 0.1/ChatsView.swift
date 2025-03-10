//
//  ChatsView.swift
//  Himmle 0.1
//
//  Created on 09.03.2025.
//

import SwiftUI

struct Chat: Identifiable {
    let id = UUID()
    let contactName: String
    let lastMessage: String
    let time: String
    let unreadCount: Int
    let avatarName: String
}

struct ChatsView: View {
    @State private var searchText = ""
    @StateObject private var dataController = DataController()
    @StateObject private var messageDataService: MessageDataService
    var onOpenChat: ((ChatModel, MessageDataService) -> Void)?
    
    init(onOpenChat: ((ChatModel, MessageDataService) -> Void)? = nil) {
        let controller = DataController()
        _messageDataService = StateObject(wrappedValue: MessageDataService(dataController: controller))
        self.onOpenChat = onOpenChat
    }
    
    var filteredChats: [ChatModel] {
        if searchText.isEmpty {
            return messageDataService.chats
        } else {
            return messageDataService.chats.filter { chat in
                // Найти пользователя для одиночного чата
                if !chat.isGroup, let participantId = chat.participants.first(where: { $0 != "currentUser" }),
                   let user = messageDataService.getUser(by: participantId) {
                    return user.displayName.localizedCaseInsensitiveContains(searchText)
                }
                // Для группового чата
                else if let groupName = chat.groupName {
                    return groupName.localizedCaseInsensitiveContains(searchText)
                }
                return false
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredChats.indices, id: \.self) { index in
                    let chat = filteredChats[index]
                    // Вместо NavigationLink используем Button для кастомного перехода
                    Button(action: {
                        // Вызываем callback для открытия чата
                        if let onOpenChat = onOpenChat {
                            onOpenChat(chat, messageDataService)
                        }
                    }) {
                        ChatRowView(chat: chat, messageService: messageDataService)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(PlainButtonStyle())
                    // Скрываем верхний сепаратор только для первого элемента
                    .listRowSeparator(index == 0 ? .hidden : .visible, edges: index == 0 ? .top : .bottom)
                }
                // Удаляем отступы для разделителей, чтобы они проходили через весь экран
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Edit")
                        .foregroundColor(.blue)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Create new chat action
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

// Компонент поисковой строки
struct SearchBarView: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct ChatRowView: View {
    let chat: ChatModel
    let messageService: MessageDataService
    
    var displayName: String {
        if chat.isGroup {
            return chat.groupName ?? "Group Chat"
        } else if let participantId = chat.participants.first(where: { $0 != "currentUser" }),
                  let user = messageService.getUser(by: participantId) {
            return user.displayName
        }
        return "Unknown User"
    }
    
    var lastMessageContent: String {
        return chat.lastMessage?.content ?? "No messages yet"
    }
    
    var lastMessageTime: String {
        guard let date = chat.lastMessage?.timestamp else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
    
    var unreadCount: Int {
        return messageService.getMessages(for: chat.id).filter { !$0.isRead && $0.senderId != "currentUser" }.count
    }
    
    var body: some View {
        HStack(spacing: 6) {
            // Индикатор непрочитанных сообщений (синяя точка)
            if unreadCount > 0 {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
            } else {
                Spacer()
                    .frame(width: 8)
            }
            
            // Аватар
            if chat.isGroup, let groupAvatar = chat.groupAvatar {
                Image(systemName: "person.2.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 38, height: 38)
                    .foregroundColor(.blue)
            } else if let participantId = chat.participants.first(where: { $0 != "currentUser" }),
                      let user = messageService.getUser(by: participantId) {
                if let avatarURL = user.avatarURL {
                    AsyncImage(url: URL(string: avatarURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 38, height: 38)
                            .foregroundColor(.blue)
                    }
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 38, height: 38)
                        .foregroundColor(.blue)
                }
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(displayName)
                        .font(.headline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(lastMessageTime)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Text(lastMessageContent)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.leading, 8)
    }
}

struct ChatDetailView: View {
    let chat: ChatModel
    let messageService: MessageDataService
    let onBack: () -> Void
    @State private var messageText = ""
    @State private var messages: [MessageModel] = []
    @State private var showingUserProfile = false
    @State private var selectedUser: UserModel?
    
    // Получаем объект пользователя для отображения профиля
    var chatParticipant: UserModel? {
        if !chat.isGroup, let participantId = chat.participants.first(where: { $0 != "currentUser" }) {
            return messageService.getUser(by: participantId)
        }
        return nil
    }
    
    var displayName: String {
        if chat.isGroup {
            return chat.groupName ?? "Group Chat"
        } else if let participantId = chat.participants.first(where: { $0 != "currentUser" }),
                  let user = messageService.getUser(by: participantId) {
            return user.displayName
        }
        return "Unknown User"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Пользовательский заголовок для чата в стиле iOS Messages
            VStack(spacing: 8) {
                HStack(alignment: .top) {
                    // Кнопка "Назад" теперь вызывает переданный обработчик
                    Button(action: {
                        onBack()
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.blue)
                    }
                    .padding(.leading, 16)
                    .frame(width: 44, height: 44)
                    
                    Spacer()
                    
                    // Центрированная колонка с аватаром и именем
                    Button(action: {
                        // Для группового чата не показываем профиль при нажатии на название
                        if !chat.isGroup, let user = chatParticipant {
                            selectedUser = user
                            showingUserProfile = true
                        }
                    }) {
                        VStack(spacing: 6) {
                            // Аватар
                            if chat.isGroup, let groupAvatar = chat.groupAvatar {
                                Image(systemName: "person.2.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 44, height: 44)
                                    .background(Color(.systemGray6))
                                    .clipShape(Circle())
                                    .foregroundColor(.blue)
                            } else if let user = chatParticipant {
                                if let avatarURL = user.avatarURL {
                                    AsyncImage(url: URL(string: avatarURL)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 44, height: 44)
                                            .clipShape(Circle())
                                            .background(Color(.systemGray6))
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 44, height: 44)
                                            .foregroundColor(.blue)
                                            .background(Color(.systemGray6))
                                            .clipShape(Circle())
                                    }
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 44, height: 44)
                                        .foregroundColor(.blue)
                                        .background(Color(.systemGray6))
                                        .clipShape(Circle())
                                }
                            }
                            
                            // Имя контакта с индикатором возможности перехода
                            HStack(spacing: 4) {
                                Text(displayName)
                                    .font(.subheadline)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.black)
                                
                                // Стрелка показывается только для индивидуальных чатов
                                if !chat.isGroup {
                                    Image(systemName: "chevron.right")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .disabled(chat.isGroup)
                    .buttonStyle(PlainButtonStyle())
                    
                    Spacer()
                    
                    // Кнопка видеозвонка выровнена по аватарке
                    VStack {
                        Spacer().frame(height: 10)
                        Button(action: {
                            // Видеозвонок
                        }) {
                            Image(systemName: "video")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .padding(.trailing, 16)
                    .frame(width: 44, height: 44)
                }
                .padding(.top, 8)
                .padding(.bottom, 12)
                
                // Разделительная линия
                Divider()
                    .background(Color(.systemGray4))
            }
            
            // Если это групповой чат, показываем список участников
            if chat.isGroup {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(chat.participants, id: \.self) { participantId in
                            if let user = messageService.getUser(by: participantId), participantId != "currentUser" {
                                Button(action: {
                                    selectedUser = user
                                    showingUserProfile = true
                                }) {
                                    VStack {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Circle()
                                                    .fill(user.isOnline ? Color.green : Color.clear)
                                                    .frame(width: 10, height: 10)
                                                    .offset(x: 15, y: 15)
                                            )
                                        
                                        Text(user.displayName.split(separator: " ").first ?? "")
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .frame(width: 60)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGray6))
            }
            
            // Область чата с сообщениями
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(messages) { message in
                        MessageBubble(message: message, isFromCurrentUser: message.senderId == "currentUser")
                    }
                }
                .padding()
            }
            .onAppear {
                // Получаем сообщения
                let chatMessages = messageService.getMessages(for: chat.id)
                
                // Сортируем по времени
                messages = chatMessages.sorted(by: { $0.timestamp < $1.timestamp })
            }
            
            // Область ввода сообщения
            HStack {
                TextField("Message", text: $messageText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                Button(action: {
                    if !messageText.isEmpty {
                        messageService.sendMessage(content: messageText, chatId: chat.id)
                        messages = messageService.getMessages(for: chat.id).sorted(by: { $0.timestamp < $1.timestamp })
                        messageText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(10)
                }
            }
            .padding([.leading, .bottom, .trailing])
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showingUserProfile) {
            if let user = selectedUser {
                UserProfilePopupView(user: user, isPresented: $showingUserProfile)
            }
        }
    }
}

struct MessageBubble: View {
    let message: MessageModel
    let isFromCurrentUser: Bool
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: message.timestamp)
    }
    
    var body: some View {
        VStack(alignment: isFromCurrentUser ? .trailing : .leading) {
            HStack {
                if isFromCurrentUser {
                    Spacer()
                }
                
                Text(message.content)
                    .padding(12)
                    .background(isFromCurrentUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(isFromCurrentUser ? .white : .primary)
                    .cornerRadius(16)
                    .frame(maxWidth: 280, alignment: isFromCurrentUser ? .trailing : .leading)
                
                if !isFromCurrentUser {
                    Spacer()
                }
            }
            
            // Временная метка
            Text(formattedTime)
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.horizontal, 4)
                .padding(.top, 2)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ChatsView()
} 
