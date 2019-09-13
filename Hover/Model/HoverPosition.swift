//
//  HoverPosition.swift
//  Hover
//
//  Created by Pedro Carrasco on 12/07/2019.
//  Copyright © 2019 Pedro Carrasco. All rights reserved.
//

import UIKit

// MARK: - HoverPosition
public enum HoverPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
}

// MARK: - Properties
extension HoverPosition {
    
    var xOrientation: Orientation.X {
        switch self {
        case .topLeft, .bottomLeft:
            return .leftToRight
        case .topRight, .bottomRight:
            return .rightToLeft
        }
    }
    
    var yOrientation: Orientation.Y {
        switch self {
        case .bottomLeft, .bottomRight:
            return .bottomToTop
        case .topLeft, .topRight:
            return .topToBottom
        }
    }
}

// MARK: - Configuration
extension HoverPosition {

    func configurePosition(of guide: UILayoutGuide, inside view: UIView, with spacing: CGFloat, constrainBottomToSafeAreaIfNonZeroHeight: Bool) -> NSLayoutConstraint? {
        let positionConstraints: [NSLayoutConstraint]
        var safeAreaConstraint: NSLayoutConstraint?
        switch self {
        case .topLeft:
            positionConstraints = [
                guide.topAnchor.constraint(equalTo: view.safeAreaTopAnchor, constant: spacing),
                guide.leadingAnchor.constraint(equalTo: view.safeAreaLeadingAnchor, constant: spacing)
            ]
        case .topRight:
            positionConstraints = [
                guide.topAnchor.constraint(equalTo: view.safeAreaTopAnchor, constant: spacing),
                guide.trailingAnchor.constraint(equalTo: view.safeAreaTrailingAnchor, constant: -spacing)
            ]
        case .bottomLeft:
            let (bottomConstraints, _safeAreaConstraint) = self.bottomConstraints(for: guide, view: view, spacing: spacing, constrainBottomToSafeAreaIfNonZeroHeight: constrainBottomToSafeAreaIfNonZeroHeight)
            positionConstraints = bottomConstraints + [
                guide.leadingAnchor.constraint(equalTo: view.safeAreaLeadingAnchor, constant: spacing),
            ]
            safeAreaConstraint = _safeAreaConstraint
        case .bottomRight:
            let (bottomConstraints, _safeAreaConstraint) = self.bottomConstraints(for: guide, view: view, spacing: spacing, constrainBottomToSafeAreaIfNonZeroHeight: constrainBottomToSafeAreaIfNonZeroHeight)
            positionConstraints = bottomConstraints + [
                guide.trailingAnchor.constraint(equalTo: view.safeAreaTrailingAnchor, constant: -spacing)
            ]
            safeAreaConstraint = _safeAreaConstraint
        }
        NSLayoutConstraint.activate(positionConstraints)
        return safeAreaConstraint
    }
    
    private func bottomConstraints(for guide: UILayoutGuide, view: UIView, spacing: CGFloat, constrainBottomToSafeAreaIfNonZeroHeight: Bool) -> ([NSLayoutConstraint], NSLayoutConstraint?) {
        let bottomConstraints: [NSLayoutConstraint]
        var safeAreaConstraint: NSLayoutConstraint?
        // https://stackoverflow.com/a/53634824/
        if constrainBottomToSafeAreaIfNonZeroHeight {
            let toSafeArea = guide.bottomAnchor.constraint(equalTo: view.safeAreaBottomAnchor, constant: 0)
            toSafeArea.priority = .defaultLow
            let toSuperview = guide.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -spacing)
            toSuperview.priority = .defaultHigh
            bottomConstraints = [
                toSafeArea,
                toSuperview,
            ]
            safeAreaConstraint = toSafeArea
        } else {
            bottomConstraints = [
                guide.bottomAnchor.constraint(equalTo: view.safeAreaBottomAnchor, constant: -spacing),
            ]
        }
        return (bottomConstraints, safeAreaConstraint)
    }

}

// MARK: - Sugar
public extension Set where Element == HoverPosition {

    static let all: Set<HoverPosition> = [.topLeft, .topRight, .bottomLeft, .bottomRight]
}

// MARK: - CaseIterable
extension HoverPosition: CaseIterable {}

// MARK: - Equatable
extension HoverPosition: Equatable {}

// MARK: - Safe area
extension UIView {
    
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    var safeAreaLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }
    var safeAreaTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
}
