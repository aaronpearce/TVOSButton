//
//  TVOSButtonImage.swift
//  TVOSButton
//
//  Created by Cem Olcay on 12/02/16.
//  Copyright © 2016 MovieLaLa. All rights reserved.
//

import UIKit


public enum TVOSButtonImage {
	case custom(contentMode: UIViewContentMode?, size: CGSize?, offsets: UIEdgeInsets?, cornerRadius: CGFloat?, backgroundColor: UIColor?,
		adjustsImageWhenAncestorFocused: Bool?)
	case fill(adjustsImageWhenAncestorFocused: Bool?)
	case fit

	public func getStyle() -> TVOSButtonImageStyle {
		switch self {
		case .custom(let contentMode, let size, let offsets, let cornerRadius, let backgroundColor, let adjustsImageWhenAncestorFocused):
			return TVOSButtonImageStyle(
				contentMode: contentMode,
				size: size,
				offsets: offsets,
				cornerRadius: cornerRadius,
				backgroundColor: backgroundColor,
				adjustsImageWhenAncestorFocused: adjustsImageWhenAncestorFocused)

		case .fill(let adjustsImageWhenAncestorFocused):
			return TVOSButtonImage.Custom(
				contentMode: .scaleAspectFill,
				size: nil,
				offsets: nil,
				cornerRadius: nil,
				backgroundColor: nil,
				adjustsImageWhenAncestorFocused: adjustsImageWhenAncestorFocused)
				.getStyle()

		case .fit:
			return TVOSButtonImage.Custom(
				contentMode: .scaleAspectFit,
				size: nil,
				offsets: nil,
				cornerRadius: nil,
				backgroundColor: nil,
				adjustsImageWhenAncestorFocused: false)
				.getStyle()
		}
	}

	public func applyStyle(onImageView imageView: UIImageView?) {
		guard let imageView = imageView else { return }
		let style = getStyle()
		imageView.backgroundColor = style.backgroundColor
		imageView.adjustsImageWhenAncestorFocused = style.adjustsImageWhenAncestorFocused ?? false
		imageView.layer.cornerRadius = style.cornerRadius ?? 0
		imageView.layer.masksToBounds = true
		switch self {
		case .fill(_):
			imageView.contentMode = .scaleAspectFill
		default:
			imageView.contentMode = .center
		}
	}

	public static func resetStyle(onImageView imageView: UIImageView?) {
		guard let imageView = imageView else { return }
		imageView.image = nil
		imageView.backgroundColor = nil
		imageView.layer.cornerRadius = 0
	}
}

public struct TVOSButtonImageStyle {
	public var contentMode: UIViewContentMode?
	public var size: CGSize?
	public var offsets: UIEdgeInsets?
	public var cornerRadius: CGFloat?
	public var backgroundColor: UIColor?
	public var adjustsImageWhenAncestorFocused: Bool?
}
