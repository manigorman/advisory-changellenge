//
//  PDFViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit
import PDFKit
import SnapKit

protocol IPDFView: AnyObject {
    func configure(with model: PDFViewController.Model)
    func shouldActivityIndicatorWorking(_ flag: Bool)
}

final class PDFViewController: UIViewController {
    
    struct Model {
        let document: PDFDocument?
    }
    
    // Dependencies
    private let presenter: IPDFPresenter
    
    // UI
    private lazy var pdfView = PDFView()
    private lazy var contentView = UIView()
    private lazy var indicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initialization
    
    init(presenter: IPDFPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        setUpUI()
        setUpConstraints()
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        view.backgroundColor = BackgroundColorScheme.background
        
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
    }
    
    private func setUpConstraints() {
        view.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        contentView.addSubview(pdfView)
        pdfView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

extension PDFViewController: IPDFView {
    func configure(with model: Model) {
        guard let document = model.document else {
            return
        }
        
        self.pdfView.document = document
    }
    
    func shouldActivityIndicatorWorking(_ flag: Bool) {
        if flag {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
}
