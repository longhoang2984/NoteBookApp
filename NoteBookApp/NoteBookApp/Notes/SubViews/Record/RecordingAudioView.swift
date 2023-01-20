//
//  RecordingAudioView.swift
//  NoteBookApp
//
//  Created by Cửu Long Hoàng on 20/01/2023.
//

import SwiftUI
import DSWaveformImageViews
import DSWaveformImage

struct RecordingAudioView: View {
    @StateObject var model = RecordViewModel()
    
    @State var configuration: Waveform.Configuration = .init(
        style: .striped(.init(color: UIColor(named: "blue_primary") ?? .blue, width: 4.5, spacing: 4)),
        dampening: .init(percentage: 0, sides: .both)
        )
    
    var body: some View {
        VStack {
            Button {
                model.isPlaying.toggle()
            } label: {
                Image("btn_play")
            }
            
            WaveformLiveCanvas(samples: model.samples,configuration: configuration, shouldDrawSilencePadding: true)
                .padding()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                FloatingButton(title: model.isRecording ? "RECORDING" : "RECORD") {
                    model.isRecording.toggle()
                }
            }
        }
    }
}

struct RecordingAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAudioView()
    }
}
