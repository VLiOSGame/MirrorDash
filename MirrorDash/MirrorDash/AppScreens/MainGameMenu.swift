import SwiftUI

struct MainGameMenu: View {
    @State private var isBouncing = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mainDark.ignoresSafeArea()
                
                VStack {
                    Image(.logo)
                        .resizable()
                        .frame(width: 310, height: 200)
                        .scaledToFit()
                    
                    NavigationLink {
                        LevelsScreen()
                    } label: {
                        Text("Play")
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                            .foregroundColor(.black)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .white, radius: 6)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 20)
                    
                    NavigationLink {
                        InfinityLevelScreen()
                    } label: {
                        Text("Infinity Mode")
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                            .foregroundColor(.black)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: .white, radius: 6)
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    
                    Spacer()
                    
                    // jumping balls
                    
                    VStack {
                        HStack {
                            Circle()
                                .frame(width: 40)
                                .foregroundColor(Color.ball1)
                                .padding(5)
                                .shadow(color: .white, radius: 6)
                                .offset(y: isBouncing ? -30 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 0.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(0.5),
                                    value: isBouncing
                                )
                            
                            Spacer()
                        }
                        
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 4)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .shadow(color: .white, radius: 6)
                        
                        HStack {
                            Spacer()
                            
                            Circle()
                                .frame(width: 40)
                                .foregroundColor(Color.ball2)
                                .padding(5)
                                .shadow(color: .white, radius: 6)
                                .offset(y: isBouncing ? 30 : 0)
                                .animation(
                                    Animation.easeInOut(duration: 0.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(0.5),
                                    value: isBouncing
                                )
                        }
                    }
                    .padding(.horizontal, 50)
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Spacer()
                        
                        NavigationLink {
                            HowToPlayScreen()
                        } label: {
                            Text("How to Play")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                        .shadow(color: .white, radius: 10)
                                )
                        }
                        
                        NavigationLink {
                            SettingsScreen()
                        } label: {
                            Text("Settings")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 2)
                                        .shadow(color: .white, radius: 10)
                                )
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .onAppear {
                self.isBouncing = true
            }
        }
    }
}

#Preview {
    MainGameMenu()
}
