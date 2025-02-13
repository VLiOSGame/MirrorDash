import SwiftUI
import SpriteKit

struct Level4Screen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isGameFinished: Bool = false
    @State var isShieldActive: Bool = false
    @State var gameResult: GameResult = .success
    @State var totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
    @State private var progress: CGFloat = 1.0 // Начальный прогресс

    @State private var sceneID = UUID()
    
    var scene: SKScene {
        let scene = SKScene(fileNamed: "Level4")!
        scene.size = CGSize(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        scene.scaleMode = .aspectFill
        return scene
    }
    
    var body: some View {
        ZStack {
            Color.mainDark.ignoresSafeArea()
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea()
                .id(sceneID)
            
            VStack {
                if isShieldActive {
                    VStack {
                        HStack {
                            Image(.shieldIcon)
                                .resizable()
                                .frame(width: 12, height: 15)
                            Text("Shield")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 16))
                                .foregroundColor(.white)
                        }
                        ProgressBar(value: $progress)
                            .frame(height: 5)
                            .padding(.top, 10)
                            .padding(.horizontal, 50)
                    }
                    .onAppear {
                        // Запускаем таймер для прогресса
                        withAnimation(.linear(duration: 1.5)) {
                            progress = 0.0 // Уменьшаем прогресс
                        }
                        // По завершению таймера сбрасываем shield
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            isShieldActive = false
                            progress = 1.0 // Возвращаем прогресс в исходное состояние
                        }
                    }
                }
                
                if isGameFinished {
                    switch gameResult {
                    case .success:
                        VStack {
                            Text("GREAT")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 52))
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 6)
                            Text("Level Completed")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 32))
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 6)
                        }
                    case .loose:
                        VStack {
                            Text("Oops")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 52))
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 6)
                            Text("Try Again")
                                .font(FontFamily.Impact.regular.swiftUIFont(size: 32))
                                .foregroundColor(.white)
                                .shadow(color: .white, radius: 6)
                        }
                    }
                }
                
                Spacer()
                
                if isGameFinished {
                    switch gameResult {
                    case .success:
                        VStack(spacing: 10) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Back")
                                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .white, radius: 6)
                            }
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Next Level")
                                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .white, radius: 6)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                    case .loose:
                        VStack(spacing: 10) {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("Back")
                                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .white, radius: 6)
                            }
                            Button {
                                sceneID = UUID()
                                isGameFinished = false
                            } label: {
                                Text("Try Again")
                                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                                    .foregroundColor(.black)
                                    .padding(.vertical, 20)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: .white, radius: 6)
                            }
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                    }
                } else {
                    Button {
                        NotificationCenter.default.post(name: NSNotification.Name("JumpButtonPressed"), object: nil)
                    } label: {
                        Text("Jump")
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
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Level 4")
                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 6)
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(.pauseButton)
                        .resizable()
                        .frame(width: 10, height: 15)
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .white, radius: 6)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Text("\(totalCoins)")
                        .font(FontFamily.Impact.regular.swiftUIFont(size: 18))
                        .foregroundColor(.white)
                        .shadow(color: .white, radius: 6)
                    Image(.coin)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .shadow(color: .white, radius: 6)
                }
            }
        }
        .onAppear {
            totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("GameFinished"),
                object: nil,
                queue: .main
            ) { notification in
                if let userInfo = notification.userInfo,
                   let result = userInfo["result"] as? GameResult {
                    isGameFinished = true
                    gameResult = result
                }
                totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
            }
            NotificationCenter.default.addObserver(
                forName: NSNotification.Name("ShieldIsActive"),
                object: nil,
                queue: .main
            ) { _ in
                isShieldActive = true
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GameFinished"), object: nil)
        }
    }
}

struct ProgressBar: View {
    @Binding var value: CGFloat

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 250, height: 5)
            Capsule()
                .fill(Color.white)
                .frame(width: value * 250, height: 5)
        }
        .cornerRadius(5)
    }
}

#Preview {
    Level4Screen()
}
