//
//  TVOSButtonText.swift
//  TVOSButton
//
//  Created by Cem Olcay on 12/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit

// MARK: TVOSButtonLabel

public enum TVOSButtonLabel {
	case custom(color: UIColor?, font: UIFont?, alignment: NSTextAlignment?, shadow: TVOSButtonShadow?)
	case defaultText(color: UIColor?)
	case defaultTitle(color: UIColor?)

	public func getStyle() -> TVOSButtonLabelStyle {
		switch self {
		case .custom(let color, let font, let alignment, let shadow):
			return TVOSButtonLabelStyle(
				color: color,
				font: font,
				alignment: alignment,
				shadow: shadow)

		case .defaultText(let color):
			return TVOSButtonLabel.custom(
				color: color,
				font: nil,
				alignment: nil,
				shadow: nil)
				.getStyle()

		case .defaultTitle(let color):
			return TVOSButtonLabel.custom(
				color: color,
				font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.caption1),
				alignment: nil,
				shadow: TVOSButtonShadow.titleLabel)
				.getStyle()
		}
	}

	public func applyStyle(onLabel label: UILabel?) {
		guard let label = label else { return }
		let style = getStyle()
		style.shadow?.applyStyle(onLayer: label.layer)
		label.textColor = style.color ?? UIColor.white
		label.font = style.font ?? UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
		label.textAlignment = style.alignment ?? .center
	}

	public static func resetStyle(onLabel label: UILabel?) {
		guard let label = label else { return }
		TVOSButtonShadow.resetStyle(onLayer: label.layer)
		label.textColor = UIColor.white
		label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
		label.textAlignment = .center
	}
}

// MARK: - TVOSButtonLabelStyle

public struct TVOSButtonLabelStyle {
	public var color: UIColor?
	public var font: UIFont?
	public var alignment: NSTextAlignment?
	public var shadow: TVOSButtonShadow?
}
