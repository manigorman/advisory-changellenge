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
    
    // MARK: - Initialization
    
    init(router: IPDFRouter) {
        self.router = router
    }
    
    // MARK: - Private
    
    private func downloadPDF() {
        view?.shouldActivityIndicatorWorking(true)
        DispatchQueue.global(qos: .userInteractive).async {
            let document = PDFDocument(url: URL(string: "http://www.pdf995.com/samples/pdf.pdf")!)
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
