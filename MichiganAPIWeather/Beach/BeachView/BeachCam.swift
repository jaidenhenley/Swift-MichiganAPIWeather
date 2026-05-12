//
//  BeachCam.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 5/12/26.
//

import SwiftUI
import WebKit

struct YoutubePlayerView: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> WKWebView {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true // Ensure JS is on
        
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        // 1. Spoof the User Agent to look like a real iPhone Safari browser
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // 2. Use the HTML method to bypass "Error 153/152"
        let html = """
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>body { margin: 0; background-color: black; }</style>
        </head>
        <body>
            <iframe width="100%" height="100%" 
                src="https://youtube.com\(videoID)?playsinline=1&autoplay=1&modestbranding=1&rel=0" 
                frameborder="0" allow="autoplay; encrypted-media" allowfullscreen>
            </iframe>
        </body>
        </html>
        """

        
        // 3. Set baseURL to youtube.com to fix the Referrer issue
        uiView.loadHTMLString(html, baseURL: URL(string: "https://youtube.com"))
    }
}

struct SouthHavenCamView: View {
    var body: some View {
        VStack {
            Text("South Haven Beach Live Cam")
                .font(.title)
                .bold()
                .padding()

            // This is your current working Video ID
            YoutubePlayerView(videoID: "G-tlKF32_p4")
                .frame(height: 250)
                .cornerRadius(12)
                .padding()

            Spacer()
        }
    }
}
