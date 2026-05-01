//
//  Beach.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/10/26.
//

import CoreLocation
import SwiftUI

struct Beach: Identifiable {
    
    let id: Int
    let beachName: String
    let shortDescription: String
    let description: String
    let coordinates: CLLocationCoordinate2D
    let keywords: [String]
    let displayKeywords: [DisplayKeyword]
    let images: [ImageResource]
    let phoneNumber: String
    let websiteURL: URL?
    let bodyOfWater: String
    let parkType: ParkType
    let isSwimmable: Bool
    let hasCamping: Bool
    
    var clLocation: CLLocation {
        CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
    }
    
    // Aliases are for better siri integration
    var aliases: [String] {
        var result: [String] = []
        let name = beachName
        
        let suffixes = [" State Park", " County Park", " City Beach", " Metropark", " Beach", " National Park"]
        
        for suffix in suffixes {
            if name.hasSuffix(suffix) {
                let stripped = String(name.dropLast(suffix.count))
                if !stripped.isEmpty && stripped != name {
                    result.append(stripped)
                    if !stripped.hasSuffix(" Beach") {
                        result.append(stripped + " Beach")
                    }
                }
                break
            }
        }
        
        if let first = name.split(separator: " ").first.map(String.init),
           first != name && !result.contains(first) {
            result.append(first)
        }
        
        return result
    }
    
    
    enum ParkType: String {
        case statePark = "state_park"
        case nationalPark = "national_park"
        case cityBeach = "city_beach"
        case countyPark = "county_park"
        case metropark = "metropark"
        case wildernessArea = "wilderness_area"
        
        var label: String {
            switch self {
            case .statePark: return "State Park"
            case .nationalPark: return "National Park"
            case .cityBeach: return "City Beach"
            case .countyPark: return "County Park"
            case .metropark: return "Metropark"
            case .wildernessArea: return "Wilderness Area"
            }
        }
    }
    
    struct DisplayKeyword {
            let icon: String?
            let label: String
        }
        
