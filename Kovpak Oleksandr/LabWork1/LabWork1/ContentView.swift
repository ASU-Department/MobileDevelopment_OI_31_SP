import SwiftUI

// --- ЧАСТИНА 1: Дочірній View (View Decomposition) ---
struct FollowButton: View {
    // @Binding дозволяє змінювати змінну, яка живе в ContentView
    @Binding var isFollowing: Bool

    var body: some View {
        Button(action: {
            // Перемикаємо стан (True/False)
            isFollowing.toggle()
        }) {
            HStack {
                Image(systemName: isFollowing ? "checkmark.circle.fill" : "plus.circle")
                Text(isFollowing ? "Ви стежите" : "Стежити")
            }
            .padding()
            .frame(width: 200)
            .background(isFollowing ? Color.green : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
    }
}

// --- ЧАСТИНА 2: Головний View (Parent) ---
struct ContentView: View {
    // @State — це "джерело правди". Змінна живе тут.
    @State private var isFavorite: Bool = false

    var body: some View {
        ZStack { // Вимога: використати ZStack
            Color.black.opacity(0.05).edgesIgnoringSafeArea(.all) // Фон
            
            VStack(spacing: 20) { // Вимога: використати VStack
                
                Text("MarketPulse")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Картка акції
                VStack(alignment: .leading, spacing: 15) {
                    HStack { // Вимога: використати HStack
                        Image(systemName: "apple.logo")
                            .font(.system(size: 40))
                        
                        VStack(alignment: .leading) {
                            Text("AAPL")
                                .font(.title)
                                .bold()
                            Text("Apple Inc.")
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("$225.50")
                            .font(.title2)
                            .bold()
                    }
                    
                    Divider()
                    
                    Text("Зміна за день: +1.2%")
                        .foregroundColor(.green)
                        .font(.subheadline)
                    
                    // Тут ми використовуємо наш окремий компонент і передаємо Binding ($)
                    HStack {
                        Spacer()
                        FollowButton(isFollowing: $isFavorite)
                        Spacer()
                    }
                    .padding(.top, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(.horizontal)
                
                Spacer()
                
                // Цей текст з'являється тільки якщо натиснута кнопка (Reactive UI)
                if isFavorite {
                    Text("🔔 Повідомлення про ціну увімкнено")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
