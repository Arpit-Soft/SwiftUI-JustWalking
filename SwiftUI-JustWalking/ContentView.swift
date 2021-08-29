//
//  ContentView.swift
//  SwiftUI-JustWalking
//
//  Created by Arpit Dixit on 29/08/21.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    
    @AppStorage("stepCount", store: UserDefaults(suiteName: "group.com.techzi.JustWalking"))
    var stepCount = 0
    
    private let pedometer = CMPedometer()
    @State private var steps: Int?
    @State private var distance: Double?
    private var isPedometerAvailable: Bool {
        return CMPedometer.isPedometerEventTrackingAvailable() && CMPedometer.isDistanceAvailable() && CMPedometer.isStepCountingAvailable()
    }
    
    private func intializePedometer() {
        if isPedometerAvailable {
            guard let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else {
                return
            }
            pedometer.queryPedometerData(from: startDate, to: Date()) { (data, error) in
                guard let data = data, error == nil else {return}
                stepCount = data.numberOfSteps.intValue
                steps = stepCount
                distance = data.distance?.doubleValue
                
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("\(steps ?? 0) steps")
                .padding()
            Text("\(String(format: "%.2f", distance ?? 0)) meters")
                .padding()
        }
        
        .onAppear(perform: {
            intializePedometer()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
