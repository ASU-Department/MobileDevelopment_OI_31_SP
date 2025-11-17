struct Repository: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    var isStarred: Bool
}