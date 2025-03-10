//
//  UserProfilePopupView.swift
//  Himmle 0.1
//
//  Created on 09.03.2025.
//

import SwiftUI

struct UserProfilePopupView: View {
    let user: UserModel
    @Binding var isPresented: Bool
    
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
                    .padding(.bottom, -20)
                    
                    // Содержимое красной секции
                    VStack(spacing: 15) {
                        // Аватар - красный круг
                        Circle()
                            .fill(Color.red)
                            .frame(width: 100, height: 100)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        // Имя с username
                        Text(user.displayName)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                        Text("@\(user.username)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                            .padding(.bottom, 20)
                    }
                    .padding(.top, 20)
                }
                .frame(maxWidth: .infinity)
                
                // Информационные секции
                VStack(spacing: 15) {
                    // Секция INFO
                    VStack(alignment: .leading, spacing: 5) {
                        Text("INFO")
                            .font(.footnote)
                            .fontWeight(.regular)
                            .foregroundColor(.gray)
                            .padding([.top, .leading], 20)
                        
                        // Контейнер для информации
                        VStack(spacing: 0) {
                            // Дата рождения
                            if let dateOfBirth = user.dateOfBirth {
                                HStack {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.black)
                                        .frame(width: 22)
                                    Text("Date of birth")
                                        .font(.system(size: 16))
                                    Spacer()
                                    Text(dateOfBirth)
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 20)
                                
                                Divider()
                                    .padding(.leading, 50)
                            }
                            
                            // Статус
                            HStack {
                                Circle()
                                    .fill(user.isOnline ? Color.green : Color.gray)
                                    .frame(width: 16.0, height: 16.0)
                                    .padding(.leading, 3)
                                    .padding(.trailing, 0.0)
                                Text("Status")
                                    .font(.system(size: 16))
                                    .padding(.leading, 6)
                                Spacer()
                                Text(user.isOnline ? "Online" : "Offline")
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
                    if user.location != nil || user.profession != nil || user.hobby != nil {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("MORE INFO")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            // Контейнер для дополнительной информации
                            VStack(spacing: 0) {
                                // Местоположение
                                if let location = user.location {
                                    HStack {
                                        Image(systemName: "location.circle.fill")
                                            .foregroundColor(.black)
                                            .frame(width: 22)
                                        Text("Location")
                                            .font(.system(size: 16))
                                        Spacer()
                                        Text(location)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    
                                    if user.profession != nil || user.hobby != nil {
                                        Divider()
                                            .padding(.leading, 50)
                                    }
                                }
                                
                                // Профессия
                                if let profession = user.profession {
                                    HStack {
                                        Image(systemName: "graduationcap.fill")
                                            .foregroundColor(.black)
                                            .frame(width: 22)
                                        Text("Profession")
                                            .font(.system(size: 16))
                                        Spacer()
                                        Text(profession)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                    
                                    if user.hobby != nil {
                                        Divider()
                                            .padding(.leading, 50)
                                    }
                                }
                                
                                // Хобби
                                if let hobby = user.hobby {
                                    HStack {
                                        Image(systemName: "book.fill")
                                            .foregroundColor(.black)
                                            .frame(width: 22)
                                        Text("Hobby")
                                            .font(.system(size: 16))
                                        Spacer()
                                        Text(hobby)
                                            .font(.system(size: 16))
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 20)
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Секция BIO
                    if let bio = user.bio {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("BIO")
                                .font(.footnote)
                                .fontWeight(.regular)
                                .foregroundColor(.gray)
                                .padding(.leading, 20)
                            
                            // Контейнер для био
                            VStack {
                                Text(bio)
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
                }
                .background(Color(.systemGroupedBackground))
            }
        }
        .overlay(
            Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding(16)
            }
            .buttonStyle(PlainButtonStyle())
            , alignment: .topTrailing
        )
    }
} 