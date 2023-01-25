//
//  RecordedAudioPlayerView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 21/01/2023.
//

import SwiftUI
import DSWaveformImage
import DSWaveformImageViews

struct RecordedAudioPlayerView: View {
    
    var url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    @StateObject var model = RecordViewModel()
    @State var configuration: Waveform.Configuration = .init(
        style: .striped(.init(color: UIColor(named: "blue_secondary") ?? .blue, width: 1, spacing: 1)),
        dampening: .init(percentage: 0, sides: .both))
    
    @State var placeHolderConfiguration: Waveform.Configuration = .init(
        style: .striped(.init(color: UIColor(named: "gull_gray") ?? .blue,  width: 1, spacing: 1)),
        dampening: .init(percentage: 0, sides: .both))
    
    let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        HStack {
            ZStack {
                WaveformView(audioURL: url, configuration: placeHolderConfiguration)
                
                WaveformView(audioURL: url, configuration: configuration)
                    .mask(alignment: .leading) {
                        GeometryReader { geo in
                            Rectangle().frame(width: geo.size.width * model.playingProgress)
                        }
                    }
            }
            .padding([.leading, .vertical], 8)
            
            Text(
                timeFormatter.string(from: model.playingTime) ?? "0:00"
            )
            .font(.custom("Roboto", size: 10))
            .foregroundColor(.gullGray)
            
            Button {
                model.isPlaying.toggle()
            } label: {
                Image(model.isPlaying ? "btn_pause" : "btn_play")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .padding([.trailing, .vertical], 8)
        }
        .frame(width: 220, height: 34)
        .background {
            Color.blueLight
        }
        .cornerRadius(17)
        .onAppear {
            model.playingURL = url
        }
    }
}

struct RecordedAudioPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        RecordedAudioPlayerView(url: URL(string: "url-com")!)
    }
}