        static let allBeaches: [Beach] = [
            Beach(
                id: 1,
                beachName: "Belle Isle Beach",
                shortDescription: "Urban waterfront beach on the Detroit River with views of the city skyline.",
                description: "Belle Isle Beach offers something no other Michigan beach can: a waterfront experience inside one of the country's great urban island parks.\n\nSet on the Detroit River, the beach looks out toward the Canadian shoreline and the Windsor skyline while the towers of downtown Detroit rise behind you. It's a neighborhood beach, a city escape, and a historic landmark all at once.\n\nBelle Isle itself has a conservatory, an aquarium, and miles of trails. The beach draws Detroit residents who want the water close without leaving the city behind.",
                coordinates: .init(latitude: 42.3416, longitude: -82.9625),
                keywords: ["detroit river", "southeast michigan", "urban", "skyline", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Detroit River"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.belleIsle1, .belleIsle2, .belleIsle3],
                phoneNumber: "(313) 821-9844",
                websiteURL: URL(string: "https://www.belleislepark.org/"),
                bodyOfWater: "Detroit River",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 2,
                beachName: "Grand Haven State Park",
                shortDescription: "Iconic lighthouse, long sandy beach, and legendary sunsets at the mouth of the Grand River.",
                description: "Sitting at the mouth of the Grand River, Grand Haven State Park is West Michigan's classic beach destination. The long, sandy shoreline stretches south from the channel, flanked by the iconic red lighthouse that has become one of the most photographed spots on all of Lake Michigan.\n\nSunsets here are legendary. The boardwalk connects to downtown Grand Haven, giving visitors easy access to restaurants, shops, and the famous Musical Fountain.\n\nBring a beach chair, stake your spot early on a summer weekend, and plan to stay until the sky goes orange.",
                coordinates: .init(latitude: 43.0564, longitude: -86.2545),
                keywords: ["lake michigan", "west michigan", "lighthouse", "fishing", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.grandHaven1, .grandHaven2, .grandHaven3],
                phoneNumber: "(616) 847-1309",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=449&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 3,
                beachName: "Silver Lake Beach",
                shortDescription: "West Michigan dune beach popular for off-road riding and wide-open Lake Michigan views.",
                description: "Silver Lake Beach sits at the edge of a landscape unlike anything else in Michigan. The Silver Lake Sand Dunes roll up behind the beach in massive, vehicle-carved ridges, making this a destination for both thrill-seekers and laid-back swimmers.\n\nThe beach itself faces a calm inland lake, while Lake Michigan lies just over the dunes to the west. It's a rare setup: two bodies of water within walking distance of each other.\n\nDune rides, beach bonfires, and summer cabins have made this a West Michigan tradition for generations.",
                coordinates: .init(latitude: 43.6753, longitude: -86.5214),
                keywords: ["lake michigan", "west michigan", "dunes", "orv", "off road", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.silverLake1, .silverLake2, .silverLake3],
                phoneNumber: "(231) 873-3083",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=493&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 4,
                beachName: "Sleeping Bear Dunes",
                shortDescription: "35 miles of towering dunes and crystal-clear Lake Michigan shoreline in northwest Michigan.",
                description: "Stretching across 35 miles of Lake Michigan shoreline, Sleeping Bear Dunes National Lakeshore is one of the most breathtaking stretches of freshwater coastline in the country. Towering sand dunes rise hundreds of feet above the lake, offering panoramic views that stop people in their tracks.\n\nThe water is glacier-fed, cold, and impossibly clear. Whether you're hiking the Dune Climb, paddling the Platte River, or watching the sun sink behind South Manitou Island, this place earns its reputation as one of the most beautiful places in America.",
                coordinates: .init(latitude: 44.8779, longitude: -86.0590),
                keywords: ["lake michigan", "northwest michigan", "dunes", "hiking", "kayaking", "national park"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "National Park"),
                ],
                images: [.sleepingBear1, .sleepingBear2, .sleepingBear3],
                phoneNumber: "(231) 326-4700",
                websiteURL: URL(string: "https://www.nps.gov/slbe"),
                bodyOfWater: "Lake Michigan",
                parkType: .nationalPark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 5,
                beachName: "Tawas Point State Park",
                shortDescription: "Calm, shallow Lake Huron waters and a historic lighthouse on a curved sandy spit.",
                description: "Often called the Sleeping Bear of Lake Huron, Tawas Point State Park juts into the lake on a curved sandy spit that collects warm, shallow water on its protected inner shore. The result is some of the most swimmer-friendly conditions in the state.\n\nFamilies with young kids love it here. A historic lighthouse stands at the tip of the point, and the surrounding area is a known birding hotspot during spring and fall migrations.\n\nThe pace is quiet, the water is calm, and the sunrises over the open lake are worth setting an alarm for.",
                coordinates: .init(latitude: 44.2572, longitude: -83.4467),
                keywords: ["lake huron", "sunrise coast", "lighthouse", "fishing", "hiking", "kayaking", "bird watching"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.tawasStatePark1, .tawasStatePark2, .tawasStatePark3],
                phoneNumber: "(989) 362-5041",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=499&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 6,
                beachName: "Holland State Park",
                shortDescription: "One of Michigan's most photographed lighthouses anchors this wide Lake Michigan beach.",
                description: "Holland State Park sits where Lake Macatawa meets Lake Michigan, anchored by the bright red Big Red lighthouse that has graced more Michigan postcards than nearly any other landmark.\n\nThe beach is wide and well-maintained, with soft sand, consistent waves, and easy parking access that draws visitors from across the Midwest. The channel offers a breakwater walk with views in both directions.\n\nDowntown Holland is minutes away. It's one of those parks that works for everyone: families, couples, day trippers, and anyone who just wants to stand at the edge of something huge and blue.",
                coordinates: .init(latitude: 42.7789, longitude: -86.2048),
                keywords: ["lake michigan", "west michigan", "lighthouse", "fishing", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.hollandStatePark1, .hollandStatePark2, .hollandStatePark3],
                phoneNumber: "(616) 399-9390",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=458&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 7,
                beachName: "Ludington State Park",
                shortDescription: "Miles of undeveloped Lake Michigan shoreline tucked between towering dunes and Hamlin Lake.",
                description: "Ludington State Park is the full package. Tucked between Hamlin Lake and Lake Michigan, the park offers miles of undeveloped shoreline on both sides: calm freshwater paddling on the inland lake and open wave swimming on the big lake.\n\nTowering forested dunes separate the two, crisscrossed by trails that reward the effort with sweeping views of both. The beach on the Lake Michigan side is wide, clean, and rarely feels crowded given the size of the park.\n\nA historic lighthouse stands at the north end of the beach, reachable by foot or kayak along the lakeshore.",
                coordinates: .init(latitude: 44.0349, longitude: -86.5018),
                keywords: ["lake michigan", "west michigan", "dunes", "hiking", "fishing", "kayaking", "lighthouse"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.ludington1, .ludington2, .ludington3],
                phoneNumber: "(231) 843-2423",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=468&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 8,
                beachName: "P.J. Hoffmaster State Park",
                shortDescription: "Three miles of pristine Lake Michigan beach in a quiet, forested dune setting.",
                description: "P.J. Hoffmaster State Park is a quiet alternative to the busier beach towns that line West Michigan's shoreline. Three miles of Lake Michigan beach stretch between forested dune ridges and the water, with trails winding through one of the most intact dune ecosystems left on the eastern shore.\n\nThe E. Genevieve Gillette Nature Center offers a solid introduction to how these dunes formed and why they matter. The beach itself is clean and rarely packed.\n\nIf you want a Lake Michigan day without the crowds, the concession stands, and the parking lot gridlock, this is the place.",
                coordinates: .init(latitude: 43.1329, longitude: -86.2654),
                keywords: ["lake michigan", "west michigan", "dunes", "hiking", "nature"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.hoffmaster1, .hoffmaster2, .hoffmaster3],
                phoneNumber: "(231) 798-3711",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=457&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 9,
                beachName: "Warren Dunes State Park",
                shortDescription: "Dramatic 260-foot dunes and wide sandy beach just 90 minutes from Chicago.",
                description: "Warren Dunes is where Chicago comes to spend the weekend on the water. Just 90 minutes from the city, the park draws enormous summer crowds to its 260-foot dunes, wide sandy beach, and reliable Lake Michigan winds.\n\nThe dunes themselves are the main event: people climb them, run down them, and watch from the top as the lake stretches out to the horizon.\n\nThe water is colder than the Gulf and rougher than a lake has any right to be. It's a real beach, with real waves, close enough to the Midwest's biggest city to feel like a miracle.",
                coordinates: .init(latitude: 41.9153, longitude: -86.5934),
                keywords: ["lake michigan", "southwest michigan", "dunes", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.warrenDunes1, .warrenDunes2, .warrenDunes3],
                phoneNumber: "(269) 426-4013",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=504&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 10,
                beachName: "Petoskey State Park",
                shortDescription: "Little Traverse Bay beach known for petoskey stone hunting and sweeping northern Michigan views.",
                description: "Petoskey State Park sits along Little Traverse Bay, one of the most beautiful corners of northern Lake Michigan. The beach is known for Petoskey stone hunting, and you'll find people bent over the shoreline scanning the gravel at low tide all season long.\n\nThe bay views are sweeping, the water shifts from aquamarine to deep blue depending on the light, and the nearby town of Petoskey offers some of the best dining and lodging in northern Michigan.\n\nFall colors here are exceptional. It's the kind of place that earns repeat visits.",
                coordinates: .init(latitude: 45.4068, longitude: -84.9086),
                keywords: ["lake michigan", "northwest michigan", "petoskey stones", "rock hunting", "hiking", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.petoskey1, .petoskey2, .petoskey3],
                phoneNumber: "(231) 347-2311",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=484&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 11,
                beachName: "Pictured Rocks National Lakeshore",
                shortDescription: "42 miles of multicolored sandstone cliffs, sea caves, and remote Lake Superior beaches.",
                description: "Pictured Rocks National Lakeshore is in a category of its own. Spanning 42 miles of Lake Superior's southern shore, the park is defined by towering multicolored sandstone cliffs that rise directly from the lake, carved by waves into arches, caves, and columns streaked with mineral deposits in orange, pink, and green.\n\nRemote beaches sit tucked between the cliffs, reachable by hiking trail or kayak. The water is cold and strikingly clear.\n\nThis is not a casual beach day destination — it's a wilderness. But for those who make the trip into Michigan's Upper Peninsula, it delivers scenery that doesn't look real.",
                coordinates: .init(latitude: 46.5643, longitude: -86.3163),
                keywords: ["lake superior", "upper peninsula", "sea caves", "kayaking", "hiking", "national park"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "tree", label: "National Park"),
                ],
                images: [.picturedRocks1, .picturedRocks2, .picturedRocks3],
                phoneNumber: "(906) 387-3700",
                websiteURL: URL(string: "https://www.nps.gov/piro"),
                bodyOfWater: "Lake Superior",
                parkType: .nationalPark,
                isSwimmable: false,
                hasCamping: true
            ),
            Beach(
                id: 12,
                beachName: "Presque Isle Park",
                shortDescription: "Rocky Lake Superior peninsula with crashing waves and panoramic views at the edge of Marquette.",
                description: "Presque Isle Park is a 323-acre peninsula that juts into Lake Superior at the edge of Marquette, offering one of the most dramatic waterfront settings of any city park in the Great Lakes.\n\nRocky trails run along the shoreline as waves crash against the basalt below. The views extend across the open lake in every direction, with nothing between you and the Canadian shore but Superior's cold, dark water.\n\nIt's a park for walkers, runners, and anyone who wants to feel the scale of the largest freshwater lake in the world without driving deep into the backcountry.",
                coordinates: .init(latitude: 46.5880, longitude: -87.3818),
                keywords: ["lake superior", "upper peninsula", "marquette", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "building.columns", label: "City Park"),
                ],
                images: [.presqueIslePark1, .presqueIslePark2, .presqueIslePark3],
                phoneNumber: "(906) 228-0460",
                websiteURL: URL(string: "https://www.marquettemi.gov/departments/community-services/parks-recreation/"),
                bodyOfWater: "Lake Superior",
                parkType: .cityBeach,
                isSwimmable: false,
                hasCamping: false
            ),
            Beach(
                id: 13,
                beachName: "Harrisville State Park",
                shortDescription: "Quiet Lake Huron beach on the Sunrise Coast with a picturesque harbor nearby.",
                description: "Harrisville State Park is small by Michigan standards, but it punches above its size. Situated right on Lake Huron along the Sunrise Coast, the park offers direct beach access, a quiet harbor, and easy proximity to the charming town of Harrisville.\n\nThe beach opens up to soft sand toward the water, and the lake views stretch east with nothing to interrupt them. Sunrises here are among the best in Michigan.\n\nThe M-23 Heritage Route runs through town, making Harrisville a natural stop on a longer drive up the eastern shore.",
                coordinates: .init(latitude: 44.6475, longitude: -83.2976),
                keywords: ["lake huron", "sunrise coast", "fishing", "hiking", "harbor"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.harrisville1, .harrisville2, .harrisville3],
                phoneNumber: "(989) 724-5126",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=455&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 14,
                beachName: "Sterling State Park",
                shortDescription: "Michigan's only Lake Erie state park, with sandy beaches and excellent fishing near the Ohio border.",
                description: "Sterling State Park holds a distinction no other Michigan park can claim: it's the only state park on Lake Erie. Located in Monroe, just minutes from the Ohio border, the park offers sandy beaches, warm calm water, and some of the best freshwater fishing in the state.\n\nErie runs shallower and warmer than the other Great Lakes, which means comfortable swimming temperatures through the summer. The birdwatching is exceptional, particularly during fall migration when the park sits along a major flyway.\n\nIt's an underrated corner of Michigan's coastline that most people overlook on their way somewhere else.",
                coordinates: .init(latitude: 41.9200, longitude: -83.3415),
                keywords: ["lake erie", "southeast michigan", "fishing", "bird watching"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Erie"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.williamCSterling1, .williamCSterling2, .williamCSterling3],
                phoneNumber: "(734) 289-2715",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=497&type=SPRK"),
                bodyOfWater: "Lake Erie",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 15,
                beachName: "Muskegon State Park",
                shortDescription: "Two miles of open Lake Michigan shoreline with calmer Muskegon Lake frontage on the other side.",
                description: "Muskegon State Park occupies a narrow strip of land between Lake Michigan and Muskegon Lake, giving it two distinct waterfronts in one park. The Lake Michigan side brings open water, consistent waves, and two miles of wide sandy beach.\n\nThe Muskegon Lake side is calmer, better suited for paddling and fishing. Forested dunes run through the middle of the park, with trails connecting both shores.\n\nIn winter, the park runs one of the few luge tracks in the country. Year-round, it's one of West Michigan's most versatile outdoor destinations.",
                coordinates: .init(latitude: 43.2485, longitude: -86.3339),
                keywords: ["lake michigan", "west michigan", "hiking", "kayaking", "fishing", "dunes"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.muskegonStatePark1, .muskegonStatePark2, .muskegonStatePark3],
                phoneNumber: "(231) 744-3480",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=475&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 16,
                beachName: "Saugatuck Dunes State Park",
                shortDescription: "2.5 miles of undeveloped Lake Michigan shoreline with forested dunes and 13 miles of trails.",
                description: "Saugatuck Dunes State Park is one of the last undeveloped stretches of Lake Michigan shoreline in West Michigan. No concession stands. No boardwalks. Just 2.5 miles of pristine beach, forested dunes, and 13 miles of trails winding through mature beech and maple forest.\n\nThe beach requires a hike to reach from the parking area, which keeps the crowds light even on summer weekends. Saugatuck town is nearby for food and lodging, but the park itself operates at a different pace.\n\nIt's a destination for people who want the lake without everything that usually comes with it.",
                coordinates: .init(latitude: 42.6968, longitude: -86.1903),
                keywords: ["lake michigan", "west michigan", "dunes", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.saugatuckDunes1, .saugatuckDunes2, .saugatuckDunes3],
                phoneNumber: "(269) 637-2788",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=491&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 17,
                beachName: "South Haven South Beach",
                shortDescription: "Golden sand and calm water framed by South Haven's iconic red lighthouse.",
                description: "South Haven South Beach is one of West Michigan's most beloved summer destinations, and the red lighthouse at the mouth of the Black River is the image most people picture when they think of the town.\n\nThe beach is wide and sandy with calm enough water for comfortable swimming, and the surrounding harbor is lined with boats, restaurants, and ice cream shops. It fills up fast on summer weekends.\n\nArrive early, claim your stretch of sand near the water, and spend the afternoon moving between the beach and the harbor. South Haven knows what it is and delivers it consistently.",
                coordinates: .init(latitude: 42.4031, longitude: -86.2736),
                keywords: ["lake michigan", "west michigan", "lighthouse", "fishing", "harbor"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.southHavenSouthBeach1, .southHavenSouthBeach2, .southHavenSouthBeach3],
                phoneNumber: "(269) 637-0772",
                websiteURL: URL(string: "https://www.southhaven.org/beaches"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 18,
                beachName: "Port Crescent State Park",
                shortDescription: "Three miles of Lake Huron shoreline on Michigan's Thumb, one of the Lower Peninsula's best dark sky sites.",
                description: "Port Crescent State Park curves along three miles of sandy Lake Huron shoreline at the tip of Michigan's Thumb, offering one of the most underrated beach experiences in the state. The water on this side of the lake is warmer and calmer than Lake Michigan, and the broad flat beach is ideal for long walks at low tide.\n\nAfter dark, Port Crescent becomes one of the best stargazing locations in the Lower Peninsula. The park sits in a certified dark sky preserve, and on clear nights the Milky Way is visible to the naked eye.\n\nIt's worth staying past sunset.",
                coordinates: .init(latitude: 44.0103, longitude: -83.0508),
                keywords: ["lake huron", "thumb", "hiking", "fishing", "dark sky", "stargazing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.portCrescent1, .portCrescent2, .portCrescent3],
                phoneNumber: "(989) 738-8663",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=485&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 19,
                beachName: "Albert E. Sleeper State Park",
                shortDescription: "Wide sandy Saginaw Bay beach set among rare dune forest on Michigan's Thumb.",
                description: "Albert E. Sleeper State Park is a peaceful alternative to the busier resort towns scattered around Michigan's Thumb. Set along Saginaw Bay among rare dune forest habitat, the park offers a wide sandy beach on warm, relatively calm water and four miles of wooded trails.\n\nThe bay side of Lake Huron runs warmer than the open lake, making for comfortable swimming through the season. The surrounding dune forest draws birders and nature walkers looking for something quieter than the typical beach scene.\n\nIt's a park for families who want to slow down — and a reminder that some of Michigan's best spots don't make the top ten lists.",
                coordinates: .init(latitude: 43.9726, longitude: -83.2055),
                keywords: ["lake huron", "thumb", "hiking", "fishing", "bird watching", "dune forest"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.albertESleeper1, .albertESleeper2, .albertESleeper3],
                phoneNumber: "(989) 856-4411",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=494&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 20,
                beachName: "McLain State Park",
                shortDescription: "Remote Lake Superior beach on the Keweenaw Peninsula with dramatic Superior sunsets.",
                description: "McLain State Park sits at the northern tip of the Keweenaw Peninsula, where the land finally runs out and Lake Superior takes over. Two miles of remote sandy beach face west, making this one of the best spots in the entire Great Lakes for watching the sun go down over open water.\n\nThe Keweenaw is copper country, and the park sits within a landscape shaped by mining history, boreal forest, and Superior's cold dominance over the local climate. Summers here are short and clear.\n\nThe beach is rarely crowded. If you're making the drive up the peninsula, this is the destination at the end of it.",
                coordinates: .init(latitude: 47.2371, longitude: -88.6088),
                keywords: ["lake superior", "upper peninsula", "keweenaw", "hiking", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.mclainStatePark1, .mclainStatePark2, .mclainStatePark3],
                phoneNumber: "(906) 482-0278",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=423&type=SPRK"),
                bodyOfWater: "Lake Superior",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 21,
                beachName: "Porcupine Mountains",
                shortDescription: "Michigan's largest state park, with a rugged Lake Superior beach and ancient old-growth forest.",
                description: "The Porcupine Mountains are Michigan's largest and wildest state park, stretching along Lake Superior's shore in the remote western Upper Peninsula. Union Bay Beach sits at the eastern entrance, offering a broad gravel-and-sand shoreline with Superior crashing in from the northwest.\n\nBut the Porkies are more than a beach destination. Old-growth hemlock and maple forest covers most of the park's 60,000 acres. Waterfalls run through deep river gorges. Backcountry trails and rustic cabins extend for days in every direction.\n\nIt's one of the few places left in the Midwest where the wilderness feels genuinely uncompromised.",
                coordinates: .init(latitude: 46.7811, longitude: -89.6807),
                keywords: ["lake superior", "upper peninsula", "wilderness", "hiking", "fishing", "old growth"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.porcupineMountainsWildernessStatePark1, .porcupineMountainsWildernessStatePark2, .porcupineMountainsWildernessStatePark3],
                phoneNumber: "(906) 885-5275",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=426&type=SPRK"),
                bodyOfWater: "Lake Superior",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 22,
                beachName: "Traverse City State Park",
                shortDescription: "Sandy Lake Michigan beach at the foot of the Old Mission Peninsula in northern Michigan.",
                description: "Traverse City State Park sits on the eastern arm of Grand Traverse Bay, offering a long sandy beach with views across one of the most beautiful bays in the Great Lakes.\n\nThe water here is warmer and calmer than open Lake Michigan, making it ideal for families and swimmers. The surrounding area is packed with wineries, restaurants, and trails.\n\nIt's the rare state park that puts you within walking distance of a thriving downtown. Come for the beach, stay for everything else Traverse City has to offer.",
                coordinates: .init(latitude: 44.7354, longitude: -85.5771),
                keywords: ["lake michigan", "northwest michigan", "fishing", "hiking", "traverse city"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.traversecitystatepark1, .traversecitystatepark2, .traversecitystatepark3],
                phoneNumber: "(231) 922-5270",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=502&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 23,
                beachName: "Nordhouse Dunes",
                shortDescription: "Michigan's only federally designated wilderness area on Lake Michigan, with miles of undeveloped shoreline.",
                description: "Nordhouse Dunes is one of the most remote and pristine stretches of Lake Michigan shoreline you can reach on foot. As Michigan's only federally designated wilderness area on the lakeshore, there are no roads, no facilities, and no crowds.\n\nThe dunes rise steeply from the water, covered in pine and hardwood forest. Trails wind through the backcountry to secluded beach campsites where the only sound is the lake.\n\nThis is a destination for hikers and backpackers who want the real thing — raw, quiet, and completely undeveloped.",
                coordinates: .init(latitude: 43.9500, longitude: -86.4800),
                keywords: ["lake michigan", "west michigan", "wilderness", "hiking", "backpacking", "dunes"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "Wilderness Area"),
                ],
                images: [.nordhouse1, .nordhouse2],
                phoneNumber: "(231) 845-8218",
                websiteURL: URL(string: "https://www.fs.usda.gov/recarea/hmnf/recarea/?recid=18731"),
                bodyOfWater: "Lake Michigan",
                parkType: .wildernessArea,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 24,
                beachName: "Harbor Beach",
                shortDescription: "Quiet Lake Huron beach town with a protected harbor and clear, calm water on Michigan's Thumb.",
                description: "Harbor Beach sits on the eastern shore of Michigan's Thumb, where a massive man-made breakwater creates one of the largest protected harbors on Lake Huron. The beach inside the harbor is calm, warm, and rarely crowded.\n\nThe town itself is small and unhurried, with a classic small-town Michigan feel that's increasingly hard to find. The lighthouse at the end of the breakwater is worth the walk.\n\nFor anyone driving the Thumb's coastline, Harbor Beach is the kind of stop that turns into an afternoon.",
                coordinates: .init(latitude: 43.8439, longitude: -82.6513),
                keywords: ["lake huron", "thumb", "harbor", "lighthouse", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.harborBeach1],
                phoneNumber: "(989) 479-3363",
                websiteURL: URL(string: "https://www.harborbeach.com"),
                bodyOfWater: "Lake Huron",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 25,
                beachName: "Fort Wilkins State Park",
                shortDescription: "Historic copper country state park on Lake Superior at the tip of the Keweenaw Peninsula.",
                description: "Fort Wilkins State Park sits at the very tip of the Keweenaw Peninsula, where Lake Superior wraps around both sides of the land. The park preserves one of the last remaining wooden forts east of the Mississippi, built in 1844 during the copper rush.\n\nThe beaches here face open Lake Superior, with cold clear water and the kind of remoteness that comes from being at the end of a very long road. Copper Harbor itself is a small, beloved destination for mountain bikers and UP explorers.\n\nCome for the history, stay for the lake.",
                coordinates: .init(latitude: 47.4658, longitude: -87.8823),
                keywords: ["lake superior", "upper peninsula", "keweenaw", "history", "hiking", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.lakewilkins1, .lakewilkins2, .lakewilkins3],
                phoneNumber: "(906) 289-4215",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=417&type=SPRK"),
                bodyOfWater: "Lake Superior",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 26,
                beachName: "Grand Marais Beach",
                shortDescription: "Remote Lake Superior village beach with dramatic shoreline and access to Pictured Rocks.",
                description: "Grand Marais is a small village on the Lake Superior shore that serves as the eastern gateway to Pictured Rocks National Lakeshore. The beach here is wide and wild, with Superior's characteristic cold clear water and dramatic skies.\n\nThe town has a handful of restaurants and a beloved local brewery, but mostly it's a jumping-off point for backcountry adventure. The Pictured Rocks shoreline trail starts nearby.\n\nFor those who make the drive out to this corner of the UP, Grand Marais rewards you with quiet, beauty, and a sense of being genuinely far from everything.",
                coordinates: .init(latitude: 46.6741, longitude: -85.9766),
                keywords: ["lake superior", "upper peninsula", "hiking", "national park", "pictured rocks"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "tree", label: "National Park"),
                ],
                images: [.grandmarais1, .grandmarias2],
                phoneNumber: "(906) 387-3700",
                websiteURL: URL(string: "https://www.nps.gov/piro"),
                bodyOfWater: "Lake Superior",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 27,
                beachName: "Oval Beach",
                shortDescription: "One of the Midwest's most celebrated beaches, tucked into the dunes above Saugatuck.",
                description: "Oval Beach has been called one of the best freshwater beaches in the country, and it earns the reputation. Tucked into the dunes above Saugatuck, the beach is wide, sandy, and surrounded by towering dune bluffs that block the wind and frame the view.\n\nThe water is clear and the waves are consistent. Getting there requires a short walk from the parking area, which helps keep the crowds manageable even on peak summer weekends.\n\nSaugatuck's restaurants and galleries are minutes away, making this the rare beach that pairs well with a full day in town.",
                coordinates: .init(latitude: 42.6543, longitude: -86.2196),
                keywords: ["lake michigan", "west michigan", "dunes", "saugatuck"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.ovalbeach1, .ovalBeach2],
                phoneNumber: "(269) 857-2603",
                websiteURL: URL(string: "https://www.saugatuck.com/oval-beach"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 28,
                beachName: "Tunnel Park",
                shortDescription: "Holland's beloved dune beach, famous for the tunnel cut through the dune to reach the water.",
                description: "Tunnel Park gets its name from the literal tunnel cut through a massive sand dune to reach the Lake Michigan shoreline on the other side. It's one of those small touches that makes a beach memorable before you've even seen the water.\n\nThe beach itself is wide and sandy with good waves, and the dune behind it is a favorite for kids who want to climb and roll. It's less crowded than Holland State Park while offering a comparable Lake Michigan experience.\n\nA local favorite for Ottawa County residents and a worthwhile detour for anyone in the Holland area.",
                coordinates: .init(latitude: 42.7654, longitude: -86.2198),
                keywords: ["lake michigan", "west michigan", "dunes", "holland"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "County Park"),
                ],
                images: [.tunnelPark1],
                phoneNumber: "(616) 738-4810",
                websiteURL: URL(string: "https://www.miottawa.org/Parks/tunnel.htm"),
                bodyOfWater: "Lake Michigan",
                parkType: .countyPark,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 29,
                beachName: "Pere Marquette Beach",
                shortDescription: "Muskegon's main city beach with a long sandy shoreline and easy access to Lake Michigan.",
                description: "Pere Marquette Beach is Muskegon's front door to Lake Michigan — a long, wide stretch of sand that draws locals and visitors alike for swimming, volleyball, and summer evenings by the water.\n\nThe beach sits at the mouth of Muskegon Lake where it meets Lake Michigan, giving it a channel view to the north and open water to the west. The sunsets are reliably excellent.\n\nWith a concession stand, restrooms, and easy parking, it's the kind of beach that works for everyone from toddlers to retirees.",
                coordinates: .init(latitude: 43.2317, longitude: -86.3539),
                keywords: ["lake michigan", "west michigan", "muskegon"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.perebeach1, .pereBeach2],
                phoneNumber: "(231) 724-6704",
                websiteURL: URL(string: "https://www.muskegon-mi.gov"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 30,
                beachName: "North Beach Park",
                shortDescription: "Wide sandy beach just north of Grand Haven's channel, quieter than the state park.",
                description: "North Beach Park sits just north of the Grand Haven channel, offering a quieter alternative to the busy state park a short walk away. The beach is wide and sandy with the same great Lake Michigan water and sunset views.\n\nBecause it attracts more locals than tourists, the vibe is relaxed and the parking is easier. Dogs are allowed in certain areas, making it popular with pet owners.\n\nIf Grand Haven State Park is packed on a summer weekend, North Beach is where the locals go instead.",
                coordinates: .init(latitude: 43.0731, longitude: -86.2567),
                keywords: ["lake michigan", "west michigan", "grand haven"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "County Park"),
                ],
                images: [.grandHaven1, .grandHaven2, .grandHaven3],
                phoneNumber: "(616) 842-3210",
                websiteURL: URL(string: "https://www.miottawa.org/Parks/northbeach.htm"),
                bodyOfWater: "Lake Michigan",
                parkType: .countyPark,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 31,
                beachName: "Kirk Park",
                shortDescription: "Hidden gem Ottawa County beach tucked in the dunes between Holland and Grand Haven.",
                description: "Kirk Park is one of West Michigan's best kept secrets — a small Ottawa County park tucked between the dunes midway between Holland and Grand Haven. The beach is accessed via a short boardwalk through the dunes and offers a full Lake Michigan experience without the crowds of the more famous parks nearby.\n\nThe dune bluffs behind the beach are dramatic, and the swimming is excellent. There's a picnic area and restrooms, but not much else — which is exactly the point.\n\nFor anyone who knows about it, Kirk Park is a first choice over the busier alternatives.",
                coordinates: .init(latitude: 42.9920, longitude: -86.2534),
                keywords: ["lake michigan", "west michigan", "dunes"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "County Park"),
                ],
                images: [.kirkPark1],
                phoneNumber: "(616) 738-4810",
                websiteURL: URL(string: "https://www.miottawa.org/Parks/kirk.htm"),
                bodyOfWater: "Lake Michigan",
                parkType: .countyPark,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 32,
                beachName: "Caseville County Park",
                shortDescription: "Popular Saginaw Bay beach on Michigan's Thumb known for warm water and the annual Cheeseburger Festival.",
                description: "Caseville County Park is the social hub of Michigan's Thumb in summer, anchored by warm Saginaw Bay water and one of the region's most beloved annual events — the Cheeseburger in Caseville Festival that takes over the town every August.\n\nThe beach is sandy and the bay water runs significantly warmer than the open Great Lakes, making it a favorite for families with young children. The town is small but lively in summer.\n\nIt's a beach with personality — part relaxed vacation town, part annual party.",
                coordinates: .init(latitude: 43.9414, longitude: -83.2716),
                keywords: ["lake huron", "thumb", "saginaw bay", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "building.columns", label: "County Park"),
                ],
                images: [.albertESleeper1, .albertESleeper2, .albertESleeper3],
                phoneNumber: "(989) 856-4411",
                websiteURL: URL(string: "https://www.huroncounty.us/parks"),
                bodyOfWater: "Lake Huron",
                parkType: .countyPark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 33,
                beachName: "Lexington Beach",
                shortDescription: "Charming small-town Lake Huron beach on the Thumb with a marina and great sunrises.",
                description: "Lexington is one of those small Lake Huron towns that does everything right. The beach sits at the edge of a well-kept harbor village with good restaurants, a marina full of sailboats, and a relaxed pace that feels genuinely unhurried.\n\nThe beach itself is sandy and calm, typical of the protected Thumb coastline. Sunrises here are excellent — the eastern exposure gives you the full show over the open lake.\n\nFor a weekend getaway that doesn't involve fighting for parking or a spot in the sand, Lexington is hard to beat.",
                coordinates: .init(latitude: 43.2654, longitude: -82.5321),
                keywords: ["lake huron", "thumb", "harbor", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.lexingtonBeach1],
                phoneNumber: "(810) 359-8819",
                websiteURL: URL(string: "https://www.lexingtonmichigan.org"),
                bodyOfWater: "Lake Huron",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 34,
                beachName: "Oscoda Beach",
                shortDescription: "Lake Huron beach at the mouth of the Au Sable River, gateway to the Sunrise Coast.",
                description: "Oscoda Beach sits where the Au Sable River — one of Michigan's great trout streams — empties into Lake Huron. The beach is wide and sandy, the water is calm, and the surrounding area offers some of the best paddling and fishing in the Lower Peninsula.\n\nThe town has a laid-back Sunrise Coast feel, with good access to the River Road Scenic Byway that follows the Au Sable through the forest.\n\nIt's a beach for people who want more than just the water — the river, the forest, and the quiet of the eastern shore are all part of the appeal.",
                coordinates: .init(latitude: 44.4317, longitude: -83.3354),
                keywords: ["lake huron", "sunrise coast", "fishing", "kayaking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.tawasStatePark1, .tawasStatePark2, .tawasStatePark3],
                phoneNumber: "(989) 739-7322",
                websiteURL: URL(string: "https://www.oscoda.com"),
                bodyOfWater: "Lake Huron",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 35,
                beachName: "Agate Beach",
                shortDescription: "Remote Lake Superior beach at Copper Harbor known for rock hunting and dramatic Superior scenery.",
                description: "Agate Beach sits at the very tip of the Keweenaw Peninsula near Copper Harbor, where Lake Superior stretches out in every direction and the water is some of the clearest in the Great Lakes. The beach is known for agate hunting — the wave-polished stones here are prized by rock collectors across the Midwest.\n\nThe setting is remote and dramatic, with boreal forest running down to the water and the open lake extending to the horizon. It's not a swimming beach — Superior is cold and the waves can be significant — but as a place to walk, search for stones, and take in the scale of the lake, it's exceptional.\n\nGetting here requires commitment, which is exactly why it's worth it.",
                coordinates: .init(latitude: 47.4679, longitude: -87.8821),
                keywords: ["lake superior", "upper peninsula", "keweenaw", "rock hunting", "agates", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.agate1,.agate2],
                phoneNumber: "(906) 289-4212",
                websiteURL: URL(string: "https://www.keweenaw.info"),
                bodyOfWater: "Lake Superior",
                parkType: .cityBeach,
                isSwimmable: false,
                hasCamping: false
            ),
            Beach(
                id: 36,
                beachName: "Ontonagon Beach",
                shortDescription: "Small Lake Superior beach in a historic copper country town with views of the Porcupine Mountains.",
                description: "Ontonagon sits on Lake Superior's south shore with views across the water toward the Porcupine Mountains rising in the distance. The town has deep copper mining roots and a small, unpretentious beach that draws mostly locals and UP road trippers.\n\nThe water is cold and clear, as Superior always is, and the setting is genuinely scenic — the Porkies visible from the shoreline on clear days make for one of the more dramatic backdrops of any Michigan beach.\n\nIt's not a destination beach, but it's a worthwhile stop on a western UP loop.",
                coordinates: .init(latitude: 46.8731, longitude: -89.3217),
                keywords: ["lake superior", "upper peninsula", "history"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.ontonagon1],
                phoneNumber: "(906) 884-4735",
                websiteURL: URL(string: "https://www.ontonagon.mi.us"),
                bodyOfWater: "Lake Superior",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 37,
                beachName: "Whitefish Point Beach",
                shortDescription: "Remote Lake Superior beach at Michigan's northernmost point, famous for shipwrecks and bird migration.",
                description: "Whitefish Point is one of the most historically significant spots on the Great Lakes. The oldest active lighthouse on Lake Superior stands here, and the waters just offshore are a graveyard for ships that didn't make the turn, including the Edmund Fitzgerald.\n\nThe beach itself is remote and wild, with Superior's characteristic cold clear water and a gravel shoreline that stretches in both directions. The point is also one of the premier raptor migration watch sites in North America.\n\nIt's a place that rewards people who understand what they're looking at — history, nature, and raw Superior scenery all in one.",
                coordinates: .init(latitude: 46.7698, longitude: -84.9574),
                keywords: ["lake superior", "upper peninsula", "lighthouse", "history", "bird watching", "shipwrecks"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "building.columns", label: "Preserve"),
                ],
                images: [.whitefish1],
                phoneNumber: "(906) 492-3251",
                websiteURL: URL(string: "https://www.shipwreckmuseum.com"),
                bodyOfWater: "Lake Superior",
                parkType: .wildernessArea,
                isSwimmable: false,
                hasCamping: false
            ),
            Beach(
                id: 38,
                beachName: "Munising Beach",
                shortDescription: "Sheltered Lake Superior beach in the heart of Pictured Rocks country with warm bay water.",
                description: "Munising Beach sits in a protected bay on Lake Superior, sheltered enough that the water runs warmer than most Superior beaches and the conditions are calmer for swimming. It's the most accessible beach in the Pictured Rocks area, right in town with easy parking.\n\nThe bay views include Anna River flowing in from the south and forested hills rising behind the town. Kayak tours of Pictured Rocks launch from nearby.\n\nFor anyone using Munising as a base for exploring the national lakeshore, the town beach is a perfect end-of-day stop.",
                coordinates: .init(latitude: 46.4121, longitude: -86.6554),
                keywords: ["lake superior", "upper peninsula", "kayaking", "pictured rocks"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Superior"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.munisingBeach1],
                phoneNumber: "(906) 387-2138",
                websiteURL: URL(string: "https://www.munising.org"),
                bodyOfWater: "Lake Superior",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 39,
                beachName: "Bay City State Park",
                shortDescription: "Saginaw Bay beach and wetland preserve with excellent birding and calm warm water.",
                description: "Bay City State Park sits on the western shore of Saginaw Bay, where the water runs warmer and calmer than the open Great Lakes. The park combines a sandy beach with one of the most significant wetland preserves in the Great Lakes basin.\n\nThe Frank N. Andersen Nature Center anchors the park's environmental education programming, and the birding here is exceptional year-round. The beach itself is family-friendly with good swimming conditions through the summer.\n\nIt's a park that rewards both the beach crowd and the nature crowd, often at the same time.",
                coordinates: .init(latitude: 43.6548, longitude: -83.8967),
                keywords: ["lake huron", "saginaw bay", "bird watching", "nature", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.baycity1],
                phoneNumber: "(989) 684-3020",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=436&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 40,
                beachName: "Lakeport State Park",
                shortDescription: "Southern Lake Huron state park near Port Huron with sandy beaches and warm water.",
                description: "Lakeport State Park occupies a stretch of southern Lake Huron shoreline near Port Huron, where the lake narrows toward the St. Clair River. The water here is among the warmest on Lake Huron, and the sandy beach is well-maintained and family-friendly.\n\nThe park sits close enough to Metro Detroit and Flint to draw significant summer crowds, but it's large enough that you can usually find space. The proximity to Port Huron adds dining and marina options nearby.\n\nFor southeast Michigan residents looking for a true Great Lakes beach within a reasonable drive, Lakeport is one of the best options.",
                coordinates: .init(latitude: 43.1432, longitude: -82.4987),
                keywords: ["lake huron", "lower peninsula", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.lakeport1, .lakeport2, .lakeport3],
                phoneNumber: "(810) 327-6224",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=463&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 41,
                beachName: "Cheboygan State Park",
                shortDescription: "Northern Lake Huron beach near the Straits with access to Duncan Bay and lighthouse ruins.",
                description: "Cheboygan State Park sits on the northern tip of the Lower Peninsula where Lake Huron meets the Straits of Mackinac. The park offers beach access on Duncan Bay, a sheltered inlet with calm water and sandy shoreline.\n\nThe ruins of the old Cheboygan Crib Light sit just offshore, visible from the beach and reachable by kayak. The park also offers trails through northern hardwood forest and good fishing in the bay.\n\nWith Mackinac Bridge visible on clear days and the Straits just to the north, the setting feels like the edge of something significant — because it is.",
                coordinates: .init(latitude: 45.6543, longitude: -84.4732),
                keywords: ["lake huron", "straits", "northern michigan", "kayaking", "fishing", "lighthouse", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.cheboygan1, .cheboygan2, .cheboygan3],
                phoneNumber: "(231) 627-2811",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=440&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 42,
                beachName: "Hoeft State Park",
                shortDescription: "Quiet northern Lake Huron state park near Rogers City with a mile of undeveloped shoreline.",
                description: "Hoeft State Park is one of northern Michigan's quieter state parks, offering a mile of undeveloped Lake Huron shoreline near Rogers City without the crowds that follow more famous destinations.\n\nThe beach is pebbly in places but opens to sand toward the water, and the lake views stretch east without interruption. Rogers City is known as the Nautical City, and the area has a strong Great Lakes maritime character.\n\nFor anyone making the drive up the Sunrise Coast, Hoeft is a worthy stop — peaceful, scenic, and unhurried.",
                coordinates: .init(latitude: 45.4321, longitude: -83.9876),
                keywords: ["lake huron", "sunrise coast", "northern michigan", "hiking", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Huron"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.hoeft1, .hoeft2, .hoeft3],
                phoneNumber: "(989) 734-2543",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=456&type=SPRK"),
                bodyOfWater: "Lake Huron",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 43,
                beachName: "Fisherman's Island State Park",
                shortDescription: "Remote northern Lake Michigan park near Charlevoix with five miles of undeveloped shoreline.",
                description: "Fisherman's Island State Park protects five miles of undeveloped Lake Michigan shoreline south of Charlevoix, making it one of the longest undeveloped stretches on the northern Lower Peninsula. The beach is a mix of sand and Petoskey stones, and the hunting is excellent.\n\nThe park is lightly used compared to its neighbors, with trails through northern forest and secluded beach campsites reachable only on foot. The water is cold and clear in the northern Michigan way.\n\nFor stone hunters, backpackers, and anyone who wants northern Lake Michigan without a crowd, this is the destination.",
                coordinates: .init(latitude: 45.2876, longitude: -85.2543),
                keywords: ["lake michigan", "northern michigan", "petoskey stones", "rock hunting", "hiking"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.fisherman1, .fisherman2, .fisherman3],
                phoneNumber: "(231) 547-6641",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=447&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 44,
                beachName: "Young State Park",
                shortDescription: "Charlevoix-area state park on Lake Charlevoix with calm inland lake swimming and northern Michigan charm.",
                description: "Young State Park sits on the shores of Lake Charlevoix, one of Michigan's most beautiful inland lakes, just outside the resort town of Charlevoix. The beach offers calm, warm freshwater swimming in a stunning northern Michigan setting.\n\nLake Charlevoix connects to Lake Michigan through the Pine River Channel, giving the area a distinctive nautical character. Boyne City and Charlevoix are both nearby for dining and shopping.\n\nIt's a great base camp for exploring northern Michigan — the beach is excellent, the lake is beautiful, and the surrounding area is one of the best in the state.",
                coordinates: .init(latitude: 45.1987, longitude: -85.2198),
                keywords: ["lake charlevoix", "northern michigan", "fishing", "charlevoix"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Charlevoix"),
                    DisplayKeyword(icon: "tree", label: "State Park"),
                ],
                images: [.young1, .young2, .young3],
                phoneNumber: "(231) 547-6641",
                websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=509&type=SPRK"),
                bodyOfWater: "Lake Michigan",
                parkType: .statePark,
                isSwimmable: true,
                hasCamping: true
            ),
            Beach(
                id: 45,
                beachName: "Empire Beach",
                shortDescription: "Small village beach at the edge of Sleeping Bear Dunes National Lakeshore with stunning lake views.",
                description: "Empire Beach sits in the tiny village of Empire, right at the southern edge of Sleeping Bear Dunes National Lakeshore. The beach is small but the views are enormous — the dune ridges of Sleeping Bear rise to the north and the open lake stretches west to the horizon.\n\nThe village itself is one of those rare small Michigan towns that has maintained its character without becoming a tourist trap. A few good restaurants, a beloved local brewery, and the national lakeshore visitor center are all within walking distance.\n\nFor a low-key Sleeping Bear experience without the crowds of the main dune area, Empire is the answer.",
                coordinates: .init(latitude: 44.8123, longitude: -86.0587),
                keywords: ["lake michigan", "northwest michigan", "sleeping bear", "national park", "dunes"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "tree", label: "National Park"),
                ],
                images: [.empireBeach1],
                phoneNumber: "(231) 326-4700",
                websiteURL: URL(string: "https://www.nps.gov/slbe"),
                bodyOfWater: "Lake Michigan",
                parkType: .nationalPark,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 46,
                beachName: "Leland Beach",
                shortDescription: "Northern Lake Michigan beach in the charming fishing village of Leland, home of Fishtown.",
                description: "Leland is one of northern Michigan's most beloved villages, anchored by Fishtown — a collection of historic fishing shanties on the Leland River that have been converted into shops and smokehouses. The beach sits just south of the river mouth, with clear Lake Michigan water and views of North and South Manitou Islands.\n\nThe beach is sandy and the swimming is good, but the real draw is the combination of beach and village. Leland delivers a complete northern Michigan experience: water, history, good food, and genuine character.\n\nFerry service to the Manitou Islands departs from Leland for those who want to extend the adventure.",
                coordinates: .init(latitude: 45.0234, longitude: -85.7654),
                keywords: ["lake michigan", "northwest michigan", "leelanau", "fishing", "historic"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.lelandBeach1],
                phoneNumber: "(231) 256-9182",
                websiteURL: URL(string: "https://www.lelandmi.com"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 47,
                beachName: "Frankfort Beach",
                shortDescription: "Benzie County beach town with a lighthouse, natural harbor, and consistently beautiful Lake Michigan sunsets.",
                description: "Frankfort sits at the mouth of the Betsie River where it empties into Lake Michigan, creating a natural harbor flanked by a pair of lighthouses. The beach stretches north from the channel with wide sand and good waves.\n\nThe town is small and well-kept, with a main street that rewards a slow walk. Crystal Lake is a short drive inland and worth adding to any visit.\n\nFrankfort is the kind of Michigan beach town that people discover once and return to every summer. The sunsets from the breakwater are among the best on the western shore.",
                coordinates: .init(latitude: 44.6321, longitude: -86.2354),
                keywords: ["lake michigan", "northwest michigan", "lighthouse", "harbor", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.frankfort1],
                phoneNumber: "(231) 352-7707",
                websiteURL: URL(string: "https://www.frankfort-elberta.com"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 48,
                beachName: "Arcadia Beach",
                shortDescription: "Small Manistee County beach with dramatic bluff views and uncrowded Lake Michigan shoreline.",
                description: "Arcadia is a tiny Manistee County village with a beach that punches well above its size. The shoreline sits below dramatic bluffs that rise steeply from the water, giving the area a rugged, almost coastal feel unusual for the Great Lakes.\n\nThe beach is uncrowded and the swimming is good. Arcadia Dunes — a Nature Conservancy preserve — protects the surrounding landscape and offers excellent hiking with panoramic lake views from the bluff tops.\n\nFor anyone driving the Lake Michigan shoreline between Manistee and Frankfort, Arcadia is the stop that makes the drive worthwhile.",
                coordinates: .init(latitude: 44.5123, longitude: -86.2198),
                keywords: ["lake michigan", "northwest michigan", "bluffs", "hiking", "nature"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.ludington1, .ludington2, .ludington3],
                phoneNumber: "(231) 723-2575",
                websiteURL: URL(string: "https://www.manisteecounty.net"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 49,
                beachName: "Manistee North Beach",
                shortDescription: "Long sandy Lake Michigan beach north of Manistee's channel with a lighthouse and consistent waves.",
                description: "Manistee North Beach stretches for nearly two miles along Lake Michigan north of the Manistee River channel, offering one of the longest continuous sandy beaches in West Michigan outside of the state parks.\n\nThe beach is wide, the waves are consistent, and the lighthouse at the channel entrance makes for a classic West Michigan backdrop. The city of Manistee has invested in the waterfront, with good facilities and easy parking.\n\nFor a full beach day on Lake Michigan without the state park entrance fee and associated crowds, Manistee North Beach is one of the best options on the western shore.",
                coordinates: .init(latitude: 44.2543, longitude: -86.3321),
                keywords: ["lake michigan", "west michigan", "lighthouse", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.manistee1],
                phoneNumber: "(231) 723-2575",
                websiteURL: URL(string: "https://www.manisteemi.gov"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 50,
                beachName: "Pentwater Beach",
                shortDescription: "Charming Oceana County beach town with a protected channel and consistent Lake Michigan surf.",
                description: "Pentwater is one of the gems of the West Michigan shoreline — a small harbor town with a well-protected channel, a walkable main street, and a Lake Michigan beach that draws a devoted following of repeat visitors.\n\nThe beach sits at the mouth of Pentwater Lake where it meets the big lake, with the channel creating calm water on one side and open surf on the other. The dunes north of town protect the beach from wind and give it a sheltered feel.\n\nIt's the kind of town where people rent the same cottage every summer for twenty years. Once you understand that, you understand Pentwater.",
                coordinates: .init(latitude: 43.7832, longitude: -86.4321),
                keywords: ["lake michigan", "west michigan", "harbor", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.pentwater1, .pentwater2, .pentwater3],
                phoneNumber: "(231) 869-8601",
                websiteURL: URL(string: "https://www.pentwater.org"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 51,
                beachName: "White Lake Beach",
                shortDescription: "Muskegon County beach town where White Lake meets Lake Michigan, popular with boaters and beach-goers.",
                description: "White Lake is a large inland lake that connects to Lake Michigan through a channel near the towns of Whitehall and Montague. The beach at the channel is a mix of protected lake water and open Lake Michigan, giving visitors options depending on conditions.\n\nThe area is a boating hub in summer, with marinas, waterfront restaurants, and a lively seasonal scene. The Walkway of Stars along the White River celebrates the area's connection to the music industry.\n\nIt's a beach town with more going on than most — good for families who want both the lake and a full summer experience.",
                coordinates: .init(latitude: 43.5987, longitude: -86.3987),
                keywords: ["lake michigan", "west michigan", "harbor", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.muskegonStatePark1, .muskegonStatePark2, .muskegonStatePark3],
                phoneNumber: "(231) 893-4585",
                websiteURL: URL(string: "https://www.whitelaketourism.com"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 52,
                beachName: "New Buffalo Beach",
                shortDescription: "Southwest Michigan's southernmost beach town, popular with Chicago day-trippers and weekenders.",
                description: "New Buffalo sits at the very southwestern corner of Michigan, close enough to Chicago that it functions as the city's freshwater beach resort. The beach is wide and sandy with consistent Lake Michigan waves, and the town has evolved into a destination with good restaurants, boutique shops, and a busy marina.\n\nIt fills up fast on summer weekends — the drive from Chicago is under two hours — but the beach is large enough to absorb the crowds. Outside of peak summer, New Buffalo is quiet and genuinely pleasant.\n\nFor Chicagoans who want Lake Michigan without crossing a state line, New Buffalo is the answer. For everyone else, it's a solid beach town that earns its reputation.",
                coordinates: .init(latitude: 41.7965, longitude: -86.7432),
                keywords: ["lake michigan", "southwest michigan", "harbor", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.warrenDunes1, .warrenDunes2, .warrenDunes3],
                phoneNumber: "(269) 469-1500",
                websiteURL: URL(string: "https://www.newbuffalomi.gov"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 53,
                beachName: "St. Joseph Beach",
                shortDescription: "Southwest Michigan beach city with twin lighthouses, good waves, and a walkable downtown.",
                description: "St. Joseph is one of the best beach cities in Michigan — a real town with a real downtown that happens to sit on a bluff above one of the most photographed lighthouse setups on the Great Lakes. The twin lighthouses at the end of the North Pier are iconic, and the view from the bluff over the lake is hard to match.\n\nThe beach below the bluff is wide and sandy with reliable Lake Michigan surf. The downtown above is walkable and full of good restaurants, galleries, and the kind of independent shops that make a place feel lived-in.\n\nSt. Joseph does the beach town thing right — it's a destination, not just a waypoint.",
                coordinates: .init(latitude: 42.1098, longitude: -86.4876),
                keywords: ["lake michigan", "southwest michigan", "lighthouse", "fishing"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Michigan"),
                    DisplayKeyword(icon: "building.columns", label: "City Beach"),
                ],
                images: [.warrenDunes1, .warrenDunes2, .warrenDunes3],
                phoneNumber: "(269) 983-1111",
                websiteURL: URL(string: "https://www.stjoetoday.com"),
                bodyOfWater: "Lake Michigan",
                parkType: .cityBeach,
                isSwimmable: true,
                hasCamping: false
            ),
            Beach(
                id: 54,
                beachName: "Lake Erie Metropark Beach",
                shortDescription: "Wayne County's largest park on Lake Erie, with a marina, beach, and exceptional birding.",
                description: "Lake Erie Metropark is the largest park in the Huron-Clinton Metroparks system, stretching along the western Lake Erie shoreline in southern Wayne County. The beach offers warm Erie water and a full suite of park amenities — marina, wave pool, nature center, and miles of trails.\n\nThe park sits along one of North America's most significant bird migration corridors, and the hawk watches here during fall migration draw serious birders from across the region. The Erie shoreline in this area is warmer and calmer than the Upper Great Lakes.\n\nFor Metro Detroit residents, it's the closest thing to a Great Lakes beach experience that doesn't require leaving the county.",
                coordinates: .init(latitude: 42.0876, longitude: -83.1987),
                keywords: ["lake erie", "southeast michigan", "bird watching", "fishing", "marina"],
                displayKeywords: [
                    DisplayKeyword(icon: "water.waves", label: "Lake Erie"),
                    DisplayKeyword(icon: "building.columns", label: "Metro Park"),
                ],
                images: [.williamCSterling1, .williamCSterling2, .williamCSterling3],
                phoneNumber: "(734) 379-5020",
                websiteURL: URL(string: "https://www.metroparks.com/lake-erie-metropark"),
                bodyOfWater: "Lake Erie",
                parkType: .metropark,
                isSwimmable: true,
                hasCamping: false
            ),
        ]
}
