//
//  Content-ViewModel.swift
//  Teeth Time
//
//  Created by John Sorhannus on 6/10/23.
//

import Foundation
import Combine

extension ContentView {
    struct TimerModel {
        var time: String
        var minutes: Int
        var seconds: Int
        var endDate: Date = Date()
        
        init(minutes: Int, seconds: Int) {
            self.minutes = minutes
            self.seconds = seconds
            self.time = String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var twoMinuteTimer: TimerModel = TimerModel(minutes: 2, seconds: 0)
        @Published var surfaceTimer: TimerModel = TimerModel(minutes: 0, seconds: 10)
        
        func start() {
            let timeNow = Date()
            self.isActive = true
            twoMinuteTimer.endDate = Calendar.current.date(byAdding: .minute, value: Int(twoMinuteTimer.minutes), to: timeNow)!
            surfaceTimer.endDate = Calendar.current.date(byAdding: .second, value: Int(surfaceTimer.seconds), to: timeNow)!
        }
        
        func calculateRemainingTime(timer: TimerModel, now: Date) -> TimeInterval {
            return timer.endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        }
        
        /*
        func getTimeString(timer: TimerModel) -> String {
            let now = Date()
            let diff = timer.endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff <= 0 {
                self.isActive = false
                return "0:00"
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            return String(format: "%d:%02d", minutes, seconds)
        }
         */
        
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
            let surfaceDiff = calculateRemainingTime(timer: surfaceTimer, now: timeNow)
            
            if surfaceDiff <= 0 {
                surfaceTimer.endDate = Calendar.current.date(byAdding: .second, value: Int(surfaceTimer.seconds), to: timeNow)!
                surfaceTimer.time = "0:10"
            }
            
            if twoMinuteDiff <= 0 {
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
