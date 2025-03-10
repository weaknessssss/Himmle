//
//  ProfileScreenView.swift
//  Himmle 0.1
//
//  Created on 09.03.2025.
//

import SwiftUI

struct ProfileScreenView: View {
    @StateObject private var dataController = DataController()
    @StateObject private var messageDataService: MessageDataService
    @State private var currentUser: UserModel?
    
    init() {
        let controller = DataController()
        _messageDataService = StateObject(wrappedValue: MessageDataService(dataController: controller))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Верхняя секция с красным фоном и аватаром
                ZStack(alignment: .bottom) {
                    // Основной красный фон
                    Rectangle()
                        .fill(Color.red.opacity(0.9))
                    
                    // Размытый нижний край с переходом в белый
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white.opacity(0.3), .white.opacity(0.8)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 40)
                    .blur(radius: 10)
                    .padding(.bottom, -20) // Переходит слегка за край
                    
                    // Содержимое красной секции
                    VStack(spacing: 15) {
                        // Пустое пространство для учета островка
                        Spacer()
                            .frame(height: 50)
                        
                        // Аватар - красный круг
                        Circle()
                            .fill(Color.red)
                            .frame(width: 150, height: 150)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Имя с иконкой редактирования
                        HStack(spacing: 4) {
                            Text(currentUser?.displayName ?? "User")
                                .font(.title)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                // Действие редактирования
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.bottom, 30) // Увеличиваем нижний отступ для размытия
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Информационные секции
                VStack(spacing: 15) {
                    // Секция INFO
                    VStack(alignment: .leading, spacing: 5) {
                        // Заголовок секции
                        Text("INFO")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .padding([.top, .leading], 20) // Выравнивание с текстом в контейнере
                        
                        // Контейнер для информации
                        VStack(spacing: 0) {
                            // Дата рождения
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.black)
                                    .frame(width: 22)
                                Text("Date of birth")
                                    .font(.system(size: 16))
                                Spacer()
                                Text("9.11.2001")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Статус
                            HStack {
                                Circle()
                                    .fill(currentUser?.isOnline ?? false ? Color.green : Color.gray)
                                    .frame(width: 16.0, height: 16.0)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 0.0)
                                Text("Status")
                                    .font(.system(size: 16))
                                    .padding(.leading, 6)
                                Spacer()
                                Text(currentUser?.isOnline ?? false ? "Online" : "Offline")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 5)
                    
                    // Секция MORE INFO
                    VStack(alignment: .leading, spacing: 5) {
                        Text("MORE INFO")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .padding(.leading, 20) // Выравнивание с текстом в контейнере
                        
                        // Контейнер для дополнительной информации
                        VStack(spacing: 0) {
                            // Местоположение
                            HStack {
                                Image(systemName: "location.circle.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 22)
                                Text("Location")
                                    .font(.system(size: 16))
                                Spacer()
                                Text("New-York")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Профессия
                            HStack {
                                Image(systemName: "graduationcap.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 22)
                                Text("Profession")
                                    .font(.system(size: 16))
                                Spacer()
                                Text("airline pilot")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                            
                            Divider()
                                .padding(.leading, 50)
                            
                            // Хобби
                            HStack {
                                Image(systemName: "book.fill")
                                    .foregroundColor(.black)
                                    .frame(width: 22)
                                Text("Hobby")
                                    .font(.system(size: 16))
                                Spacer()
                                Text("firecracker development")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 20)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    
                    // Секция BIO
                    VStack(alignment: .leading, spacing: 5) {
                        Text("BIO")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .padding(.leading, 20) // Выравнивание с текстом в контейнере
                        
                        // Контейнер для био
                        VStack {
                            Text("You may not believe this, but I've got a dick up to my knees, hair down to my chest, and I'll fuck your bitch.")
                                .font(.system(size: 16))
                                .fontWeight(.regular)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            loadCurrentUser()
        }
    }
    
    // Загрузка данных текущего пользователя из сервиса сообщений
    private func loadCurrentUser() {
        // Для демонстрации возьмем первого пользователя из списка как "текущего"
        // В реальном приложении здесь будет логика получения аутентифицированного пользователя
        if !messageDataService.users.isEmpty {
            // Предположим, что текущий пользователь имеет ID "user1"
            currentUser = messageDataService.users.first { $0.id == "user1" }
        }
    }
}

#Preview {
    ProfileScreenView()
}
