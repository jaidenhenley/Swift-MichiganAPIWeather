# CoastCast

Real-time beach weather for five Michigan beaches. Check conditions, wave data, and alerts before you head out. Built with a cohort partner.

[View on TestFlight](https://testflight.apple.com/join/bHcPj25S) | [View Backend on GitHub](https://github.com/jaidenhenley/Python-MichiganWaterAPI)

## Stack

Swift, SwiftUI, MapKit

## Features

- Real-time weather and wave conditions for five Michigan beaches
- NWS alerts shown per beach
- Beach detail view combining weather, buoy, and alert data into one screen
- Map view showing all five beaches

## Architecture

Two-person project. The app calls a custom FastAPI backend that handles all the data. The frontend doesn't pull from NWS or NDBC directly. It calls one endpoint per beach and gets back everything it needs in a single response.

**Map view.** All five beaches are pinned on a MapKit view. Tapping a beach opens its detail screen.

**Beach detail view.** Each beach has a detail view showing current conditions, forecast, wave height, water temperature, and any active NWS alerts. All of this comes from one backend call to `/beaches/{id}`.

**Data flow.** The app hits the backend on Render, gets back a combined dataset, and maps it to SwiftUI views.

## Requirements

- Xcode 16+
- iOS 18+

## Setup

```bash
git clone https://github.com/jaidenhenley/Swift-MichiganAPIWeather.git
```

Open in Xcode and run on a physical device or Simulator. The app points to the deployed backend on Render so no local server setup is needed.

## Developers

Jaiden Henley | [Portfolio](https://jaidenhenley.github.io/JaidenHenleyPort/) | [LinkedIn](https://www.linkedin.com/in/jaiden-henley) | [jaidenhenleydev@gmail.com](mailto:jaidenhenleydev@gmail.com)

George Clinkscales | [Portfolio](https://geoclink.github.io/portfolio/) | [LinkedIn](https://www.linkedin.com/in/george-clinkscales/) | [1lclink2@att.net](mailto:1lclink2@att.net)

  ## Credits
  - **Image**: Northern Lights Over Ontonagon
  - **Author**: Roman Kahler
  - **Source**: [Link to Image](https://commons.wikimedia.org/wiki/File:Northern_Lights_Over_Ontonagon.jpg#Licensing)
  - **License**: Licensed under Public Domain, CC BY-SA 4.0

  - **Image**: Nordhouse Dunes Wilderness Area
  - **Author**: Forest Service, Eastern Region
  - **Source**: [Link to Image](https://www.flickr.com/photos/usfs_eastern_region/33919677116)
  - **License**: Licensed under Public Domain, CC BY-SA 4.0

  - **Image**: Sunset at Nordhouse Dunes, Manistee National Forest
  - **Author**: Danielleevandenbosch
  - **Source**: Wikimedia Commons
  - **License**: Licensed under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)

  - **Image**: Harbor Beach Lighthouse
  - **Author**: Joel Dinda
  - **Source**: [Link to Image](https://www.flickr.com/photos/jowo/49966751841/)
  - **License**: Licensed under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)

  - **Image**: Grand Marais Harbor (21717268844)
  - **Author**: Tony Webster
  - **Source**: [Link to Image](https://commons.wikimedia.org/wiki/File:Grand_Marais_Harbor_%2821717268844%29.jpg)
  - **License**: Licensed under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)

  - **Image**: Oval Beach
  - **Author**: ClatieK 
  - **Source**: [Link to Image](https://www.flickr.com/photos/clatiek/3748123826)
  - **License**: Licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/deed.en)

  - **Image**: Oval Beach, Saugatuck, Michigan
  - **Author**: tb2bfit
  - **Source**: [Link to Image](https://web.archive.org/web/20161023012035/http://www.panoramio.com/photo/61039651)
  - **License**: Licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/deed.en)

  - **Image**: Tunnel Park
  - **Author**: Steven Depolo  
  - **Source**: [Link to Image](https://sandee.com/united-states/michigan/holland/tunnel-park)
  - **License**: Licensed under [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/)

  - **Image**: Pere Marquette Beach and Breakwater Lighthouse
  - **Author**: Michiganguy123
  - **Source**: [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Pere_Marquette_Beach.jpg)
  - **License**: Licensed under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)

  - **Image**: Pere Marquette Beach
  - **Author**: Kari
  - **Source**: [Link to Image](https://www.flickr.com/photos/designsbykari/28372798582/)
  - **License**: Licensed under [CC BY 2.0](https://creativecommons.org/licenses/by/2.0/deed.en)

  - **Image**: Kirk Park
  - **Author**: Cathy
  - **Source**: [Link to Image](https://www.flickr.com/photos/haglundc/6827491053/)
  - **License**: Licensed under [CC BY-NC 2.0](https://creativecommons.org/licenses/by-nc/2.0/deed.en)

  - **Image**: Lexington Harbor, Lake Huron, Lexington, Michigan
  - **Author**: Ken Lund
  - **Source**: [Link to Image](https://www.flickr.com/photos/kenlund/21850301041)
  - **License**: Licensed under [CC BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/deed.en)

  - **Image**: Gooseberry Falls State Park
  - **Author**: Joe Passe
  - **Source**: [Link to Image](https://www.flickr.com/photos/98623843@N05/51060449263/)
  - **License**: Licensed under [CC BY-SA 2.0](https://creativecommons.org/licenses/by-sa/2.0/deed.en)

  - **Image**: Norrfällsviken
  - **Author**: Bengt A. Lundberg / Riksantikvarieämbetet
  - **Source**: Wikimedia Commons
  - **License**: Licensed under [CC BY 2.5](https://creativecommons.org/licenses/by/2.5/deed.en)

  - **Image**: Whitefish Point Lighthouse
  - **Author**: Browermd
  - **Source**: Wikimedia Commons
  - **License**: Licensed under [CC BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/deed.en)

  - **Image**: Cove
  - **Author**: [jackshapiro3737](https://www.flickr.com/photos/jackshapiro3737/)
  - **Source**: [Link to Image](https://www.flickr.com/photos/jackshapiro3737/52137364831/)
  - **License**: Licensed under [CC BY-NC-SA 2.0](https://creativecommons.org/licenses/by-nc-sa/2.0/deed.en)

  - **Image**: Bay City State Park
  - **Author**: Notorious4life
  - **Source**: Wikimedia Commons
  - **License**: Licensed under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)

- **Image**: Sleeping Bear Dunes National Lakeshore
- **Author**: National Parks Gallery
- **Source**: [Link to Image](https://npgallery.nps.gov/)
- **License**: Licensed under Public Domain

- **Image**: Looking South Toward Sleeping Bear, Leland, MI
- **Author**: [don hamerly](https://www.flickr.com/photos/donhamerly/)
- **Source**: [Link to Image](https://www.flickr.com/photos/donhamerly/7503152442/)
- **License**: Licensed under [CC BY-NC-SA 2.0](https://creativecommons.org/licenses/by-nc-sa/2.0/deed.en)
