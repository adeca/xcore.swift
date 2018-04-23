//
// TextViewController.swift
//
// Copyright © 2016 Zeeshan Mian
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
import MDHTMLLabel

open class TextViewController: XCScrollViewController, MDHTMLLabelDelegate {
    open private(set) lazy var textLabel: MDHTMLLabel = {
        let textLabel = MDHTMLLabel()
        textLabel.delegate = self
        textLabel.font = .systemFont(.footnote)
        textLabel.textColor = .darkGray
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.linkAttributes = [NSAttributedStringKey.foregroundColor: textLabel.tintColor]
        textLabel.activeLinkAttributes = [NSAttributedStringKey.foregroundColor: textLabel.tintColor]
        textLabel.lineHeightMultiple = 1.1
        return textLabel
    }()

    /// The distance that the text is inset from the enclosing scroll view.
    /// The default value is `UIEdgeInsets(15)`.
    open var contentInset = UIEdgeInsets(15)

    /// A convenience property to set view’s background image.
    /// The default value is `nil`, which means apply view's background color.
    open var backgroundImage: UIImage?

    /// The text that will be displayed.
    open var text = "" {
        didSet {
            textLabel.htmlText = text
        }
    }

    /// Sets text from the specified file name.
    ///
    /// ```swift
    /// let vc = TextViewController()
    /// vc.setText("Terms.txt")
    /// navigationController.pushViewController(vc, animated: true)
    /// ```
    ///
    /// - parameter filename: The file name.
    /// - parameter bundle:   The bundle containing the specified file name. If you specify nil,
    ///   this method looks in the main bundle of the current application. The default value is `nil`.
    open func setText(_ filename: String, bundle: Bundle? = nil) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let name = filename.lastPathComponent.stringByDeletingPathExtension
            let ext = filename.pathExtension
            let bundle = bundle ?? Bundle.main

            if let path = bundle.path(forResource: name, ofType: ext), let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
                DispatchQueue.main.async { [weak self] in
                    self?.text = content
                }
            }
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupTextLabel()
    }

    deinit {
        console.info("deinit")
    }

    // MARK: Setup Methods

    private func setupTextLabel() {
        textLabel.htmlText = text
        scrollView.alwaysBounceVertical = true
        scrollView.addSubview(textLabel)
        NSLayoutConstraint.constraintsForViewToFillSuperview(textLabel, padding: contentInset, priority: .defaultHigh).activate()

        if let backgroundImage = backgroundImage?.cgImage {
            view.layer.contents = backgroundImage
        } else {
            view.backgroundColor = .white
        }
    }

    open func htmlLabel(_ label: MDHTMLLabel, didSelectLinkWith URL: URL) {
        open(url: URL, from: self)
    }
}
