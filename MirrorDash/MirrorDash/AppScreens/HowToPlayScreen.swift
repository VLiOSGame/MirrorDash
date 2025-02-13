import SwiftUI

struct HowToPlayScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.mainDark.ignoresSafeArea()
            VStack {
                Text("How to Play")
                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 6)
                    .padding(.top, 20)
                
                Spacer()
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text(AppStrings.howToPlay1)
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text(AppStrings.howToPlay2)
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        Text(AppStrings.howToPlay3)
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 16))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 44)
                
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
    }
}

#Preview {
    HowToPlayScreen()
}
