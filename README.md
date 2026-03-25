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

## Developer

Jaiden Henley | [Portfolio](https://jaidenhenley.github.io/JaidenHenleyPort/) | [LinkedIn](https://www.linkedin.com/in/jaiden-henley) | [jaidenhenleydev@gmail.com](mailto:jaidenhenleydev@gmail.com)

George Clinkscales | [Portfolio](https://geoclink.github.io/portfolio/) | [LinkedIn](https://www.linkedin.com/in/george-clinkscales/) | [1lclink2@att.net](mailto:1lclink2@att.net)

