import SwiftData

@available(iOS 17, *)
@Model
class Event {

    var id: String
    var name: String
    var city: String
    var date: String

    init(
        id: String,
        name: String,
        city: String,
        date: String
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.date = date
    }
}
