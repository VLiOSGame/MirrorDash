import SwiftUI
import SpriteKit

struct Level3Screen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isGameFinished: Bool = false
    @State var gameResult: GameResult = .success
    @State var totalCoins = UserDefaults.standard.integer(forKey: "totalCoins")
    
    @State private var sceneID = UUID()
    
    var scene: SKScene {
        let scene = SKScene(fileNamed: "Level3")!
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
                Text("Level 3")
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
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name("GameFinished"), object: nil)
        }
    }
}

#Preview {
    Level3Screen()
}
