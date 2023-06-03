//
//  PresetControl.swift
//  CollectionViewCellsCustomInsertion
//
//  Created by Nikita on 03/06/2023.
//

import UIKit

final class PresetControl: UIControl {
	// MARK: - Subviews
	private(set) lazy var coverImageView: UIImageView = {
		let imageView: UIImageView = .init()
		imageView.contentMode = .scaleAspectFill
		
		return imageView
	}()
	
	private(set) lazy var orderTitleBackgroundView: UIView = {
		let view: UIView = .init(frame: .init(origin: .zero, size: .init(width: 29, height: 23)))
		view.clipsToBounds = true
		view.layer.cornerRadius = 14.5
		view.backgroundColor = .black
		
		return view
	}()
	
	private(set) lazy var orderTitleLabel: UILabel = {
		let label: UILabel = .init()
		label.font = .systemFont(ofSize: 11, weight: .bold)
		label.textColor = UIColor(red: 0.731, green: 0.731, blue: 0.738, alpha: 1)
		label.textAlignment = .center
		
		return label
	}()
	
	
	let presetIndex: Int
	
	
	// MARK: - Lifecycle
	init(frame: CGRect, presetIndex: Int) {
		self.presetIndex = presetIndex
		super.init(frame: frame)
		
		baseInit()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		setupSubviewsFrames()
	}
}

// MARK: - Layout
private extension PresetControl {
	func setupSubviewsFrames() {
		coverImageView.frame = bounds
		orderTitleBackgroundView.frame = .init(origin: .init(x: bounds.size.width - orderTitleBackgroundView.bounds.size.width + 5,
															 y: bounds.size.height - orderTitleBackgroundView.bounds.size.height + 7),
											   size: orderTitleBackgroundView.bounds.size)
		orderTitleLabel.frame = .init(origin: .init(x: bounds.size.width - orderTitleLabel.bounds.size.width - 6,
													y: bounds.size.height - orderTitleLabel.bounds.size.height - 2),
									  size: orderTitleLabel.bounds.size)
	}
}

// MARK: - Base Init
private extension PresetControl {
	func baseInit() {
		backgroundColor = .clear
		clipsToBounds = true
		layer.cornerRadius = 10
		
		addSubviews()
		setupOrderTitle(for: presetIndex)
	}
	
	func addSubviews() {
		[coverImageView, orderTitleBackgroundView, orderTitleLabel].forEach { addSubview($0) }
	}
	
	func setupOrderTitle(for index: Int) {
		orderTitleLabel.text = "\(index + 1)"
		orderTitleLabel.sizeToFit()
	}
}
