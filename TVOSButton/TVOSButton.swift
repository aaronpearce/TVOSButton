//
//  TVOSButton.swift
//  TVOSButton
//
//  Created by Cem Olcay on 10/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit
import ALKit

//
// -------------- \
// |  tvosBadge | } tvosButton
// |  tvosText  | } inside UIButton bounds
// -------------- /
//    tvosTitle   = outside UIButton bounds
//

// MARK: - TVOSButtonState

public enum TVOSButtonState: CustomStringConvertible {
	case normal
	case focused
	case highlighted
	case disabled

	public var description: String {
		switch self {
		case .normal:
			return "Normal"
		case .focused:
			return "Focused"
		case .highlighted:
			return "Highlighted"
		case .disabled:
			return "Disabled"
		}
	}
}

// MARK: - TVOSButtonStyle

public struct TVOSButtonStyle {
	// Button Style
	public var backgroundColor: UIColor?
	public var backgroundImage: UIImage?
	public var cornerRadius: CGFloat?
	public var scale: CGFloat?
	public var shadow: TVOSButtonShadow?

	// Button Content Style
	public var contentView: UIView?
	public var badgeStyle: TVOSButtonImage?
	public var textStyle: TVOSButtonLabel?
	public var titleStyle: TVOSButtonLabel?

	public func applyStyle(onButton button: TVOSButton) {
		// button
		button.tvosButton?.backgroundColor = backgroundColor
		button.tvosButtonBackgroundImageView?.image = backgroundImage
		button.tvosButton?.layer.cornerRadius = cornerRadius ?? 0
		button.tvosButton?.layer.masksToBounds = true
		button.tvosButton?.transform = CGAffineTransform(scaleX: scale ?? 1, y: scale ?? 1)

		// shadow
		if let shadow = shadow {
			shadow.applyStyle(onLayer: button.layer)
		} else {
			TVOSButtonShadow.resetStyle(onLayer: button.layer)
		}

		// content view
		for subview in button.tvosCustomContentView?.subviews ?? [] {
			subview.removeFromSuperview()
		}
		if let contentView = contentView {
			button.tvosCustomContentView?.addSubview(contentView)
		}

		// badge
		if let badge = badgeStyle {
			badge.applyStyle(onImageView: button.tvosBadge)
			button.tvosBadge?.image = button.badgeImage
		} else {
			TVOSButtonImage.resetStyle(onImageView: button.tvosBadge)
			button.tvosBadge?.image = nil
		}

		// text
		if let text = textStyle {
			text.applyStyle(onLabel: button.tvosTextLabel)
			button.tvosTextLabel?.text = button.textLabelText
		} else {
			TVOSButtonLabel.resetStyle(onLabel: button.tvosTextLabel)
			button.tvosTextLabel?.text = nil
		}

		// title
		if let title = titleStyle {
			title.applyStyle(onLabel: button.tvosTitleLabel)
			button.tvosTitleLabel?.text = button.titleLabelText
		} else {
			TVOSButtonLabel.resetStyle(onLabel: button.tvosTitleLabel)
		}
	}

	public init(
		backgroundColor: UIColor? = nil,
		backgroundImage: UIImage? = nil,
		cornerRadius: CGFloat? = nil,
		scale: CGFloat? = nil,
		shadow: TVOSButtonShadow? = nil,
		contentView: UIView? = nil,
		badgeStyle: TVOSButtonImage? = nil,
		textStyle: TVOSButtonLabel? = nil,
		titleStyle: TVOSButtonLabel? = nil) {
		self.backgroundColor = backgroundColor
		self.backgroundImage = backgroundImage
		self.cornerRadius = cornerRadius
		self.scale = scale
		self.shadow = shadow
		self.contentView = contentView
		self.badgeStyle = badgeStyle
		self.textStyle = textStyle
		self.titleStyle = titleStyle
	}
}

// MARK: - TVOSButton

open class TVOSButton: UIButton {

	// MARK: Private Properties

	fileprivate var tvosButton: UIView?
	fileprivate var tvosButtonBackgroundImageView: UIImageView?
	fileprivate var tvosCustomContentView: UIView?
	fileprivate var tvosBadge: UIImageView?
	fileprivate var tvosTextLabel: UILabel?
	fileprivate var tvosTitleLabel: UILabel?
	fileprivate var tvosTitleLabelTopConstraint: NSLayoutConstraint?

	fileprivate(set) var tvosButtonState: TVOSButtonState = .Normal {
		didSet {
			handleStateDidChange()
		}
	}

	// MARK: Public Properties

	public var badgeImage: UIImage? {
		didSet {
			if tvosButtonStyleForState(tvosButtonState: tvosButtonState).badgeStyle != nil {
				tvosBadge?.image = badgeImage
			}
		}
	}

	public var textLabelText: String? {
		didSet {
			if tvosButtonStyleForState(tvosButtonState: tvosButtonState).textStyle != nil {
				tvosTextLabel?.text = textLabelText
			}
		}
	}

	public var titleLabelText: String? {
		didSet {
			if tvosButtonStyleForState(tvosButtonState: tvosButtonState).titleStyle != nil {
				tvosTitleLabel?.text = titleLabelText
			}
		}
	}

	public var titleLabelPaddingYOnFocus: CGFloat = 10

