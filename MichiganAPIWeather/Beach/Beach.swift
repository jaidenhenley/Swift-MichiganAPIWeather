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
    let displayKeywords: [String]
    let images: [ImageResource]
    let phoneNumber: String
    let websiteURL: URL?
    
    static let allBeaches: [Beach] = [
        Beach(
            id: 1,
            beachName: "Belle Isle Beach",
            shortDescription: "Urban waterfront beach on the Detroit River with views of the city skyline.",
            description: "Belle Isle Beach offers something no other Michigan beach can: a waterfront experience inside one of the country's great urban island parks. Set on the Detroit River, the beach looks out toward the Canadian shoreline and the Windsor skyline while the towers of downtown Detroit rise behind you. It's a neighborhood beach, a city escape, and a historic landmark all at once. Belle Isle itself has a conservatory, an aquarium, and miles of trails. The beach draws Detroit residents who want the water close without leaving the city behind.",
            coordinates: .init(latitude: 42.3416, longitude: -82.9625),
            keywords: ["detroit river", "southeast michigan", "urban", "skyline", "swimming", "family", "park", "scenic","restroom"],
            displayKeywords: ["Detroit River", "State Park", "Urban", "Boat Launch"],
            images: [.belleIsle1, .belleIsle2, .belleIsle3],
            phoneNumber: "(313) 821-9844",
            websiteURL: URL(string: "https://www.belleislepark.org/")
        ),
        Beach(
            id: 2,
            beachName: "Grand Haven State Park",
            shortDescription: "Iconic lighthouse, long sandy beach, and legendary sunsets at the mouth of the Grand River.",
            description: "Sitting at the mouth of the Grand River, Grand Haven State Park is West Michigan's classic beach destination. The long, sandy shoreline stretches south from the channel, flanked by the iconic red lighthouse that has become one of the most photographed spots on all of Lake Michigan. Sunsets here are legendary. The boardwalk connects to downtown Grand Haven, giving visitors easy access to restaurants, shops, and the famous Musical Fountain. Bring a beach chair, stake your spot early on a summer weekend, and plan to stay until the sky goes orange.",
            coordinates: .init(latitude: 43.0564, longitude: -86.2545),
            keywords: ["lake michigan", "west michigan", "lighthouse", "swimming", "fishing",
                       "family", "playground", "picnic", "beach house", "metal detecting",
                       "water access", "track chair", "scenic", "state park"],
            displayKeywords: ["Lake Michigan","State Park", "Lighthouse", "Fishing"],
            images: [.grandHaven1, .grandHaven2, .grandHaven3],
            phoneNumber: "(616) 847-1309",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=449&type=SPRK")
        ),
        Beach(
            id: 3,
            beachName: "Silver Lake Beach",
            shortDescription: "West Michigan dune beach popular for off-road riding and wide-open Lake Michigan views.",
            description: "Silver Lake Beach sits at the edge of a landscape unlike anything else in Michigan. The Silver Lake Sand Dunes roll up behind the beach in massive, vehicle-carved ridges, making this a destination for both thrill-seekers and laid-back swimmers. The beach itself faces a calm inland lake, while Lake Michigan lies just over the dunes to the west. It's a rare setup: two bodies of water within walking distance of each other. Dune rides, beach bonfires, and summer cabins have made this a West Michigan tradition for generations.",
            coordinates: .init(latitude: 43.6753, longitude: -86.5214),
            keywords: ["lake michigan", "west michigan", "dunes", "orv", "off road", "swimming", "adventure", "family", "scenic", "restroom"],
            displayKeywords: ["Lake Michigan", "State Park", "Dunes", "ORV"],
            images: [.silverLake1, .silverLake2, .silverLake3],
            phoneNumber: "(231) 873-3083",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=493&type=SPRK")
        ),
        Beach(
            id: 4,
            beachName: "Sleeping Bear Dunes",
            shortDescription: "35 miles of towering dunes and crystal-clear Lake Michigan shoreline in northwest Michigan.",
            description: "Stretching across 35 miles of Lake Michigan shoreline, Sleeping Bear Dunes National Lakeshore is one of the most breathtaking stretches of freshwater coastline in the country. Towering sand dunes rise hundreds of feet above the lake, offering panoramic views that stop people in their tracks. The water is glacier-fed, cold, and impossibly clear. Whether you're hiking the Dune Climb, paddling the Platte River, or watching the sun sink behind South Manitou Island, this place earns its reputation as one of the most beautiful places in America.",
            coordinates: .init(latitude: 44.8779, longitude: -86.0590),
            keywords: ["lake michigan", "northwest michigan", "lighthouse", "hiking", "biking",
                       "hunting", "cross country skiing", "snowshoeing", "history programs",
                       "family", "playground", "picnic", "pet friendly", "water access",
                       "concessions", "ev charging", "scenic", "national park", "adventure"],
            displayKeywords: ["Lake Michigan", "National Park", "Dunes", "Hiking"],
            images: [.sleepingBear1, .sleepingBear2, .sleepingBear3],
            phoneNumber: "(231) 326-4700",
            websiteURL: URL(string: "https://www.nps.gov/slbe")
        )
        ,
        Beach(
            id: 5,
            beachName: "Tawas Point State Park",
            shortDescription: "Calm, shallow Lake Huron waters and a historic lighthouse on a curved sandy spit.",
            description: "Often called the Sleeping Bear of Lake Huron, Tawas Point State Park juts into the lake on a curved sandy spit that collects warm, shallow water on its protected inner shore. The result is some of the most swimmer-friendly conditions in the state. Families with young kids love it here. A historic lighthouse stands at the tip of the point, and the surrounding area is a known birding hotspot during spring and fall migrations. The pace is quiet, the water is calm, and the sunrises over the open lake are worth setting an alarm for.",
            coordinates: .init(latitude: 44.2572, longitude: -83.4467),
            keywords: ["lake huron", "sunrise coast", "lower peninsula", "lighthouse",
                       "swimming", "fishing", "hiking", "biking", "paddling", "kayaking",
                       "bird watching", "camping", "family", "playground", "picnic",
                       "nature programs", "history", "cross country skiing", "snowshoeing",
                       "metal detecting", "pet friendly", "concessions", "beach house"],
            displayKeywords: ["Lake Huron", "State Park", "Camping", "Hiking"],
            images: [.saugatuckDunes1, .saugatuckDunes2,.saugatuckDunes3],
            phoneNumber: "(989) 362-5041",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=499&type=SPRK")
        ),
        Beach(
            id: 6,
            beachName: "Holland State Park",
            shortDescription: "One of Michigan's most photographed lighthouses anchors this wide Lake Michigan beach.",
            description: "Holland State Park sits where Lake Macatawa meets Lake Michigan, anchored by the bright red Big Red lighthouse that has graced more Michigan postcards than nearly any other landmark. The beach is wide and well-maintained, with soft sand, consistent waves, and easy parking access that draws visitors from across the Midwest. The channel offers a breakwater walk with views in both directions. Downtown Holland is minutes away. It's one of those parks that works for everyone: families, couples, day trippers, and anyone who just wants to stand at the edge of something huge and blue.",
            coordinates: .init(latitude: 42.7789, longitude: -86.2048),
            keywords: ["lake michigan", "west michigan", "lighthouse", "swimming", "fishing", "camping", "family", "scenic", "harbor"],
            displayKeywords: ["Lake Michigan", "State Park", "Lighthouse", "Camping"],
            images: [.saugatuckDunes1, .saugatuckDunes2,.saugatuckDunes3],
            phoneNumber: "(616) 399-9390",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=458&type=SPRK")
        ),
        Beach(
            id: 7,
            beachName: "Ludington State Park",
            shortDescription: "Miles of undeveloped Lake Michigan shoreline tucked between towering dunes and Hamlin Lake.",
            description: "Ludington State Park is the full package. Tucked between Hamlin Lake and Lake Michigan, the park offers miles of undeveloped shoreline on both sides: calm freshwater paddling on the inland lake and open wave swimming on the big lake. Towering forested dunes separate the two, crisscrossed by trails that reward the effort with sweeping views of both. The beach on the Lake Michigan side is wide, clean, and rarely feels crowded given the size of the park. A historic lighthouse stands at the north end of the beach, reachable by foot or kayak along the lakeshore.",
            coordinates: .init(latitude: 44.0349, longitude: -86.5018),
            keywords: ["lake michigan", "west michigan", "dunes", "swimming", "hiking", "camping", "fishing", "family", "scenic", "boat launch"],
            displayKeywords: ["Lake Michigan", "State Park", "Dunes", "Fishing"],
            images: [.ludington1, .ludington2, .ludington3],
            phoneNumber: "(231) 843-2423",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=468&type=SPRK")
        ),
        Beach(
            id: 8,
            beachName: "P.J. Hoffmaster State Park",
            shortDescription: "Three miles of pristine Lake Michigan beach in a quiet, forested dune setting.",
            description: "P.J. Hoffmaster State Park is a quiet alternative to the busier beach towns that line West Michigan's shoreline. Three miles of Lake Michigan beach stretch between forested dune ridges and the water, with trails winding through one of the most intact dune ecosystems left on the eastern shore. The E. Genevieve Gillette Nature Center offers a solid introduction to how these dunes formed and why they matter. The beach itself is clean and rarely packed. If you want a Lake Michigan day without the crowds, the concession stands, and the parking lot gridlock, this is the place.",
            coordinates: .init(latitude: 43.1329, longitude: -86.2654),
            keywords: ["lake michigan", "west michigan", "dunes", "swimming", "hiking", "camping", "family", "quiet", "nature", "scenic", "restrooms"],
            displayKeywords: ["Lake Michigan", "State Park", "Dunes", "Camping"],
            images: [.hoffmaster1, .hoffmaster2, .hoffmaster3],
            phoneNumber: "(231) 798-3711",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=457&type=SPRK")
        ),
        Beach(
            id: 9,
            beachName: "Warren Dunes State Park",
            shortDescription: "Dramatic 260-foot dunes and wide sandy beach just 90 minutes from Chicago.",
            description: "Warren Dunes is where Chicago comes to spend the weekend on the water. Just 90 minutes from the city, the park draws enormous summer crowds to its 260-foot dunes, wide sandy beach, and reliable Lake Michigan winds. The dunes themselves are the main event: people climb them, run down them, and watch from the top as the lake stretches out to the horizon. The water is colder than the Gulf and rougher than a lake has any right to be. It's a real beach, with real waves, close enough to the Midwest's biggest city to feel like a miracle.",
            coordinates: .init(latitude: 41.9153, longitude: -86.5934),
            keywords: ["lake michigan", "southwest michigan", "dunes", "swimming", "hiking", "camping", "family", "adventure", "scenic", "restrooms"],
            displayKeywords: ["Lake Michigan","State Park", "Dunes", "Camping"],
            images: [.warrenDunes1, .warrenDunes2, .warrenDunes3],
            phoneNumber: "(269) 426-4013",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=504&type=SPRK")
        ),
        Beach(
            id: 10,
            beachName: "Petoskey State Park",
            shortDescription: "Little Traverse Bay beach known for petoskey stone hunting and sweeping northern Michigan views.",
            description: "Petoskey State Park sits along Little Traverse Bay, one of the most beautiful corners of northern Lake Michigan. The beach is known for Petoskey stone hunting, and you'll find people bent over the shoreline scanning the gravel at low tide all season long. But the park has more going on than fossil coral: the bay views are sweeping, the water shifts from aquamarine to deep blue depending on the light, and the nearby town of Petoskey offers some of the best dining and lodging in northern Michigan. Fall colors here are exceptional. It's the kind of place that earns repeat visits.",
            coordinates: .init(latitude: 45.4068, longitude: -84.9086),
            keywords: ["lake michigan", "northwest michigan", "petoskey stones", "rock hunting", "swimming", "hiking", "camping", "family", "scenic", "quiet", "restrooms"], displayKeywords: ["Lake Michigan", "State Park", "Petoskey Stones", "Camping"],
            images: [.petoskey1, .petoskey2, .petoskey3],
            phoneNumber: "(231) 347-2311",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=484&type=SPRK")
        ),
        Beach(
            id: 11,
            beachName: "Pictured Rocks National Lakeshore",
            shortDescription: "42 miles of multicolored sandstone cliffs, sea caves, and remote Lake Superior beaches.",
            description: "Pictured Rocks National Lakeshore is in a category of its own. Spanning 42 miles of Lake Superior's southern shore, the park is defined by towering multicolored sandstone cliffs that rise directly from the lake, carved by waves into arches, caves, and columns streaked with mineral deposits in orange, pink, and green. Remote beaches sit tucked between the cliffs, reachable by hiking trail or kayak. The water is cold and strikingly clear. This is not a casual beach day destination — it's a wilderness. But for those who make the trip into Michigan's Upper Peninsula, it delivers scenery that doesn't look real.",
            coordinates: .init(latitude: 46.5643, longitude: -86.3163),
            keywords: ["lake superior", "upper peninsula", "cliffs", "sea caves", "kayaking", "hiking", "camping", "scenic", "remote", "adventure"],
            displayKeywords: ["Lake Superior", "National Park", "Cliffs", "Camping"],
            images: [.picturedRocks1, .picturedRocks2, .picturedRocks3],
            phoneNumber: "(906) 387-3700",
            websiteURL: URL(string: "https://www.nps.gov/piro")
        ),
        Beach(
            id: 12,
            beachName: "Presque Isle Park",
            shortDescription: "Rocky Lake Superior peninsula with crashing waves and panoramic views at the edge of Marquette.",
            description: "Presque Isle Park is a 323-acre peninsula that juts into Lake Superior at the edge of Marquette, offering one of the most dramatic waterfront settings of any city park in the Great Lakes. Rocky trails run along the shoreline as waves crash against the basalt below. The views extend across the open lake in every direction, with nothing between you and the Canadian shore but Superior's cold, dark water. It's a park for walkers, runners, and anyone who wants to feel the scale of the largest freshwater lake in the world without driving deep into the backcountry.",
            coordinates: .init(latitude: 46.5880, longitude: -87.3818),
            keywords: ["lake superior", "upper peninsula", "marquette", "rocky", "hiking", "swimming", "scenic", "remote", "adventure", "waves"],
            displayKeywords: ["Lake Superior", "City Park", "Hiking", "Fishing"],
            images: [.presqueIslePark1, .presqueIslePark2, .presqueIslePark3],
            phoneNumber: "(906) 228-0460",
            websiteURL: URL(string: "https://www.marquettemi.gov/departments/community-services/parks-recreation/")
        ),
        Beach(
            id: 13,
            beachName: "Harrisville State Park",
            shortDescription: "Quiet Lake Huron beach on the Sunrise Coast with a picturesque harbor nearby.",
            description: "Harrisville State Park is small by Michigan standards, but it punches above its size. Situated right on Lake Huron along the Sunrise Coast, the park offers direct beach access, a quiet harbor, and easy proximity to the charming town of Harrisville. The beach is pebbly in places but opens up to softer sand toward the water, and the lake views stretch east with nothing to interrupt them. Sunrises here are among the best in Michigan. The M-23 Heritage Route runs through town, making Harrisville a natural stop on a longer drive up the eastern shore.",
            coordinates: .init(latitude: 44.6475, longitude: -83.2976),
            keywords: ["lake huron", "sunrise coast", "lower peninsula", "swimming", "fishing", "camping", "family", "quiet", "harbor", "scenic", "lodging"],
            displayKeywords: ["Lake Huron", "State Park", "Lodging", "Hiking"],
            images: [.harrisville1, .harrisville2, .harrisville3],
            phoneNumber: "(989) 724-5126",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=455&type=SPRK")
        ),
        Beach(
            id: 14,
            beachName: "Sterling State Park",
            shortDescription: "Michigan's only Lake Erie state park, with sandy beaches and excellent fishing near the Ohio border.",
            description: "Sterling State Park holds a distinction no other Michigan park can claim: it's the only state park on Lake Erie. Located in Monroe, just minutes from the Ohio border, the park offers sandy beaches, warm, calm water, and some of the best freshwater fishing in the state. Erie runs shallower and warmer than the other Great Lakes, which means comfortable swimming temperatures through the summer. The birdwatching is exceptional, particularly during fall migration when the park sits along a major flyway. It's an underrated corner of Michigan's coastline that most people overlook on their way somewhere else.",
            coordinates: .init(latitude: 41.9200, longitude: -83.3415),
            keywords: ["lake erie", "southeast michigan", "swimming", "fishing", "bird watching", "camping", "family", "quiet", "scenic"],
            displayKeywords: ["Lake Erie", "State Park", "Boat Launch", "Hiking"],
            images: [.williamCSterling1, .williamCSterling2, .williamCSterling2],
            phoneNumber: "(734) 289-2715",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=497&type=SPRK")
        ),
        Beach(
            id: 15,
            beachName: "Muskegon State Park",
            shortDescription: "Two miles of open Lake Michigan shoreline with calmer Muskegon Lake frontage on the other side.",
            description: "Muskegon State Park occupies a narrow strip of land between Lake Michigan and Muskegon Lake, giving it two distinct waterfronts in one park. The Lake Michigan side brings open water, consistent waves, and two miles of wide sandy beach. The Muskegon Lake side is calmer, better suited for paddling and fishing. Forested dunes run through the middle of the park, with trails connecting both shores. In winter, the park runs one of the few luge tracks in the country. Year-round, it's one of West Michigan's most versatile outdoor destinations — whether you're there to swim, hike, or just watch the water.",
            coordinates: .init(latitude: 43.2485, longitude: -86.3339),
            keywords: ["lake michigan", "west michigan", "swimming", "hiking", "camping", "kayaking", "fishing", "family", "scenic", "dunes"],
            displayKeywords: ["Lake Michigan", "State Park", "Boat Launch", "Hiking"],
            images: [.muskegonStatePark1, .muskegonStatePark2, .muskegonStatePark3],
            phoneNumber: "(231) 744-3480",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=475&type=SPRK")
        ),
        Beach(
            id: 16,
            beachName: "Saugatuck Dunes State Park",
            shortDescription: "2.5 miles of undeveloped Lake Michigan shoreline with forested dunes and 13 miles of trails.",
            description: "Saugatuck Dunes State Park is one of the last undeveloped stretches of Lake Michigan shoreline in West Michigan, and it shows. No concession stands. No boardwalks. Just 2.5 miles of pristine beach, forested dunes, and 13 miles of trails winding through mature beech and maple forest. The beach itself requires a hike to reach from the parking area, which keeps the crowds light even on summer weekends. Saugatuck town is nearby for food and lodging, but the park itself operates at a different pace. It's a destination for people who want the lake without everything that usually comes with it.",
            coordinates: .init(latitude: 42.6968, longitude: -86.1903),
            keywords: ["lake michigan", "west michigan", "dunes", "swimming", "hiking", "quiet", "scenic", "undeveloped", "nature", "family"],
            displayKeywords: ["Lake Michigan", "State Park", "Dunes", "Hiking"],
            images: [.saugatuckDunes1, .saugatuckDunes2, .saugatuckDunes3],
            phoneNumber: "(269) 637-2788",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=491&type=SPRK")
        ),
        Beach(
            id: 17,
            beachName: "South Haven South Beach",
            shortDescription: "Golden sand and calm water framed by South Haven's iconic red lighthouse.",
            description: "South Haven South Beach is one of West Michigan's most beloved summer destinations, and the red lighthouse at the mouth of the Black River is the image most people picture when they think of the town. The beach is wide and sandy with calm enough water for comfortable swimming, and the surrounding harbor is lined with boats, restaurants, and ice cream shops. It fills up fast on summer weekends. Arrive early, claim your stretch of sand near the water, and spend the afternoon moving between the beach and the harbor. South Haven knows what it is and delivers it consistently.",
            coordinates: .init(latitude: 42.4031, longitude: -86.2736),
            keywords: ["lake michigan", "west michigan", "lighthouse", "swimming", "fishing", "family", "harbor", "scenic", "charming", "quiet"],
            displayKeywords: ["Lake Michigan", "City Park", "Lighthouse", "Dunes"],
            images: [.southHavenSouthBeach1, .southHavenSouthBeach2, .southHavenSouthBeach3],
            phoneNumber: "(269) 637-0772",
            websiteURL: URL(string: "https://www.southhaven.org/beaches")
        ),
        Beach(
            id: 18,
            beachName: "Port Crescent State Park",
            shortDescription: "Three miles of Lake Huron shoreline on Michigan's Thumb, one of the Lower Peninsula's best dark sky sites.",
            description: "Port Crescent State Park curves along three miles of sandy Lake Huron shoreline at the tip of Michigan's Thumb, offering one of the most underrated beach experiences in the state. The water on this side of the lake is warmer and calmer than Lake Michigan, and the broad, flat beach is ideal for long walks at low tide. After dark, Port Crescent becomes one of the best stargazing locations in the Lower Peninsula. The park sits in a certified dark sky preserve, and on clear nights the Milky Way is visible to the naked eye. It's worth staying past sunset.",
            coordinates: .init(latitude: 44.0103, longitude: -83.0508),
            keywords: ["lake huron", "thumb", "lower peninsula", "swimming", "hiking", "camping", "fishing", "family", "dark sky", "stargazing", "scenic"],
            displayKeywords: ["Lake Huron", "State Park", "Stargazing", "Fishing"],
            images: [.portCrescent1, .portCrescent2, .portCrescent3],
            phoneNumber: "(989) 738-8663",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=485&type=SPRK")
        ),
        Beach(
            id: 19,
            beachName: "Albert E. Sleeper State Park",
            shortDescription: "Wide sandy Saginaw Bay beach set among rare dune forest on Michigan's Thumb.",
            description: "Albert E. Sleeper State Park is a peaceful alternative to the busier resort towns scattered around Michigan's Thumb. Set along Saginaw Bay among rare dune forest habitat, the park offers a wide sandy beach on warm, relatively calm water, four miles of wooded trails, and the kind of quiet that's harder and harder to find in summer. The bay side of Lake Huron runs warmer than the open lake, making for comfortable swimming through the season. It's a park for families who want to slow down, for birders working the dune forest, and for anyone who prefers a beach that doesn't come with a crowd.",
            coordinates: .init(latitude: 43.9726, longitude: -83.2055),
            keywords: ["lake huron", "thumb", "lower peninsula", "swimming", "hiking", "camping", "fishing", "family", "quiet", "scenic", "dune forest"],
            displayKeywords: ["Lake Huron", "State Park", "Hiking", "Camping"],
            images: [.albertESleeper1, .albertESleeper2, .albertESleeper3],
            phoneNumber: "(989) 856-4411",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=494&type=SPRK")
        ),
        Beach(
            id: 20,
            beachName: "McLain State Park",
            shortDescription: "Remote Lake Superior beach on the Keweenaw Peninsula with dramatic Superior sunsets.",
            description: "McLain State Park sits at the northern tip of the Keweenaw Peninsula, where the land finally runs out and Lake Superior takes over. Two miles of remote sandy beach face west, making this one of the best spots in the entire Great Lakes for watching the sun go down over open water. The Keweenaw is copper country, and the park sits within a landscape shaped by mining history, boreal forest, and Superior's cold dominance over the local climate. Summers here are short and clear. The beach is rarely crowded. If you're making the drive up the peninsula, this is the destination at the end of it.",
            coordinates: .init(latitude: 47.2371, longitude: -88.6088),
            keywords: ["lake superior", "upper peninsula", "keweenaw", "swimming", "hiking", "camping", "fishing", "scenic", "remote", "sunset"],
            displayKeywords: ["Lake Superior", "State Park", "Hiking", "Fishing"],
            images: [.mclainStatePark1, .mclainStatePark2, .mclainStatePark3],
            phoneNumber: "(906) 482-0278",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=423&type=SPRK")
        ),
        Beach(
            id: 21,
            beachName: "Porcupine Mountains Wilderness State Park",
            shortDescription: "Michigan's largest state park, with a rugged Lake Superior beach and ancient old-growth forest.",
            description: "The Porcupine Mountains are Michigan's largest and wildest state park, stretching along Lake Superior's shore in the remote western Upper Peninsula. Union Bay Beach sits at the eastern entrance to the park, offering a broad gravel-and-sand shoreline with Superior crashing in from the northwest. But the Porkies are more than a beach destination. Old-growth hemlock and maple forest covers most of the park's 60,000 acres. Waterfalls run through deep river gorges. Backcountry trails and rustic cabins extend for days in every direction. It's one of the few places left in the Midwest where the wilderness feels genuinely uncompromised.",
            coordinates: .init(latitude: 46.7811, longitude: -89.6807),
            keywords: ["lake superior", "upper peninsula", "wilderness", "hiking", "camping", "fishing", "scenic", "remote", "adventure", "old growth", "rugged"], displayKeywords: ["Lake Superior", "State Park", "Mountains", "Waterfalls"],
            images: [.porcupineMountainsWildernessStatePark1, .porcupineMountainsWildernessStatePark2, .porcupineMountainsWildernessStatePark3],
            phoneNumber: "(906) 885-5275",
            websiteURL: URL(string: "https://www2.dnr.state.mi.us/parksandtrails/Details.aspx?id=426&type=SPRK")
        ),
    ]
}
