//
//  ContentView.swift
//  CineGuide
//
//  Lab 2
import SwiftUI
import MapKit
import PhotosUI
import UserNotifications

// Movie model - added coordinates and poster image
struct Movie: Identifiable {
    let id = UUID()
    let title: String
    var rating: Int
    var coordinate: CLLocationCoordinate2D? = nil
    var posterImage: UIImage? = nil
}

struct ContentView: View {
    @State private var movies: [Movie] = []
    @State private var selectedMovie: Movie? = nil
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($movies) { $movie in
                    NavigationLink {
                        DetailView(movie: $movie)
                    } label: {
                        MovieRow(movie: $movie)
                    }
                }
            }
            .navigationTitle("CineGuide")
            .onAppear {
                if movies.isEmpty {
                    loadDefaultMovies()
                }
            }
        }
    }
    
    func loadDefaultMovies() {
        movies = [
            Movie(title: "Оппенгеймер", rating: 4, coordinate: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917)),
            Movie(title: "Дюна 2", rating: 5, coordinate: CLLocationCoordinate2D(latitude: 31.7619, longitude: -106.4850)),
            Movie(title: "Інтерстеллар", rating: 3),
            Movie(title: "Темний лицар", rating: 5)
        ]
    }
}

struct MovieRow: View {
    @Binding var movie: Movie
    
    var body: some View {
        HStack {
            if let img = movie.posterImage {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .cornerRadius(8)
                    .overlay(Text("?").font(.largeTitle))
            }
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text("Рейтинг: \(movie.rating)/5")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            ClickableStars(rating: $movie.rating)
        }
        .padding(.vertical, 4)
    }
}

struct ClickableStars: View {
    @Binding var rating: Int
    private let maxRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = star
                    }
            }
        }
    }
}

// Detail screen for each movie
struct DetailView: View {
    @Binding var movie: Movie
    @State private var selectedPhoto: PhotosPickerItem? = nil
    
    var body: some View {
        Form {
            Section("Постер") {
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Label("Вибрати фото з галереї", systemImage: "photo")
                }
                .onChange(of: selectedPhoto) {
                    newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            movie.posterImage = image
                        }
                    }
                }
                
                if let img = movie.posterImage {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                }
            }
            
            Section("Карта зйомок") {
                if let coord = movie.coordinate {
                    MapView(coordinate: coord)
                        .frame(height: 300)
                        .cornerRadius(12)
                } else {
                    Text("Місце зйомок невідоме 😢")
                }
            }
            
            Section("Рейтинг") {
                ClickableStars(rating: $movie.rating)
                    .font(.title2)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// UIViewRepresentable - MKMapView wrapper
struct MapView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
        uiView.removeAnnotations(uiView.annotations)
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Тут знімали"
        uiView.addAnnotation(pin)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        // can do something with anotation
    }
}

// AppDelegate for extra task
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
       
        print("AppDelegate стартував — додаємо бонусний фільм")
        
        // ask for notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        
        let content = UNMutableNotificationContent()
        content.title = "Ласкаво просимо в CineGuide!"
        content.body = "Не забудь оцінити всі фільми ⭐"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "welcome", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        return true
    }
}

// Main App entry point with delegate
@main
struct CineGuideApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

#Preview {
    ContentView()
}
