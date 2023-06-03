//
//  ViewController.swift
//  CollectionViewCellsCustomInsertion
//
//  Created by Nikita on 03/06/2023.
//

import UIKit

// MARK: - Types
extension ViewController {
	struct PackModel {
		struct Constants {
			let baseWidth: CGFloat = 75
			let spaceBetweenCovers: CGFloat = 10
		}
		
		struct Preset {
			let description: String
		}
		
		let constants: Constants = .init()
		let presets: [Preset]
		let image: UIImage?
		
		var totalWidthForOpenedPack: CGFloat {
			return constants.baseWidth + (constants.baseWidth * CGFloat(presets.count)) + (CGFloat(presets.count) * (constants.spaceBetweenCovers))
		}
	}
}

final class ViewController: UIViewController {
	// MARK: - IBOutlets
	@IBOutlet weak var collectionView: UICollectionView!
	
	// MARK: - Constraints
	@IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	private let cellReuseIdentifier: String = "pack_cell"
	
	// MARK: - DataSource
	private lazy var packs: [PackModel] = {
		(0...10).compactMap { packIndex in
			let presetsCount: Int = .random(in: 2...5)
			let presets: [PackModel.Preset] = (0..<presetsCount).compactMap { .init(description: "Preset: packIndex: \(packIndex); presetIndex: \($0) ") }
			return .init(presets: presets, image: .init(named: "cover_\(packIndex)"))
		}
	}()
	
	var selectedIndexPath: IndexPath?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		baseConfigure()
	}
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		packs.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let pack: PackModel = packs[indexPath.row]
		let cell: PackCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! PackCell
		
		cell.configure(pack: pack, isSelected: indexPath == selectedIndexPath)
		
		return cell
	}
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) as? PackCell else { return }
		
		let animationDuration: TimeInterval = 0.3
		let animationOptions: UIView.AnimationOptions = [.curveLinear]
		let oldIndexPath: IndexPath? = selectedIndexPath
		selectedIndexPath = indexPath
		
		guard indexPath != oldIndexPath else {
			selectedIndexPath = nil
			UIView.animate(withDuration: animationDuration, delay: .zero, options: animationOptions) {
				cell.set(selected: false, animated: true)
				collectionView.reconfigureItems(at: [indexPath])
			} completion: { _ in
				cell.removePresetControls()
			}
			return
		}
		
		let oldSelectedCell: PackCell? = {
			guard let oldIndexPath else { return nil }
			
			return collectionView.cellForItem(at: oldIndexPath) as? PackCell
		}()
		
		collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			UIView.animate(withDuration: animationDuration, delay: .zero, options: animationOptions) {
				cell.set(selected: true, animated: true)
				oldSelectedCell?.set(selected: false, animated: true)
				collectionView.reconfigureItems(at: [indexPath, oldIndexPath].compactMap { $0 })
			}
			
			UIView.animate(withDuration: animationDuration, delay: .zero, options: animationOptions) {
				collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
			} completion: { _ in
				oldSelectedCell?.removePresetControls()
			}
		}
	}
}

extension ViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let pack = packs[indexPath.row]
		
		if selectedIndexPath == indexPath {
			return .init(width: pack.totalWidthForOpenedPack, height: collectionViewHeightConstraint.constant)
		} else {
			return .init(width: pack.constants.baseWidth, height: collectionViewHeightConstraint.constant)
		}
	}
}

// MARK: - Base configuration
private extension ViewController {
	func baseConfigure() {
		setupCollectionView()
	}
	
	func setupCollectionView() {
		collectionView.dataSource = self
		collectionView.delegate = self
		collectionView.register(PackCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
		collectionView.contentInset = .init(top: .zero, left: 16, bottom: .zero, right: 16)
	}
}
