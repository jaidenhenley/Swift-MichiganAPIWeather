import AppIntents
import WidgetKit

struct BeachEntity: AppEntity {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let imageName: String

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
        BeachEntity(id: 1, name: "Belle Isle Beach", latitude: 42.3416, longitude: -82.9625, imageName: "belleIsle1"),
        BeachEntity(id: 2, name: "Grand Haven State Park", latitude: 43.0564, longitude: -86.2545, imageName: "grandHaven1"),
        BeachEntity(id: 3, name: "Silver Lake Beach", latitude: 43.6753, longitude: -86.5214, imageName: "silverLake1"),
        BeachEntity(id: 4, name: "Sleeping Bear Dunes", latitude: 44.8779, longitude: -86.0590, imageName: "sleepingBear1"),
        BeachEntity(id: 5, name: "Tawas Point State Park", latitude: 44.2572, longitude: -83.4467, imageName: "tawasStatePark1"),
        BeachEntity(id: 6, name: "Holland State Park", latitude: 42.7789, longitude: -86.2048, imageName: "hollandStatePark1"),
        BeachEntity(id: 7, name: "Ludington State Park", latitude: 44.0349, longitude: -86.5018, imageName: "ludington1"),
        BeachEntity(id: 8, name: "P.J. Hoffmaster State Park", latitude: 43.1329, longitude: -86.2654, imageName: "hoffmaster1"),
        BeachEntity(id: 9, name: "Warren Dunes State Park", latitude: 41.9153, longitude: -86.5934, imageName: "warrenDunes1"),
        BeachEntity(id: 10, name: "Petoskey State Park", latitude: 45.4068, longitude: -84.9086, imageName: "petoskey1"),
        BeachEntity(id: 11, name: "Pictured Rocks National Lakeshore", latitude: 46.5643, longitude: -86.3163, imageName: "picturedRocks1"),
        BeachEntity(id: 12, name: "Presque Isle Park", latitude: 46.5880, longitude: -87.3818, imageName: "presqueIslePark1"),
        BeachEntity(id: 13, name: "Harrisville State Park", latitude: 44.6475, longitude: -83.2976, imageName: "harrisville1"),
        BeachEntity(id: 14, name: "Sterling State Park", latitude: 41.9200, longitude: -83.3415, imageName: "williamCSterling1"),
        BeachEntity(id: 15, name: "Muskegon State Park", latitude: 43.2485, longitude: -86.3339, imageName: "muskegonStatePark1"),
        BeachEntity(id: 16, name: "Saugatuck Dunes State Park", latitude: 42.6968, longitude: -86.1903, imageName: "saugatuckDunes1"),
        BeachEntity(id: 17, name: "South Haven South Beach", latitude: 42.4031, longitude: -86.2736, imageName: "southHavenSouthBeach1"),
        BeachEntity(id: 18, name: "Port Crescent State Park", latitude: 44.0103, longitude: -83.0508, imageName: "portCrescent1"),
        BeachEntity(id: 19, name: "Albert E. Sleeper State Park", latitude: 43.9726, longitude: -83.2055, imageName: "albertESleeper1"),
        BeachEntity(id: 20, name: "McLain State Park", latitude: 47.2371, longitude: -88.6088, imageName: "mclainStatePark1"),
        BeachEntity(id: 21, name: "Porcupine Mountains", latitude: 46.7811, longitude: -89.6807, imageName: "porcupineMountainsWildernessStatePark1"),
        BeachEntity(id: 22, name: "Traverse City State Park", latitude: 44.7354, longitude: -85.5771, imageName: "traversecitystatepark1"),
        BeachEntity(id: 23, name: "Nordhouse Dunes", latitude: 43.9500, longitude: -86.4800, imageName: "nordhouse1"),
        BeachEntity(id: 24, name: "Harbor Beach", latitude: 43.8439, longitude: -82.6513, imageName: "harborBeach1"),
        BeachEntity(id: 25, name: "Fort Wilkins State Park", latitude: 47.4658, longitude: -87.8823, imageName: "lakewilkins1"),
        BeachEntity(id: 26, name: "Grand Marais Beach", latitude: 46.6741, longitude: -85.9766, imageName: "grandmarais1"),
        BeachEntity(id: 27, name: "Oval Beach", latitude: 42.6543, longitude: -86.2196, imageName: "ovalbeach1"),
        BeachEntity(id: 28, name: "Tunnel Park", latitude: 42.7654, longitude: -86.2198, imageName: "tunnelPark1"),
        BeachEntity(id: 29, name: "Pere Marquette Beach", latitude: 43.2317, longitude: -86.3539, imageName: "perebeach1"),
        BeachEntity(id: 30, name: "North Beach Park", latitude: 43.0731, longitude: -86.2567, imageName: "northbeachpark1"),
        BeachEntity(id: 31, name: "Kirk Park", latitude: 42.9920, longitude: -86.2534, imageName: "kirkPark1"),
        BeachEntity(id: 32, name: "Caseville County Park", latitude: 43.9414, longitude: -83.2716, imageName: "albertESleeper1"),
        BeachEntity(id: 33, name: "Lexington Beach", latitude: 43.2654, longitude: -82.5321, imageName: "lexingtonBeach1"),
        BeachEntity(id: 34, name: "Oscoda Beach", latitude: 44.4317, longitude: -83.3354, imageName: "oscoda1"),
        BeachEntity(id: 35, name: "Agate Beach", latitude: 47.4679, longitude: -87.8821, imageName: "agate1"),
        BeachEntity(id: 36, name: "Ontonagon Beach", latitude: 46.8731, longitude: -89.3217, imageName: "Ontonagon1"),
        BeachEntity(id: 37, name: "Whitefish Point Beach", latitude: 46.7698, longitude: -84.9574, imageName: "whitefish1"),
        BeachEntity(id: 38, name: "Munising Beach", latitude: 46.4121, longitude: -86.6554, imageName: "munisingBeach1"),
        BeachEntity(id: 39, name: "Bay City State Park", latitude: 43.6548, longitude: -83.8967, imageName: "baycity1"),
        BeachEntity(id: 40, name: "Lakeport State Park", latitude: 43.1432, longitude: -82.4987, imageName: "lakeport1"),
        BeachEntity(id: 41, name: "Cheboygan State Park", latitude: 45.6543, longitude: -84.4732, imageName: "cheboygan1"),
        BeachEntity(id: 42, name: "Hoeft State Park", latitude: 45.4321, longitude: -83.9876, imageName: "hoeft1"),
        BeachEntity(id: 43, name: "Fisherman's Island State Park", latitude: 45.2876, longitude: -85.2543, imageName: "fisherman1"),
        BeachEntity(id: 44, name: "Young State Park", latitude: 45.1987, longitude: -85.2198, imageName: "young1"),
        BeachEntity(id: 45, name: "Empire Beach", latitude: 44.8123, longitude: -86.0587, imageName: "empireBeach1"),
        BeachEntity(id: 46, name: "Leland Beach", latitude: 45.0234, longitude: -85.7654, imageName: "lelandBeach1"),
        BeachEntity(id: 47, name: "Frankfort Beach", latitude: 44.6321, longitude: -86.2354, imageName: "frankfort1"),
        BeachEntity(id: 48, name: "Arcadia Beach", latitude: 44.5123, longitude: -86.2198, imageName: "ludington1"),
        BeachEntity(id: 49, name: "Manistee North Beach", latitude: 44.2543, longitude: -86.3321, imageName: "manistee1"),
        BeachEntity(id: 50, name: "Pentwater Beach", latitude: 43.7832, longitude: -86.4321, imageName: "pentwater1"),
        BeachEntity(id: 51, name: "White Lake Beach", latitude: 43.5987, longitude: -86.3987, imageName: "whiteLake1"),
        BeachEntity(id: 52, name: "New Buffalo Beach", latitude: 41.7965, longitude: -86.7432, imageName: "newbuffalo1"),
        BeachEntity(id: 53, name: "St. Joseph Beach", latitude: 42.1098, longitude: -86.4876, imageName: "stjoe1"),
        BeachEntity(id: 54, name: "Lake Erie Metropark Beach", latitude: 42.0876, longitude: -83.1987, imageName: "lakeErie1"),
    ]
}

struct SelectBeachIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Select Beach"
    static var description = IntentDescription("Choose a beach to display")

    @Parameter(title: "Beach")
    var beach: BeachEntity?
}