	open override var isEnabled: Bool {
		didSet {
			tvosButtonState = isEnabled ? .Normal : .Disabled
		}
	}

	open override var isHighlighted: Bool {
		didSet {
			tvosButtonState = isHighlighted ? .Highlighted : .Focused
		}
	}

	open override var backgroundColor: UIColor? {
		get {
			return super.backgroundColor
		} set {
			self.tvosButton?.backgroundColor = newValue
		}
	}

	// MARK: Init

	public override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}

	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	private func commonInit() {
		// remove super's subviews if set
		imageView?.image = nil
		titleLabel?.text = nil

		// tvosButton
		tvosButton = UIView()
		tvosButton?.translatesAutoresizingMaskIntoConstraints = false
		addSubview(tvosButton!)

		// tvosButtonBackgroundImage
		tvosButtonBackgroundImageView = UIImageView()
		tvosButtonBackgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
		tvosButton?.addSubview(tvosButtonBackgroundImageView!)

		// tvosCustomContentView
		tvosCustomContentView = UIView()
		tvosCustomContentView?.translatesAutoresizingMaskIntoConstraints = false
		tvosButton?.addSubview(tvosCustomContentView!)

		// tvosBadge
		tvosBadge = UIImageView()
		tvosBadge?.translatesAutoresizingMaskIntoConstraints = false
		tvosButton?.addSubview(tvosBadge!)

		// tvosTextLabel
		tvosTextLabel = UILabel()
		tvosTextLabel?.translatesAutoresizingMaskIntoConstraints = false
		tvosButton?.addSubview(tvosTextLabel!)

		// tvosTitleLabel
		tvosTitleLabel = UILabel()
		tvosTitleLabel?.translatesAutoresizingMaskIntoConstraints = false
		addSubview(tvosTitleLabel!)

		// add button constraints
		tvosButton?.fill(toView: self)
		tvosButtonBackgroundImageView?.fill(toView: tvosButton!)
		tvosCustomContentView?.fill(toView: tvosButton!)
		tvosBadge?.fill(toView: tvosButton!)
		tvosTextLabel?.fill(toView: tvosButton!)

		// add title constraints
		tvosTitleLabel?.fillHorizontal(toView: self)
		tvosTitleLabel?.pinHeight(height: 50)
		tvosTitleLabelTopConstraint = NSLayoutConstraint(
			item: tvosTitleLabel!,
			attribute: .top,
			relatedBy: .equal,
			toItem: self,
			attribute: .bottom,
			multiplier: 1,
			constant: 0)
		addConstraint(tvosTitleLabelTopConstraint!)

		// finalize
		layer.masksToBounds = false
		handleStateDidChange()
	}

	// MARK: Focus

	open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
		if context.nextFocusedView == self {
			tvosButtonState = .Focused
		} else if context.previouslyFocusedView == self {
			tvosButtonState = .Normal
		}
	}

	// MARK: Handlers

	/// Override this function if you want to get notified about state changes.
	open func tvosButtonStateDidChange(tvosButtonState: TVOSButtonState) { }

	/// Override this function for style your subclass TVOSButton.
	open func tvosButtonStyleForState(tvosButtonState: TVOSButtonState) -> TVOSButtonStyle {
		switch tvosButtonState {
		case .Focused:
			return TVOSButtonStyle(
				backgroundColor: UIColor.white,
				backgroundImage: nil,
				cornerRadius: 10,
				scale: 1.1,
				shadow: TVOSButtonShadow.Focused,
				contentView: nil,
				badgeStyle: TVOSButtonImage.Fit,
				textStyle: TVOSButtonLabel.DefaultText(color: UIColor.black),
				titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.white))

		case .Highlighted:
			return TVOSButtonStyle(
				backgroundColor: UIColor.white,
				backgroundImage: nil,
				cornerRadius: 10,
				scale: 0.95,
				shadow: TVOSButtonShadow.Highlighted,
				contentView: nil,
				badgeStyle: TVOSButtonImage.Fit,
				textStyle: TVOSButtonLabel.DefaultText(color: UIColor.black),
				titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.white))

		default:
			return TVOSButtonStyle(
				backgroundColor: UIColor.gray,
				cornerRadius: 10,
				badgeStyle: TVOSButtonImage.Fit,
				textStyle: TVOSButtonLabel.DefaultText(color: UIColor.white),
				titleStyle: TVOSButtonLabel.DefaultTitle(color: UIColor.white))
		}
	}

	open func handleStateDidChange() {
		tvosButtonStateDidChange(tvosButtonState: tvosButtonState)
		let style = tvosButtonStyleForState(tvosButtonState: tvosButtonState)
		layoutIfNeeded()
		UIView.animate(withDuration: 0.2,
		               delay: 0,
		               usingSpringWithDamping: 1,
		               initialSpringVelocity: 0,
		               options: .allowAnimatedContent,
		               animations: {
						// animate title label down because of button scales up on focus
						self.tvosTitleLabelTopConstraint?.constant = self.tvosButtonState == .Focused ? self.titleLabelPaddingYOnFocus : 0
						// handle styling
						style.applyStyle(onButton: self)
						self.layoutIfNeeded()
		},
		               completion: nil)
	}
}
