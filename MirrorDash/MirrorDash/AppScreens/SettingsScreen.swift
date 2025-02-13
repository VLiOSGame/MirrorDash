import SwiftUI

struct SettingsScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isMusicOn: Bool = false
    @State var isSoundsOn: Bool = true
    @State var isVibroOn: Bool = false
    
    var body: some View {
        ZStack {
            Color.mainDark.ignoresSafeArea()
            VStack {
                Text("Settings")
                    .font(FontFamily.Impact.regular.swiftUIFont(size: 26))
                    .foregroundColor(.white)
                    .shadow(color: .white, radius: 6)
                    .padding(.top, 20)
                
                Spacer()
                
                VStack() {
                    Text("Music")
                        .font(FontFamily.Impact.regular.swiftUIFont(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                    
                    Button {
                        isMusicOn.toggle()
                    } label: {
                        Image(isMusicOn ? .switchOn : .switchOff)
                            .resizable()
                            .frame(width: 62, height: 36)
                    }
                    .padding(.bottom, 20)
                    
                    Text("Sounds")
                        .font(FontFamily.Impact.regular.swiftUIFont(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                    
                    Button {
                        isSoundsOn.toggle()
                    } label: {
                        Image(isSoundsOn ? .switchOn : .switchOff)
                            .resizable()
                            .frame(width: 62, height: 36)
                    }
                    .padding(.bottom, 20)
                    
                    Text("Vibro")
                        .font(FontFamily.Impact.regular.swiftUIFont(size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 5)
                    
                    Button {
                        isVibroOn.toggle()
                    } label: {
                        Image(isVibroOn ? .switchOn : .switchOff)
                            .resizable()
                            .frame(width: 62, height: 36)
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
    }
}

#Preview {
    SettingsScreen()
}
