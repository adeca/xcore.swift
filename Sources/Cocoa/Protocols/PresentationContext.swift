//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A type that can be initialized in multiple contexts.
///
/// The presentation context is a simple way to express how the view is being
/// displayed. The context helps manage complexity by enabling code reuse and
/// and allowing context specific logic where necessary. For example, context
/// can be used to add padding in details screen only and add tracking events
/// based on context while sharing the same code.
public protocol PresentationContext {
    typealias Kind = PresentationContextKind
    var context: Kind { get }
    init(collectionView: UICollectionView, context: Kind)
}

// MARK: - Kind

// If Swift ever allows nested types this enum can move under the
// protocol namespace as `PresentationContextKind.Kind`.
public struct PresentationContextKind: Equatable {
    public let id: Identifier<PresentationContextKind>

    public init(id: Identifier<PresentationContextKind>) {
        self.id = id
    }
}

extension PresentationContextKind: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(id: .init(rawValue: value))
    }
}

extension PresentationContextKind {
    public static var feed: PresentationContextKind {
        "feed"
    }

    public static var detail: PresentationContextKind {
        "detail"
    }
}
