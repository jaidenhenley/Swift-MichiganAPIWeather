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
            let config = WKWebViewConfiguration()
            config.allowsInlineMediaPlayback = true
            
            let webView = WKWebView(frame: .zero, configuration: config)
            webView.isOpaque = false // Allows the background color to show through
            webView.backgroundColor = UIColor(red: 16/255, green: 28/255, blue: 37/255, alpha: 1) // #101c25
            webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Mobile/15E148 Safari/604.1"
            return webView
        }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let bundleID = "com.michigan.beachcams" // Your Bundle ID
        let origin = "https://\(bundleID)"
        
        // Use the Channel ID for South Haven so it never "expires"
        // Channel ID for South Haven City: UCG80N_0-X8I-pG8v7S8aIiw
        let embedURL = "https://www.youtube-nocookie.com/embed/\(videoID)?playsinline=1&modestbranding=1&rel=0&autoplay=1&mute=1&origin=\(origin)"
        
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
            <style>
                body, html { margin: 0; padding: 0; width: 100%; height: 100%; background-color: black; overflow: hidden; }
                .container { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
                iframe { width: 100%; height: 100%; border: none; }
            </style>
        </head>
        <body>
            <div class="container">
                <iframe src="\(embedURL)" allow="autoplay; encrypted-media" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
            </div>
        </body>
        </html>
        """
        
        uiView.loadHTMLString(html, baseURL: URL(string: origin))
    }
}

struct BeachCamView: View {
    let videoID: String

    var body: some View {
        VStack(spacing: 20) {
            YoutubePlayerView(videoID: videoID)
                .frame(maxWidth: .infinity)
                .aspectRatio(16/9, contentMode: .fit)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal)

            Text("Live Beach Cam")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
        .padding(.top)
    }
}
