//
//  PDFViewerPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit
import PDFKit

protocol IPDFPresenter: AnyObject {
    func viewDidLoad()
}

final class PDFPresenter {
    
    // Dependencies
    private let router: IPDFRouter
    weak var view: IPDFView?
    
    // Private
    private let url: URL
    
    // MARK: - Initialization
    
    init(router: IPDFRouter, url: URL) {
        self.router = router
        self.url = url
    }
    
    // MARK: - Private
    
    private func downloadPDF() {
        view?.shouldActivityIndicatorWorking(true)
        DispatchQueue.global(qos: .userInteractive).async {
            let document = PDFDocument(url: self.url)
            DispatchQueue.main.async {
                self.view?.configure(with: .init(document: document))
                self.view?.shouldActivityIndicatorWorking(false)
            }
        }
    }
}

// MARK: - IConversationPresenter

extension PDFPresenter: IPDFPresenter {
    func viewDidLoad() {
        downloadPDF()
    }
}
