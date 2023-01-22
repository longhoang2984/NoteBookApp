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
    @Environment(\.dismiss) var dismiss
    var onAddRecordFile: (URL) -> Void
    
    @State var configuration: Waveform.Configuration = .init(
        size: CGSize(width: 220, height: 34),
        style: .striped(.init(color: UIColor(named: "blue_primary") ?? .blue, width: 4.5, spacing: 4)),
        dampening: .init(percentage: 0, sides: .both))
    
    @State var placeHolderConfiguration: Waveform.Configuration = .init(
        size: CGSize(width: 220, height: 34),
        style: .striped(.init(color: UIColor(named: "gull_gray") ?? .blue, width: 4.5, spacing: 4)),
        dampening: .init(percentage: 0, sides: .both))
    
    let timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View {
        VStack {
            playView
            recordView
        }
        .onDisappear {
            model.reset()
        }
    }
    
    @ViewBuilder
    var playView: some View {
        if model.recordingTime > 0, let url = model.recordURL {
            VStack {
                Button {
                    model.isPlaying.toggle()
                } label: {
                    Image(model.isPlaying ? "btn_pause" : "btn_play")
                }
                
                ZStack {
                    WaveformView(audioURL: url, configuration: placeHolderConfiguration)
                    
                    WaveformView(audioURL: url, configuration: configuration)
                        .mask(alignment: .leading) {
                            GeometryReader { geo in
                                Rectangle().frame(width: geo.size.width * model.playingProgress)
                            }
                        }
                }
                .frame(height: 70)
                .padding(.horizontal)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 11, height: 11)
                    
                    Text(
                        timeFormatter.string(from: model.playingTime) ?? "0:00"
                    )
                    .font(.custom("Roboto", size: 14))
                    .foregroundColor(.gullGray)
                    Spacer()
                }
                .padding(.leading)
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    FloatingButton(title: "X", color: .gullGray) {
                        model.reset()
                    }
                    .padding(.leading, 12)
                    Spacer()
                    FloatingButton(title: "ADD") {
                        model.saveRecord { url in
                            if let url = url {
                                onAddRecordFile(url)
                                dismiss()
                            }
                        }
                    }
                }
            }
            .alert("Something went wrong!!", isPresented: $model.showErrorSaveFile) {
                Button("OK", role: .cancel) { }
            }
            .padding(.top)
        }
    }
    
    @ViewBuilder
    var recordView: some View {
        if model.recordURL == nil {
            VStack {
                WaveformLiveCanvas(samples: model.samples,configuration: configuration, shouldDrawSilencePadding: true)
                    .frame(height: 70)
                    .padding(.horizontal)
                
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 11, height: 11)
                    
                    Text(
                        timeFormatter.string(from: model.recordingTime) ?? "0:00"
                    )
                    .font(.custom("Roboto", size: 14))
                    .foregroundColor(.gullGray)
                    Spacer()
                }
                .padding(.leading)
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FloatingButton(title: model.isRecording ? "RECORDING" : "RECORD") {
                            model.isRecording.toggle()
                        }
                    }
                }
            }
        }
    }
}

struct RecordingAudioView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingAudioView(onAddRecordFile: { _ in })
    }
}
