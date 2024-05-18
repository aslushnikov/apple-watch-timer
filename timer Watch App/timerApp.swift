//
//  timerApp.swift
//  timer Watch App
//
//  Created by Andrey Lushnikov on 5/18/24.
//

import SwiftUI
import Foundation
import ClockKit

@main
struct timer_Watch_AppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class ComplicationController: NSObject, CLKComplicationDataSource {
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // TODO: Finish implementing this required method.
    }
}
