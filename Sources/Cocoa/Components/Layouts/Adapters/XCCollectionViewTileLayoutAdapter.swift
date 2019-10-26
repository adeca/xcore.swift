//
// XCCollectionViewTileLayoutAdapter.swift
//
// Copyright © 2019 Xcore
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

// MARK: - XCCollectionViewTileLayoutCustomizable

public protocol XCCollectionViewTileLayoutCustomizable {
    /// Enables tile effect for each section.
    ///
    /// In a multi-column, setup returning `false` will make this section to be full
    /// width instead of column width.
    ///
    /// The default value is `true`.
    func isTileEnabled(in layout: XCCollectionViewTileLayout) -> Bool

    /// The corner radius applied to the section tile.
    func cornerRadius(in layout: XCCollectionViewTileLayout) -> CGFloat

    /// Displays a shadow behind the section tile.
    func isShadowEnabled(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> Bool

    /// Space between the section and the next section, is not applied for section
    /// with no items.
    func verticalBottomSpacing(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> CGFloat

    /// Return a not null identifier to link this section with other ones, this will
    /// make the items of this section to appear and disappear from the first item
    /// that appears on the group.
    ///
    /// This can used for stacking of sections.
    func parentIdentifier(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> String?
}

extension XCCollectionViewTileLayoutCustomizable {
    public func isTileEnabled(in layout: XCCollectionViewTileLayout) -> Bool {
        true
    }

    public func cornerRadius(in layout: XCCollectionViewTileLayout) -> CGFloat {
        layout.cornerRadius
    }

    public func isShadowEnabled(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> Bool {
        true
    }

    public func verticalBottomSpacing(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> CGFloat {
        layout.verticalIntersectionSpacing
    }

    public func parentIdentifier(in layout: XCCollectionViewTileLayout, forSectionAt section: Int) -> String? {
        nil
    }
}

open class XCCollectionViewTileLayoutAdapter: XCComposedCollectionViewLayoutAdapter, XCCollectionViewDelegateTileLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, heightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat? {
        let attributes = composedDataSource.collectionView(collectionView, itemAttributesAt: indexPath)
        return attributes?.height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, headerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        let attributes = composedDataSource.collectionView(collectionView, headerAttributesForSectionAt: section)
        return (attributes.enabled, attributes.size?.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, footerAttributesInSection section: Int, width: CGFloat) -> (Bool, CGFloat?) {
        let attributes = composedDataSource.collectionView(collectionView, footerAttributesForSectionAt: section)
        return (attributes.enabled, attributes.size?.height)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeightForItemAt indexPath: IndexPath, width: CGFloat) -> CGFloat {
        XCDataSourceSizeCalculator.estimatedItemSize(in: composedDataSource, at: indexPath, availableWidth: width).height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedHeaderHeightInSection section: Int, width: CGFloat) -> CGFloat {
        XCDataSourceSizeCalculator.estimatedHeaderSize(in: composedDataSource, for: section, availableWidth: width).height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, estimatedFooterHeightInSection section: Int, width: CGFloat) -> CGFloat {
        XCDataSourceSizeCalculator.estimatedFooterSize(in: composedDataSource, for: section, availableWidth: width).height
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, verticalSpacingBetweenSectionAt section: Int, and nextSection: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return collectionViewLayout.verticalIntersectionSpacing
        }
        return custom.verticalBottomSpacing(in: collectionViewLayout, forSectionAt: source.localSection)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isTileEnabledInSection section: Int) -> Bool {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return true
        }
        return custom.isTileEnabled(in: collectionViewLayout)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, isShadowEnabledInSection section: Int) -> Bool {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return true
        }
        return custom.isShadowEnabled(in: collectionViewLayout, forSectionAt: source.localSection)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, cornerRadiusInSection section: Int) -> CGFloat {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return collectionViewLayout.cornerRadius
        }
        return custom.cornerRadius(in: collectionViewLayout)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: XCCollectionViewTileLayout, parentIdentifierInSection section: Int) -> String? {
        let source = composedDataSource.index(for: section)
        guard let custom = source.dataSource as? XCCollectionViewTileLayoutCustomizable else {
            return nil
        }
        return custom.parentIdentifier(in: collectionViewLayout, forSectionAt: source.localSection)
    }
}

extension XCCollectionViewTileLayout: XCComposedCollectionViewLayoutCompatible {
    public static var defaultAdapterType: XCComposedCollectionViewLayoutAdapter.Type {
        XCCollectionViewTileLayoutAdapter.self
    }
}
