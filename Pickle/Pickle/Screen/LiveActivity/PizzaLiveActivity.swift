//
//  PizzaLiveActivity.swift
//  Pickle
//
//  Created by 박형환 on 5/8/24.
//

import SwiftUI
import ActivityKit

final class PizzaLiveActivity: ObservableObject {
    
    private var activity: Any?
    
    @available(iOS 17.0, *)
    private var _activity: Activity<TaskLiveActivityAttributes>? {
        get { activity as? Activity<TaskLiveActivityAttributes> }
        set { activity = newValue }
    }
    
    func startTimerActivity(taskID: String,
                            content: String,
                            closedRange: ClosedRange<Date>) {
        
        if #available(iOS 17.0, *) {
            let attributes
            = TaskLiveActivityAttributes(
                taskID: taskID,
                taskName: content
            )
            
            let state
                = TaskLiveActivityAttributes.ContentState(
                    taskMode: .decreasing,
                    taskTime: closedRange,
                    pausedTime: nil
                )
            do {
                _activity =
                try Activity<TaskLiveActivityAttributes>.request(
                    attributes: attributes,
                    contentState: state,
                    pushType: nil
                )
            } catch {
                assert(false, "Acitivity Fail")
            }
        }
    }
    
    func updateActivity(range: ClosedRange<Date>) {
        updateActivity(mode: .increasing, range: range, pausedTime: nil)
    }
    
    func pauseActivity(pausedTime: TimeInterval, isDecreasing: Bool) {
        let now = Date()
        let range = now...Date(timeInterval: max(pausedTime, 1), since: now)
        updateActivity(mode: .paused, range: range, pausedTime: pausedTime)
    }
    
    func resumeActivity(range: ClosedRange<Date>, isDecreasing: Bool) {
        updateActivity(mode: isDecreasing ? .decreasing : .increasing, range: range, pausedTime: nil)
    }
    
    private func updateActivity(mode: TaskMode,
                                range: ClosedRange<Date>,
                                pausedTime: TimeInterval?) {
        if #available(iOS 17.0, *) {
            Task {
                guard let id = _activity?.id else {
                    return
                }
                
                guard let activity = Activity<TaskLiveActivityAttributes>.activities.first(where: { $0.id == id }) else {
                    return
                }
                
                let state
                = TaskLiveActivityAttributes.ContentState(
                    taskMode: mode,
                    taskTime: range,
                    pausedTime: pausedTime
                )
                
                await activity.update(using: state)
            }
        } else {
            return
        }
    }
    
    @available(iOS 17.0, *)
    func stopTimerActivity() async {
        let finalContent
        = TaskLiveActivityAttributes.ContentState(
            taskMode: .end,
            taskTime: Date()...Date(),
            pausedTime: nil
        )
        let dismissalPolicy: ActivityUIDismissalPolicy = .immediate
        await _activity?.end(
            ActivityContent(
                state: finalContent,
                staleDate: nil
            ),
            dismissalPolicy: dismissalPolicy
        )
    }
}
