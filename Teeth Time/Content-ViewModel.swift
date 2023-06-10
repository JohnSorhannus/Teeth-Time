//
//  Content-ViewModel.swift
//  Teeth Time
//
//  Created by John Sorhannus on 6/10/23.
//

import Foundation
import Combine

extension ContentView {
    class TimerModel: ObservableObject {
        @Published var time: String
        @Published var minutes: Float {
            didSet {
                self.time = "\(Int(minutes)):00"
            }
        }
        var endDate: Date = Date()
        
        init(time: String, minutes: Float) {
            self.time = time
            self.minutes = minutes
        }
    }
    
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var twoMinuteTimer: TimerModel = TimerModel(time: "2:00", minutes: 2.0)
        var cancellable: AnyCancellable?
        
        init() {
            cancellable = twoMinuteTimer.objectWillChange.sink { _ in
                self.objectWillChange.send()
            }
        }
        
        func start() {
            twoMinuteTimer.endDate = Date()
            self.isActive = true
            twoMinuteTimer.endDate = Calendar.current.date(byAdding: .minute, value: Int(twoMinuteTimer.minutes), to: twoMinuteTimer.endDate)!
        }
        
        func updateCountdown() {
            guard isActive else { return }
            
            let now = Date()
            let diff = twoMinuteTimer.endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff <= 0 {
                self.isActive = false
                twoMinuteTimer.time = "0:00"
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            twoMinuteTimer.minutes = Float(minutes)
            twoMinuteTimer.time = String(format: "%d:%02d", minutes, seconds)
        }
    }
}
