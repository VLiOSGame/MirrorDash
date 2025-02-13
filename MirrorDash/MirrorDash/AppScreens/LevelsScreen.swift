import SwiftUI

struct LevelsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var finishedLevel: Int = 1
    
    var body: some View {
        ZStack {
            Color.mainDark.ignoresSafeArea()
            VStack {
                Text("Levels")
                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 6)
                    .padding(.top, 20)
                
                VStack(spacing: 20) {
                    // Levels 1-3
                    HStack(spacing: 20) {
                        LevelButton(navigateTo: AnyView(Level1Screen()), level: 1, finishedLevel: finishedLevel)
                        LevelButton(navigateTo: AnyView(Level2Screen()),level: 2, finishedLevel: finishedLevel)
                        LevelButton(navigateTo: AnyView(Level3Screen()),level: 3, finishedLevel: finishedLevel)
                    }
                    
                    // Levels 4-6
                    HStack(spacing: 20) {
                        LevelButton(navigateTo: AnyView(Level4Screen()),level: 4, finishedLevel: finishedLevel)
                        LevelButton(navigateTo: AnyView(FutureLevel()),level: 5, finishedLevel: finishedLevel)
                        LevelButton(navigateTo: AnyView(FutureLevel()),level: 6, finishedLevel: finishedLevel)
                    }
                    
                    // Levels 7-9
                    HStack(spacing: 20) {
                        LevelButton(navigateTo: AnyView(FutureLevel()),level: 7, finishedLevel: finishedLevel)
                        LevelButton(navigateTo: AnyView(FutureLevel()),level: 8, finishedLevel: finishedLevel)
                        LevelButton(navigateTo: AnyView(FutureLevel()),level: 9, finishedLevel: finishedLevel)
                    }
                    
                    // Level 10
                    HStack(spacing: 20) {
                        Spacer()
                        LevelButton(navigateTo: AnyView(FutureLevel()),level: 10, finishedLevel: finishedLevel)
                        Spacer()
                    }
                }
                
                Spacer()
                
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
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            finishedLevel = UserDefaults.standard.integer(forKey: "finishedLevel")
        }
    }
}

struct LevelButton: View {
    @State var navigateTo: AnyView
    var level: Int
    var finishedLevel: Int
    
    var body: some View {
        NavigationLink {
            navigateTo
        } label: {
            VStack {
                Text("\(level)")
                    .font(FontFamily.Impact.regular.swiftUIFont(size: 36))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                
                if level <= finishedLevel {
                    Image(systemName: "checkmark")
                        .resizable()
                        .frame(width: 19, height: 14)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                } else if level == finishedLevel + 1 {
                    Spacer()
                        .frame(height: 14)
                } else {
                    Image(systemName: "lock")
                        .resizable()
                        .scaledToFit()
                        .bold()
                        .frame(width: 21, height: 26)
                        .foregroundColor(.black)
                        .padding(.bottom, 20)
                }
            }
            .frame(height: 110)
            .padding(.horizontal, 30)
            .background(.white)
            .cornerRadius(12)
            .shadow(
                color: (level <= finishedLevel || level == finishedLevel + 1) ? .white : .clear,
                radius: 6
            )
            .opacity((level <= finishedLevel || level == finishedLevel + 1) ? 1 : 0.8)
        }
        .disabled(level > finishedLevel + 1 && level != 1)
    }
}

#Preview {
    LevelsScreen()
}
