//
//  BeachCam.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 5/12/26.
//

import SwiftUI
import WebKit

struct YoutubePlayerView: UIViewRepresentable {
    let videoID:  String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Correct URL format for YouTube embedding
        let urlString = "https://www.youtube.com/embed/\(videoID)?playsinline=1&modestbranding=1"
        
        guard let url = URL(string: urlString) else { return }
        uiView.load(URLRequest(url: url))
    }

}


struct SouthHavenCamView: View {
    var body: some View {
        VStack {
            Text("South Haven Beach Live Cam")
                .font(.title)
                .bold()
                .padding()

            // Pass your specific Video ID here
            YoutubePlayerView(videoID: "G-tlKF32_p4")
                .frame(height: 250) // Adjust height as needed
                .cornerRadius(12)
                .padding()

            Spacer()
        }
    }
}
