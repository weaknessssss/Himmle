//
//  MessageDataModel.swift
//  Himmle 0.1
//
//  Created on 09.03.2025.
//

import Foundation
import CoreData

// MARK: - Core Data Model

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "HimmleData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - Data Models

// Модель сообщения для работы в приложении
struct MessageModel: Identifiable, Hashable {
    let id: String
    let senderId: String
    let chatId: String
    let content: String
    let timestamp: Date
    let isRead: Bool
    let attachments: [AttachmentModel]?
    
    init(id: String = UUID().uuidString, 
         senderId: String, 
         chatId: String, 
         content: String, 
         timestamp: Date = Date(), 
         isRead: Bool = false, 
         attachments: [AttachmentModel]? = nil) {
        self.id = id
        self.senderId = senderId
        self.chatId = chatId
        self.content = content
        self.timestamp = timestamp
        self.isRead = isRead
        self.attachments = attachments
    }
}

// Модель вложения
struct AttachmentModel: Identifiable, Hashable {
    let id: String
    let type: AttachmentType
    let url: String
    let thumbnailUrl: String?
    let size: Int64
    
    enum AttachmentType: String, Codable {
        case image
        case video
        case document
        case audio
    }
}

// Модель чата
struct ChatModel: Identifiable, Hashable {
    let id: String
    let participants: [String] // UIDs участников
    var lastMessage: MessageModel?
    let createdAt: Date
    let updatedAt: Date
    let isGroup: Bool
    let groupName: String?
    let groupAvatar: String?
    
    init(id: String = UUID().uuidString,
         participants: [String],
         lastMessage: MessageModel? = nil,
         createdAt: Date = Date(),
         updatedAt: Date = Date(),
         isGroup: Bool = false,
         groupName: String? = nil,
         groupAvatar: String? = nil) {
        self.id = id
        self.participants = participants
        self.lastMessage = lastMessage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isGroup = isGroup
        self.groupName = groupName
        self.groupAvatar = groupAvatar
    }
}

// MARK: - Data Service

