import UIKit

extension CityDetailsViewController {
    @objc(CityDetailsViewControllerView)
    internal final class View: UIView {
        private let flowLayout = UICollectionViewFlowLayout()
        private let collectionView: UICollectionView
        
        private let viewModel: CityDetailsViewModel
        
        internal init(viewModel: CityDetailsViewModel) {
            self.viewModel = viewModel
            self.collectionView = UICollectionView(frame: .main, collectionViewLayout: self.flowLayout)
            
            super.init(frame: .main)
            
            configureViews()
        }
        
        internal required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

// MARK: Configure Views
extension CityDetailsViewController.View {
    private func configureViews() {        
        [collectionView]
            .disableTranslateAutoresizingMask()
            .add(to: self)
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        viewModel.collectionAdapter.configure(collectionView)
    }
}
