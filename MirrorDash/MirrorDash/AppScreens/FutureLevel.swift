import SwiftUI

struct FutureLevel: View {
    @State private var isBouncing = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.mainDark.ignoresSafeArea()
                
                VStack {
                    VStack {
                        Text("Coming")
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 52))
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 6)
                        Text("Soon")
                            .font(FontFamily.Impact.regular.swiftUIFont(size: 52))
                            .foregroundColor(.white)
                            .shadow(color: .white, radius: 6)
                    }
                    
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
                    .padding(.bottom, 40)
                    
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
                    .padding(.vertical, 20)
                }
            }
            .onAppear {
                self.isBouncing = true
            }
        }
        .navigationBarBackButtonHidden()
    }
}
#Preview {
    FutureLevel()
}
