import MapKit

internal final class CityAnnotationView: MKAnnotationView {
    internal static let identifier = "CityAnnotationView"
    
    private let backgroundShapeLayer = CAShapeLayer()
    private let activityIndicatorView = UIActivityIndicatorView(style: .medium)
    private let weatherIconView = UIImageView()
    
    internal override var annotation: MKAnnotation? {
        didSet {
            (oldValue as? HomeViewMapAnnotation)?.delegate = nil
            updatedAnnotation()
        }
    }
    
    internal override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        configureViews()
        
        traitCollectionDidChange(nil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
extension CityAnnotationView {
    private func configureViews() {
        disableTranslateAutoresizingMask()
        pin(size: CGSize(width: 35, height: 52))
        
        layer.addSublayer(backgroundShapeLayer)
        
        [activityIndicatorView, weatherIconView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureLayer()
        configureActivityIndicatorView()
        configureWeatherIconView()
    }
    
    private func configureLayer() {
        layer.shouldRasterize = true
        
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
    }
    
    private func configureActivityIndicatorView() {
        activityIndicatorView.pinCenterHorizontalToSuperview()
        activityIndicatorView.pinTopToSuperview(padding: 3)
        activityIndicatorView.color = .systemBackground
    }
    
    private func configureWeatherIconView() {
        weatherIconView.pin(singleSize: 25)
        weatherIconView.contentMode = .scaleAspectFit
        weatherIconView.pinCenterHorizontalToSuperview()
        weatherIconView.pinTopToSuperview(padding: 3)
        
        weatherIconView.layer.shadowRadius = 5
        weatherIconView.layer.shadowOpacity = 1
    }
}

// MARK: Layout Views
extension CityAnnotationView {
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutBackgroundShapeLayer()
        
        layer.shadowPath = backgroundPath().cgPath
    }
    
    private func layoutBackgroundShapeLayer() {
        backgroundShapeLayer.frame = bounds
        backgroundShapeLayer.path = backgroundPath().cgPath
    }
    
    private func backgroundPath() -> UIBezierPath {
        let path = UIBezierPath()
        let width = bounds.width
        let halfWidth = width / 2
        let height = bounds.height
        
        path.lineJoinStyle = .round
        
        path.move(to: CGPoint(x: width, y: halfWidth))
        path.addQuadCurve(to: CGPoint(x: halfWidth, y: height), controlPoint: CGPoint(x: 0.9 * width, y: 0.5 * height))
        path.addQuadCurve(to: CGPoint(x: 0, y: halfWidth), controlPoint: CGPoint(x: 0.1 * width, y: 0.5 * height))
        path.addArc(withCenter: CGPoint(x: halfWidth, y: halfWidth), radius: halfWidth, startAngle: .pi, endAngle: 2 * .pi, clockwise: true)
        path.close()
        
        return path
    }
}

// MARK: Trait Collection
extension CityAnnotationView {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        layer.rasterizationScale = traitCollection.safeDisplayScale
        layer.shadowColor = UIColor(light: .black, dark: .white).cgColor
        
        backgroundShapeLayer.lineWidth = traitCollection.pixelSize
        
        backgroundShapeLayer.fillColor = UIColor(light: .white, dark: .black).withAlphaComponent(0.7).cgColor
        backgroundShapeLayer.strokeColor = UIColor(light: .black, dark: .white).withAlphaComponent(0.2).cgColor
        
        weatherIconView.layer.shadowColor = UIColor(light: UIColor(white: 0.2, alpha: 0.7), dark: .white).cgColor
    }
}

// MARK: HomeViewMapAnnotationDelegate
extension CityAnnotationView: HomeViewMapAnnotationDelegate {
    internal func weatherUpdated(annotation: HomeViewMapAnnotation) {
        guard annotation === self.annotation else {
            return
        }
        
        updatedAnnotation()
    }
}

// MARK: Misc
extension CityAnnotationView {
    internal override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherIconView.image = nil
        activityIndicatorView.stopAnimating()
    }
    
    private func updatedAnnotation() {
        guard let annotation = annotation as? HomeViewMapAnnotation else {
            return
        }
        
        annotation.delegate = self
        
        if let weather = annotation.weather?.weather.first {
            let symbolName = WeatherIdToSymbolHelper.symbolName(for: weather.id, isDayTime: true)
            
            weatherIconView.isHidden = false
            weatherIconView.image = UIImage(systemName: symbolName)
            
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        } else {
            weatherIconView.isHidden = true
            
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }
    }
}
