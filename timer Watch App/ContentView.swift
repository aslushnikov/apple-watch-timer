//
//  ContentView.swift
//  timer Watch App
//
//  Created by Andrey Lushnikov on 5/18/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @State private var timerRunning = false
    @State private var timeElapsed = 0.0
    @State private var timer: Timer?
    @State private var selectedInterval = 10
    @State private var healthStore = HKHealthStore()
    @State private var workoutSession: HKWorkoutSession?
    
    let intervals = [5, 10, 15, 30, 60]
    
    var body: some View {
        
        VStack {
            
            Text(timeString(time: timeElapsed))
                .font(.largeTitle)
                .padding()
            
            HStack {
                Button(action: resetTimer) {
                    Text("Reset")
                }
                .padding()
                .controlSize(.mini)
                .disabled(!timerRunning)
                Button(action: startTimer) {
                    Text("Start")
                }
                .padding()
                .controlSize(.mini)
                .disabled(timerRunning)
            }
            
        }
        .padding()
        .onAppear {
            requestHealthKitAuthorization()
        }
    }
    
    func startTimer() {
        timerRunning = true
        startWorkoutSession()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeElapsed += 1.0
            if Int(timeElapsed) % selectedInterval == 0 {
                triggerHaptic()
            }
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        timerRunning = false
        timeElapsed = 0.0
        endWorkoutSession()
    }
    
    func timeString(time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func triggerHaptic() {
        WKInterfaceDevice.current().play(.notification)
    }
    
    func requestHealthKitAuthorization() {
        let healthKitTypes: Set = [
            HKObjectType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (success, error) in
            if !success {
                print("HealthKit authorization denied!")
            }
        }
    }
    
    func startWorkoutSession() {
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        workoutConfiguration.locationType = .unknown

        do {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
            workoutSession?.startActivity(with: Date())
        } catch {
            print("Failed to start workout session: \(error.localizedDescription)")
        }
    }
    
    func endWorkoutSession() {
        workoutSession?.end()
        workoutSession = nil
    }
}

#Preview {
    ContentView()
}

