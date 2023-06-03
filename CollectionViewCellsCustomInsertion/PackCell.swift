//
//  PackCell.swift
//  CollectionViewCellsCustomInsertion
//
//  Created by Nikita on 03/06/2023.
//

import UIKit

final class PackCell: UICollectionViewCell {
	let baseWidth: CGFloat = 75
	
	let coverImageView: UIImageView = {
		let imageView: UIImageView = .init()
		imageView.contentMode = .scaleAspectFill
		imageView.layer.masksToBounds = true
		imageView.layer.cornerRadius = 10
		imageView.layer.shadowColor = UIColor.black.cgColor
		imageView.layer.shadowOpacity = 0.8
		imageView.layer.shadowOffset = CGSize.zero
		imageView.layer.shadowRadius = 5
		
		return imageView
	}()
	
	let packCloseImageViewBackgroundView: UIView = {
		let view: UIView = .init(frame: .zero)
		view.backgroundColor = .black.withAlphaComponent(0.3)
		view.alpha = .zero
		
		return view
	}()
	
	let packCloseImageView: UIImageView = {
		let imageView: UIImageView = .init(image: .init(named: "pack_close_icon"))
		imageView.contentMode = .scaleToFill
		imageView.frame = .init(origin: .zero, size: .init(width: 40, height: 40))
		imageView.alpha = .zero
		
		return imageView
	}()
	
	private(set) var presetControls: [PresetControl] = []
	
	private(set) var currentPack: ViewController.PackModel?
	private(set) var currentWidth: CGFloat = .zero
	
	
	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		baseSetup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		coverImageView.frame = .init(origin: .zero, size: .init(width: baseWidth, height: bounds.height))
		packCloseImageViewBackgroundView.frame = coverImageView.bounds
		packCloseImageView.frame = .init(origin: .init(x: coverImageView.bounds.size.width * 0.5 - packCloseImageView.bounds.size.width * 0.5,
													   y: coverImageView.bounds.size.height * 0.5 - packCloseImageView.bounds.size.height * 0.5),
										 size: packCloseImageView.bounds.size)
	}
}

// MARK: - Selection Updating
extension PackCell {
	func set(selected: Bool, animated: Bool) {
		guard let currentPack else { return }
		
		currentWidth = selected ? currentPack.totalWidthForOpenedPack : baseWidth
		frame.size.width = currentWidth
		
		
		if selected {
			let presetControls: [PresetControl] = createPresetControlls(for: currentPack)
			
			packCloseImageViewBackgroundView.alpha = 1
			packCloseImageView.alpha = 1
			
			presetControls.forEach { presetControl in
				insertSubview(presetControl, at: .zero)
				self.presetControls.append(presetControl)
				presetControl.alpha = 1
				presetControl.frame = frame(for: presetControl)
			}
			
		} else {
			packCloseImageView.alpha = .zero
			packCloseImageViewBackgroundView.alpha = .zero
			
			presetControls.forEach { presetControl in
				presetControl.alpha = .zero
				presetControl.frame = coverImageView.frame
			}
			
		}
	}
	
	func removePresetControls() {
		presetControls.forEach { $0.removeFromSuperview() }
		presetControls = []
	}
}

// MARK: - Configuration
extension PackCell {
	var coverImage: UIImage? {
		coverImageView.image
	}
	
	func configure(pack: ViewController.PackModel, isSelected: Bool) {
		currentPack = pack
		coverImageView.image = pack.image
		set(selected: isSelected , animated: false)
	}
}

// MARK: - Main Methods
private extension PackCell {
	func createPresetControlls(for pack: ViewController.PackModel) -> [PresetControl] {
		pack.presets.enumerated().compactMap { (index, preset) in
			let control: PresetControl = .init(frame: coverImageView.frame, presetIndex: index)
			control.alpha = .zero
			control.coverImageView.image = coverImage
			control.layer.cornerRadius = coverImageView.layer.cornerRadius
			control.addTarget(self, action: #selector(presetSelected), for: .touchUpInside)
			
			return control
		}
	}
	
	func frame(for presetControl: PresetControl) -> CGRect {
		guard let currentPack else { return .zero }
		
		let coverImageViewFrame: CGRect = coverImageView.frame
		let padding: CGFloat = currentPack.constants.spaceBetweenCovers
		let index: CGFloat = CGFloat(presetControl.presetIndex)
		
		let x: CGFloat = coverImageViewFrame.maxX + (padding * (index + 1))  + (coverImageViewFrame.width * index)
		let y: CGFloat = coverImageViewFrame.minY
		let size: CGSize = coverImageViewFrame.size
		
		return .init(origin: .init(x: x, y: y), size: size)
	}
}

// MARK: - PresetControlAction
@objc private extension PackCell {
	func presetSelected(by control: PresetControl) {
		guard let preset = currentPack?.presets[control.presetIndex] else { return }
		print("Did select preset \(preset)")
	}
}

// MARK: - Base setup
private extension PackCell {
	func baseSetup() {
		clipsToBounds = true
		backgroundColor = .clear
		currentWidth = baseWidth
		addSubviews()
	}
	
	func addSubviews() {
		addSubview(coverImageView)
		coverImageView.addSubview(packCloseImageViewBackgroundView)
		coverImageView.addSubview(packCloseImageView)
	}
}