class MessageDataService: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var chats: [ChatModel] = []
    @Published var messages: [String: [MessageModel]] = [:] // Key is chatId
    
    private let dataController: DataController
    
    init(dataController: DataController) {
        self.dataController = dataController
        loadMockData()
    }
    
    // Загрузка тестовых данных
    private func loadMockData() {
        // Mock Users - Добавлено больше пользователей с данными профиля
        users = [
            UserModel(
                id: "user1", 
                username: "johnsmith", 
                displayName: "John Smith", 
                avatarURL: nil, 
                isOnline: true,
                dateOfBirth: "9.11.2001",
                location: "New-York",
                profession: "airline pilot",
                hobby: "firecracker development",
                bio: "You may not believe this, but I've got a dick up to my knees, hair down to my chest, and I'll fuck your bitch."
            ),
            UserModel(
                id: "user2", 
                username: "sarahjohnson", 
                displayName: "Sarah Johnson",
                dateOfBirth: "15.04.1995",
                location: "Los Angeles",
                profession: "graphic designer",
                hobby: "photography",
                bio: "Creative mind with a passion for visual storytelling."
            ),
            UserModel(
                id: "user3", 
                username: "mikepeters", 
                displayName: "Mike Peters",
                dateOfBirth: "22.07.1988",
                location: "Chicago",
                profession: "software engineer",
                hobby: "gaming",
                bio: "Code by day, game by night. Coffee enthusiast."
            ),
            UserModel(
                id: "user4", 
                username: "annawilliams", 
                displayName: "Anna Williams",
                dateOfBirth: "03.12.1992",
                location: "Miami",
                profession: "fitness trainer",
                hobby: "cooking",
                bio: "Helping people achieve their fitness goals. Food lover."
            ),
            UserModel(
                id: "user5", 
                username: "davidchen", 
                displayName: "David Chen",
                dateOfBirth: "18.09.1990",
                location: "San Francisco",
                profession: "marketing manager",
                hobby: "hiking",
                bio: "Outdoor enthusiast and digital marketer. Always exploring new trails."
            ),
            UserModel(
                id: "user6", 
                username: "emilybrown", 
                displayName: "Emily Brown",
                isOnline: true,
                dateOfBirth: "27.06.1993",
                location: "Seattle",
                profession: "teacher",
                hobby: "painting",
                bio: "Elementary school teacher with a love for art and creativity."
            ),
            UserModel(
                id: "user7", 
                username: "alexturner", 
                displayName: "Alex Turner",
                dateOfBirth: "05.02.1985",
                location: "Austin",
                profession: "musician",
                hobby: "travel",
                bio: "Guitarist and songwriter. Collecting stories from around the world."
            ),
            UserModel(
                id: "user8", 
                username: "sophiagarcia", 
                displayName: "Sophia Garcia",
                isOnline: true,
                dateOfBirth: "11.11.1991",
                location: "Denver",
                profession: "architect",
                hobby: "skiing",
                bio: "Designing spaces and hitting the slopes whenever possible."
            ),
            UserModel(
                id: "user9", 
                username: "jacobmiller", 
                displayName: "Jacob Miller",
                dateOfBirth: "30.08.1987",
                location: "Boston",
                profession: "lawyer",
                hobby: "reading",
                bio: "Legal professional with a passion for classic literature."
            ),
            UserModel(
                id: "user10", 
                username: "oliviaroberts", 
                displayName: "Olivia Roberts",
                isOnline: true,
                dateOfBirth: "14.05.1994",
                location: "Portland",
                profession: "chef",
                hobby: "gardening",
                bio: "From garden to table. Creating culinary experiences with fresh ingredients."
            ),
            UserModel(
                id: "user11", 
                username: "willsmith", 
                displayName: "William Smith",
                dateOfBirth: "22.03.1989",
                location: "Philadelphia",
                profession: "doctor",
                hobby: "running",
                bio: "Healthcare professional and marathon runner. Advocating for healthy lifestyles."
            ),
            UserModel(
                id: "user12", 
                username: "emmawatson", 
                displayName: "Emma Watson",
                dateOfBirth: "19.10.1996",
                location: "Nashville",
                profession: "singer",
                hobby: "yoga",
                bio: "Finding harmony in music and mindfulness. Studio sessions and sunset yoga."
            ),
            UserModel(
                id: "user13", 
                username: "maxcroft", 
                displayName: "Max Croft",
                isOnline: true,
                dateOfBirth: "07.01.1984",
                location: "Detroit",
                profession: "engineer",
                hobby: "woodworking",
                bio: "Building bridges by day and furniture by night. Craftsman at heart."
            ),
            UserModel(
                id: "user14", 
                username: "lucylee", 
                displayName: "Lucy Lee",
                dateOfBirth: "24.12.1993",
                location: "Minneapolis",
                profession: "photographer",
                hobby: "surfing",
                bio: "Capturing moments through my lens. Ocean lover and adventure seeker."
            )
        ]
        
        // Создаем чаты для всех пользователей
        var allChats: [ChatModel] = []
        var allMessages: [String: [MessageModel]] = [:]
        
        // Добавляем обычные чаты с 1 на 1
        for i in 1...users.count {
            let userId = "user\(i)"
            let chatId = "chat\(i)"
            
            // Создаем несколько сообщений для этого чата
            var chatMessages: [MessageModel] = []
            
            // Сообщение 1 (от пользователя)
            let messageContent1 = getRandomFirstMessage(userId: userId)
            let twoHoursAgo = Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date()
            let message1 = MessageModel(
                senderId: userId, 
                chatId: chatId, 
                content: messageContent1,
                timestamp: twoHoursAgo,
                isRead: true
            )
            chatMessages.append(message1)
            
            // Сообщение 2 (ответ от текущего пользователя)
            let messageContent2 = getRandomReplyMessage()
            let oneHourAgo = Calendar.current.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
            let message2 = MessageModel(
                senderId: "currentUser", 
                chatId: chatId, 
                content: messageContent2,
                timestamp: oneHourAgo,
                isRead: true
            )
            chatMessages.append(message2)
            
            // Для некоторых чатов добавим еще сообщения
            if i % 3 == 0 {
                // Сообщение 3 (от пользователя опять)
                let messageContent3 = getRandomFollowUpMessage()
                let thirtyMinsAgo = Calendar.current.date(byAdding: .minute, value: -30, to: Date()) ?? Date()
                let message3 = MessageModel(
                    senderId: userId, 
                    chatId: chatId, 
                    content: messageContent3,
                    timestamp: thirtyMinsAgo,
                    isRead: i % 2 == 0 // некоторые непрочитаны
                )
                chatMessages.append(message3)
            }
            
            // Для каждого второго чата добавим свежее сообщение
            if i % 2 == 0 {
                // Сообщение 4 (последнее сообщение от пользователя)
                let messageContent4 = getRandomLatestMessage()
                let fiveMinutesAgo = Calendar.current.date(byAdding: .minute, value: -5, to: Date()) ?? Date()
                let message4 = MessageModel(
                    senderId: userId, 
                    chatId: chatId, 
                    content: messageContent4,
                    timestamp: fiveMinutesAgo,
                    isRead: false // непрочитанное
                )
                chatMessages.append(message4)
            }
            
            // Создаем чат с этими сообщениями
            let chat = ChatModel(
                id: chatId,
                participants: ["currentUser", userId],
                lastMessage: chatMessages.last,
                createdAt: Date(timeIntervalSinceNow: -86400 * Double(i)), // разное время создания
                updatedAt: chatMessages.last?.timestamp ?? Date()
            )
            
            allChats.append(chat)
            allMessages[chatId] = chatMessages
        }
        
        // Добавляем групповые чаты
        // Групповой чат 1
        let groupChat1 = ChatModel(
            id: "groupChat1",
            participants: ["currentUser", "user1", "user2", "user3"],
            lastMessage: MessageModel(
                senderId: "user1", 
                chatId: "groupChat1", 
                content: "Всем привет! Когда встречаемся?",
                timestamp: Date(timeIntervalSinceNow: -1800),
                isRead: false
            ),
            isGroup: true,
            groupName: "Друзья",
            groupAvatar: nil
        )
        
        // Сообщения для группового чата 1
        let groupMessages1 = [
            MessageModel(
                senderId: "user2", 
                chatId: "groupChat1", 
                content: "Привет всем! Какие планы на выходные?",
                timestamp: Date(timeIntervalSinceNow: -7200),
                isRead: true
            ),
            MessageModel(
                senderId: "currentUser", 
                chatId: "groupChat1", 
                content: "Я свободен в субботу после обеда",
                timestamp: Date(timeIntervalSinceNow: -5400),
                isRead: true
            ),
            MessageModel(
                senderId: "user3", 
                chatId: "groupChat1", 
                content: "Можно встретиться в парке",
                timestamp: Date(timeIntervalSinceNow: -3600),
                isRead: true
            ),
            MessageModel(
                senderId: "user1", 
                chatId: "groupChat1", 
                content: "Всем привет! Когда встречаемся?",
                timestamp: Date(timeIntervalSinceNow: -1800),
                isRead: false
            )
        ]
        
        // Групповой чат 2
        let groupChat2 = ChatModel(
            id: "groupChat2",
            participants: ["currentUser", "user4", "user5", "user6", "user7"],
            lastMessage: MessageModel(
                senderId: "user4", 
                chatId: "groupChat2", 
                content: "Я всем отправил документы по email",
                timestamp: Date(timeIntervalSinceNow: -900),
                isRead: true
            ),
            isGroup: true,
            groupName: "Рабочий проект",
            groupAvatar: nil
        )
        
        // Сообщения для группового чата 2
        let groupMessages2 = [
            MessageModel(
                senderId: "user5", 
                chatId: "groupChat2", 
                content: "Коллеги, нам нужно подготовить презентацию к понедельнику",
                timestamp: Date(timeIntervalSinceNow: -10800),
                isRead: true
            ),
            MessageModel(
                senderId: "currentUser", 
                chatId: "groupChat2", 
                content: "Я могу подготовить первые 5 слайдов",
                timestamp: Date(timeIntervalSinceNow: -9000),
                isRead: true
            ),
            MessageModel(
                senderId: "user6", 
                chatId: "groupChat2", 
                content: "Я возьму на себя финансовый раздел",
                timestamp: Date(timeIntervalSinceNow: -5400),
                isRead: true
            ),
            MessageModel(
                senderId: "user4", 
                chatId: "groupChat2", 
                content: "Я всем отправил документы по email",
                timestamp: Date(timeIntervalSinceNow: -900),
                isRead: true
            )
        ]
        
        // Добавляем групповые чаты и их сообщения
        allChats.append(groupChat1)
        allChats.append(groupChat2)
        allMessages["groupChat1"] = groupMessages1
        allMessages["groupChat2"] = groupMessages2
        
        // Сортируем чаты по времени последнего сообщения (самые свежие вверху)
        allChats.sort { ($0.lastMessage?.timestamp ?? $0.updatedAt) > ($1.lastMessage?.timestamp ?? $1.updatedAt) }
        
        // Обновляем данные
        chats = allChats
        messages = allMessages
    }
    
    // Вспомогательные методы для генерации разнообразного текста сообщений
    private func getRandomFirstMessage(userId: String) -> String {
        let firstMessages = [
            "Привет! Как дела?",
            "Здравствуй! Давно не виделись.",
            "Привет, ты свободен на выходных?",
            "Доброе утро! Как прошел твой день?",
            "Здравствуй! Нужно обсудить один вопрос.",
            "Привет! Видел новости сегодня?",
            "Хей! Как прошла встреча?",
            "Доброго времени суток! Есть минутка?",
            "Привет, помнишь о нашей договоренности?",
            "Здравствуй! Хотел узнать твое мнение."
        ]
        
        return firstMessages[Int(userId.hash) % firstMessages.count]
    }
    
    private func getRandomReplyMessage() -> String {
        let replyMessages = [
            "Привет! Все отлично, спасибо! У тебя как?",
            "Здравствуй! Да, давненько. Что нового?",
            "Привет! Да, должен быть свободен. А что планируется?",
            "Доброе утро! День только начался, но пока всё хорошо.",
            "Привет! Конечно, о чем речь?",
            "Да, видел. Это что-то невероятное!",
            "Встреча прошла успешно, спасибо что спросил!",
            "Привет! Да, минутка есть. Что случилось?",
            "Конечно помню, не переживай.",
            "Привет! Конечно, я всегда рад помочь советом."
        ]
        
        return replyMessages[Int.random(in: 0..<replyMessages.count)]
    }
    
    private func getRandomFollowUpMessage() -> String {
        let followUpMessages = [
            "Отлично! Хотел предложить встретиться на выходных.",
            "У меня все по-старому. Работа, дом...",
            "Думаю собраться небольшой компанией в парке.",
            "Рад слышать! У меня тоже день начался неплохо.",
            "Мне нужна твоя помощь с одним проектом.",
            "Да, я был в шоке, когда увидел эту новость!",
            "Босс остался доволен презентацией.",
            "Возникли некоторые проблемы с заказом.",
            "Встречаемся завтра в 6, как договаривались?",
            "Спасибо! Тогда вот что я думаю по этому поводу..."
        ]
        
        return followUpMessages[Int.random(in: 0..<followUpMessages.count)]
    }
    
    private func getRandomLatestMessage() -> String {
        let latestMessages = [
            "Кстати, не забудь взять с собой документы.",
            "Чуть не забыл спросить - ты идешь завтра?",
            "Только что получил сообщение от Алекса, он тоже придет.",
            "Напомни мне об этом завтра, пожалуйста.",
            "Вышлю тебе все детали по email.",
            "Извини, мне нужно бежать. Поговорим позже!",
            "Только что видел эту новость! Невероятно!",
            "Чуть не забыл - с днем рождения!",
            "Можешь скинуть мне ссылку на тот сайт?",
            "Кстати, я завтра буду в твоем районе."
        ]
        
        return latestMessages[Int.random(in: 0..<latestMessages.count)]
    }
    
    // MARK: - Public Methods
    
    func getChat(by id: String) -> ChatModel? {
        return chats.first { $0.id == id }
    }
    
    func getUser(by id: String) -> UserModel? {
        return users.first { $0.id == id }
    }
    
    func getMessages(for chatId: String) -> [MessageModel] {
        return messages[chatId] ?? []
    }
    
    func sendMessage(content: String, chatId: String, senderId: String = "currentUser") {
        let newMessage = MessageModel(senderId: senderId, chatId: chatId, content: content)
        
        // Update messages array
        var chatMessages = messages[chatId] ?? []
        chatMessages.append(newMessage)
        messages[chatId] = chatMessages
        
        // Update last message in chat
        if let index = chats.firstIndex(where: { $0.id == chatId }) {
            var updatedChat = chats[index]
            updatedChat.lastMessage = newMessage
            chats[index] = updatedChat
        }
    }
} 
