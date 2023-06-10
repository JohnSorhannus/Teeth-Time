//
//  Content-ViewModel.swift
//  Teeth Time
//
//  Created by John Sorhannus on 6/10/23.
//

import Foundation

extension ContentView {
    final class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var time: String = "2:00"
        @Published var minutes: Float = 2.0 {
            didSet {
                self.time = "\(Int(minutes)):00"
            }
        }
        
        private var initialTime = 2
        private var endDate = Date()
        
        func start(minutes: Float) {
            self.endDate = Date()
            self.isActive = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: initialTime, to: endDate)!
        }
        
        func updateCountdown() {
            guard isActive else { return }
            
            let now = Date()
            let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
            
            if diff <= 0 {
                self.isActive = false
                self.time = "0:00"
                return
            }
            
            let date = Date(timeIntervalSince1970: diff)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            self.minutes = Float(minutes)
            self.time = String(format: "%d:%02d", minutes, seconds)
        }
    }
}
