import UIKit

internal protocol RequestLocationAccessViewDelegate: AnyObject {
    func dismiss(addLocation: Bool)
}

internal final class RequestLocationAccessView: UIView {
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    private let confirmButton = UIButton()
    private let declineButton = UIButton()
    
    private let maskLayer = CAShapeLayer()
    
    internal weak var delegate: RequestLocationAccessViewDelegate?
    
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureViews()
        
        traitCollectionDidChange(nil)
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Configure Views
extension RequestLocationAccessView {
    private func configureViews() {
        [titleLabel, messageLabel, confirmButton, declineButton]
            .disableTranslateAutoresizingMask()
            .add(to: self)
     
        layer.mask = maskLayer
        
        backgroundColor = .systemBackground
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        configureTitleLabel()
        configureMessageLabel()
        configureConfirmButton()
        configureDeclineButton()
    }
    
    private func configureTitleLabel() {
        titleLabel.text = Localization.RequestLocationAccess.title
        
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        titleLabel.pinTopToSuperview(layoutArea: .layoutMargins)
        titleLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        titleLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private func configureMessageLabel() {
        messageLabel.text = Localization.RequestLocationAccess.message
        
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        messageLabel.pin(below: titleLabel, padding: 16)
        messageLabel.pinCenterHorizontalToSuperview(layoutArea: .layoutMargins)
        messageLabel.pinEdgesHorizontalToSuperview(layoutArea: .layoutMargins, relation: .greaterThanOrEqual)
        
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)
        messageLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private func configureConfirmButton() {
        configureButton(confirmButton)
        
        confirmButton.setTitle(Localization.Buttons.addCurrentLocationTitle, for: .normal)
        
        confirmButton.pinTrailingToSuperview(layoutArea: .layoutMargins)
        confirmButton.backgroundColor = UIColor.systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
        
        confirmButton.addTarget(self, action: #selector(self.tappedConfirm(_:)), for: .touchUpInside)
    }
    
    private func configureDeclineButton() {
        configureButton(declineButton)
        
        declineButton.setTitle(Localization.Buttons.noThanksTitle, for: .normal)
        
        declineButton.pinLeadingToSuperview(layoutArea: .layoutMargins)
        
        declineButton.pinWidth(with: confirmButton)
        declineButton.pin(before: confirmButton, padding: 16)
        
        declineButton.setTitleColor(.label, for: .normal)
        
        declineButton.addTarget(self, action: #selector(self.tappedDecline(_:)), for: .touchUpInside)
    }
    
    private func configureButton(_ button: UIButton) {
        button.pin(below: messageLabel, padding: 32)
        button.pinBottomToSuperview(layoutArea: .layoutMargins)
        button.pin(height: 50)
        button.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        button.titleLabel?.numberOfLines = 2
        button.titleLabel?.textAlignment = .center
        
        button.titleEdgeInsets = UIEdgeInsets(horizontal: 5, vertical: 4)
        
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
    }
}

// MARK: Trait collection
extension RequestLocationAccessView {
    internal override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        [confirmButton.layer, declineButton.layer, layer].forEach {
            $0.borderWidth = traitCollection.pixelSize
            $0.borderColor = UIColor.separator.cgColor
        }
    }
}

// MARK: Layout subviews
extension RequestLocationAccessView {
    internal override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutMaskLayer()
    }
    
    private func layoutMaskLayer() {
        maskLayer.frame = bounds
        maskLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12)).cgPath
    }
}

// MARK: User Interaction
extension RequestLocationAccessView {
    @objc
    private func tappedConfirm(_ sender: UIButton) {
        delegate?.dismiss(addLocation: true)
    }
    
    @objc
    private func tappedDecline(_ sender: UIButton) {
        delegate?.dismiss(addLocation: false)
    }
}
