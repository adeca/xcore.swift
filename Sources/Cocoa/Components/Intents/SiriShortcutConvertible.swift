//
// SiriShortcutConvertible.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Intents

@available(iOS 12.0, *)
public protocol SiriShortcutConvertible {
    associatedtype IntentType: INIntent

    /// The Siri Shortcuts intent.
    ///
    /// Converts `self` into an appropriate intent.
    var intent: IntentType { get }
}
