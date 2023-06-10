//
//  Content-ViewModel.swift
//  Teeth Time
//
//  Created by John Sorhannus on 6/10/23.
//

import Foundation
import Combine

class TimerModel: ObservableObject {
    @Published var time: String
    @Published var minutes: Int
    @Published var seconds: Int
    var endDate: Date = Date()
    
    init(minutes: Int, seconds: Int) {
        self.minutes = minutes
        self.seconds = seconds
        self.time = String(format: "%d:%02d", minutes, seconds)
    }
    
    func start(timeNow: Date) {
        if seconds == 0 {
            endDate = Calendar.current.date(byAdding: .minute, value: Int(self.minutes), to: timeNow)!
        } else {
            endDate = Calendar.current.date(byAdding: .second, value: Int(self.seconds), to: timeNow)!
        }
    }
}


extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var twoMinuteTimer: TimerModel = TimerModel(minutes: 2, seconds: 0)
        @Published var surfaceTimer: TimerModel = TimerModel(minutes: 0, seconds: 10)
        @Published var surfaceTime = 10
        
        func start() {
            let timeNow = Date()
            self.isActive = true
            twoMinuteTimer.start(timeNow: timeNow)
            surfaceTimer.start(timeNow: timeNow)
        }
        
        func calculateRemainingTime(timer: TimerModel, now: Date) -> TimeInterval {
            return timer.endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        }
        
        func getTimeString(diff: TimeInterval) -> String {
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            return String(format: "%d:%02d", minutes, seconds)
        }
        
        func updateCountdown() {
            guard isActive else { return }
            
            let timeNow = Date()
            let twoMinuteDiff = calculateRemainingTime(timer: twoMinuteTimer, now: timeNow)
            
            let isSurfaceTimerDone = surfaceDiff <= 0
            let isTwoMinuteTimerDone = twoMinuteDiff <= 0
            
            if isSurfaceTimerDone && !isTwoMinuteTimerDone {
                surfaceTimer.start(timeNow: timeNow)
                surfaceDiff = calculateRemainingTime(timer: surfaceTimer, now: timeNow)
            }
            
            if isTwoMinuteTimerDone {
                self.isActive = false
                twoMinuteTimer.time = "0:00"
                surfaceTimer.time = "0:00"
                return
            }
            
            twoMinuteTimer.time = getTimeString(diff: twoMinuteDiff)
            surfaceTimer.time = getTimeString(diff: surfaceDiff)
        }
    }
}
