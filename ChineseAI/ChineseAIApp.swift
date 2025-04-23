//
//  ChineseAIApp.swift
//  ChineseAI
//
//  Created by Nguyễn Tiến Mai on 23/4/25.
//

import SwiftUI

@main
@available(iOS 16.0, *)
struct ChineseAIApp: App {
    @UIApplicationDelegateAdaptor(ChineseAIAppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}
