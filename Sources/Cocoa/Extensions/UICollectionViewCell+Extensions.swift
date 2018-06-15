//
// UICollectionViewCell+Extensions.swift
//
// Copyright © 2018 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

// MARK: Highlighted Background Color

extension UICollectionViewCell {
    @objc private func swizzled_isHighlightedSetter(newValue: Bool) {
        let oldValue = isHighlighted
        self.swizzled_isHighlightedSetter(newValue: newValue)
        guard oldValue != isHighlighted else { return }
        setHighlighted(isHighlighted, animated: true)
    }

    /// The view to which the `highlightedBackgroundColor` is applied.
    /// The default value is `contentView`.
    @objc open override var highlightedBackgroundColorView: UIView {
        return contentView
    }

    /// The view to which the `highlightedAnimation` is applied.
    /// The default value is `contentView`.
    @objc open override var highlightedAnimationView: UIView {
        return contentView
    }
}

// MARK: Swizzle

extension UICollectionViewCell {
    static func runOnceSwapSelectors() {
        swizzle(
            UICollectionViewCell.self,
            originalSelector: #selector(setter: UICollectionViewCell.isHighlighted),
            swizzledSelector: #selector(UICollectionViewCell.swizzled_isHighlightedSetter(newValue:))
        )
    }
}
