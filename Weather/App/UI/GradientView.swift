import UIKit

internal final class GradientView: UIView {
    internal override class var layerClass: AnyClass { CAGradientLayer.classForCoder() }
    
    private var gradientLayer: CAGradientLayer? { layer as? CAGradientLayer }
    
    internal var colors: [UIColor] = [] {
        didSet { updateGradientColors() }
    }
    
    internal var locations: [NSNumber] = [] {
        didSet { gradientLayer?.locations = locations }
    }
    
    internal var startPoint: CGPoint = .zero {
        didSet { gradientLayer?.startPoint = startPoint }
    }
    
    internal var endPoint: CGPoint = .zero {
        didSet { gradientLayer?.endPoint = endPoint }
    }
    
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        updateGradientColors()
    }
    
    private func updateGradientColors() {
        gradientLayer?.colors = colors.map { $0.resolvedColor(with: traitCollection).cgColor }
    }
}
