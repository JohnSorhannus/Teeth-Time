//
//  ContentView.swift
//  Teeth Time
//
//  Created by John Sorhannus on 6/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    var body: some View {
        VStack {
            SurfaceTimerView(surfaceTimer: vm.surfaceTimer)
            
            TwoMinuteTimer(twoMinuteTimer: vm.twoMinuteTimer)
            
            HStack(spacing: 50) {
                Button("Start") {
                    vm.start()
                }
                .disabled(vm.isActive)
            }
        }
        .onReceive(timer) { _ in
            vm.updateCountdown()
        }
        .padding()
    }
}

struct SurfaceTimerView: View {
    @ObservedObject var surfaceTimer : TimerModel
    
    var body: some View {
        Text("\(surfaceTimer.time)")
            .font(.system(size: 70, weight: .medium, design: .rounded))
    }
}

struct TwoMinuteTimer: View {
    @ObservedObject var twoMinuteTimer : TimerModel
    
    var body: some View {
        Text("\(twoMinuteTimer.time)")
            .font(.system(size: 70, weight: .medium, design: .rounded))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
