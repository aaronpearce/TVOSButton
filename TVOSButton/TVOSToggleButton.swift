//
//  TVOSToggleButton.swift
//  TVOSButton
//
//  Created by Cem Olcay on 15/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

public typealias TVOSToggleButtonDidToggledAction = (_ currentState: TVOSToggleButtonState, _ newState: (_ newState: TVOSToggleButtonState) -> Void) -> Void

public enum TVOSToggleButtonState {
	case waiting
	case on
	case fff
}

public class TVOSToggleButton: TVOSButton {

	// MARK; Properties

	public var toggleState: TVOSToggleButtonState = .waiting
	public var didToggledAction: TVOSToggleButtonDidToggledAction? {
		didSet {
			didToggled(sender: self)
		}
	}

	// MARK: Init

	public init(initialState: TVOSToggleButtonState, didToggledAction: TVOSToggleButtonDidToggledAction?) {
		super.init(frame: CGRect.zero)
		self.toggleState = initialState
		self.didToggledAction = didToggledAction
		commonInit()
	}

	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	public func commonInit() {
		addTarget(self, action: "didToggled:", for: .primaryActionTriggered)
	}

	// MARK: Toggle

	public func didToggled(sender: TVOSToggleButton) {
		didToggledAction?(
			toggleState,
			{ state in
				self.toggleState = state
		})
	}
}
