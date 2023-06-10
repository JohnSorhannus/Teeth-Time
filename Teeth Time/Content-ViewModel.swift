//
//  Content-ViewModel.swift
//  Teeth Time
//
//  Created by John Sorhannus on 6/10/23.
//

import Foundation
import UIKit
import AudioToolbox

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var time: String = "2:00"
        @Published var minutes: Int = 2
        @Published var surfaceTimeRemaining: Int = 10
        
        private var endDate: Date = Date()
        
        func start() {
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(self.minutes), to: endDate)!
        }
        
        func updateCountdown() {
            guard isActive else { return }
            
            let timeNow = Date()
            let diff = endDate.timeIntervalSince1970 - timeNow.timeIntervalSince1970
            
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                self.surfaceTimeRemaining = 0
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.time = String(format: "%d:%02d", minutes, seconds)
            
            var remainder = Int(diff.truncatingRemainder(dividingBy: 10))
            if remainder == 0 {
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.surfaceTimeRemaining = 10
            } else {
                self.surfaceTimeRemaining = remainder
            }
        }
    }
}
