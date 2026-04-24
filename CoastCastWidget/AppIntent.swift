import AppIntents
import WidgetKit

struct BeachEntity: AppEntity {
    let id: Int
    let name: String

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Beach"
    static var defaultQuery = BeachQuery()

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct BeachQuery: EntityQuery {
    func entities(for identifiers: [Int]) async throws -> [BeachEntity] {
        BeachEntity.allBeaches.filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [BeachEntity] {
        BeachEntity.allBeaches
    }
}

extension BeachEntity {
    static let allBeaches: [BeachEntity] = [
        BeachEntity(id: 1, name: "Belle Isle Beach"),
        BeachEntity(id: 2, name: "Grand Haven State Park"),
        BeachEntity(id: 3, name: "Silver Lake Beach"),
        BeachEntity(id: 4, name: "Sleeping Bear Dunes"),
        BeachEntity(id: 5, name: "Tawas Point State Park"),
        BeachEntity(id: 6, name: "Holland State Park"),
        BeachEntity(id: 7, name: "Ludington State Park"),
        BeachEntity(id: 8, name: "P.J. Hoffmaster State Park"),
        BeachEntity(id: 9, name: "Warren Dunes State Park"),
        BeachEntity(id: 10, name: "Petoskey State Park"),
        BeachEntity(id: 11, name: "Pictured Rocks National Lakeshore"),
        BeachEntity(id: 12, name: "Presque Isle Park"),
        BeachEntity(id: 13, name: "Harrisville State Park"),
        BeachEntity(id: 14, name: "Sterling State Park"),
        BeachEntity(id: 15, name: "Muskegon State Park"),
        BeachEntity(id: 16, name: "Saugatuck Dunes State Park"),
        BeachEntity(id: 17, name: "South Haven South Beach"),
        BeachEntity(id: 18, name: "Port Crescent State Park"),
        BeachEntity(id: 19, name: "Albert E. Sleeper State Park"),
        BeachEntity(id: 20, name: "McLain State Park"),
        BeachEntity(id: 21, name: "Porcupine Mountains"),
        BeachEntity(id: 22, name: "Traverse City State Park"),
        BeachEntity(id: 23, name: "Nordhouse Dunes"),
        BeachEntity(id: 24, name: "Harbor Beach"),
        BeachEntity(id: 25, name: "Fort Wilkins State Park"),
        BeachEntity(id: 26, name: "Grand Marais Beach"),
        BeachEntity(id: 27, name: "Oval Beach"),
        BeachEntity(id: 28, name: "Tunnel Park"),
        BeachEntity(id: 29, name: "Pere Marquette Beach"),
        BeachEntity(id: 30, name: "North Beach Park"),
        BeachEntity(id: 31, name: "Kirk Park"),
        BeachEntity(id: 32, name: "Caseville County Park"),
        BeachEntity(id: 33, name: "Lexington Beach"),
        BeachEntity(id: 34, name: "Oscoda Beach"),
        BeachEntity(id: 35, name: "Agate Beach"),
        BeachEntity(id: 36, name: "Ontonagon Beach"),
        BeachEntity(id: 37, name: "Whitefish Point Beach"),
        BeachEntity(id: 38, name: "Munising Beach"),
        BeachEntity(id: 39, name: "Bay City State Park"),
        BeachEntity(id: 40, name: "Lakeport State Park"),
        BeachEntity(id: 41, name: "Cheboygan State Park"),
        BeachEntity(id: 42, name: "Hoeft State Park"),
        BeachEntity(id: 43, name: "Fisherman's Island State Park"),
        BeachEntity(id: 44, name: "Young State Park"),
        BeachEntity(id: 45, name: "Empire Beach"),
        BeachEntity(id: 46, name: "Leland Beach"),
        BeachEntity(id: 47, name: "Frankfort Beach"),
        BeachEntity(id: 48, name: "Arcadia Beach"),
        BeachEntity(id: 49, name: "Manistee North Beach"),
        BeachEntity(id: 50, name: "Pentwater Beach"),
        BeachEntity(id: 51, name: "White Lake Beach"),
        BeachEntity(id: 52, name: "New Buffalo Beach"),
        BeachEntity(id: 53, name: "St. Joseph Beach"),
        BeachEntity(id: 54, name: "Lake Erie Metropark Beach"),
    ]
}

struct SelectBeachIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Beach"
    static var description = IntentDescription("Choose a beach to display")

    @Parameter(title: "Beach")
    var beach: BeachEntity?
}
