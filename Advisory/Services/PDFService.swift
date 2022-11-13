//
//  PDFService.swift
//  Advisory
//
//  Created by Igor Manakov on 13.11.2022.
//

import Foundation
import PDFKit

final class PDFService {
    func generatePDFThumbnail(of thumbnailSize: CGSize, for documentURL: URL) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentURL)
        let pdfDocumentPage = pdfDocument?.page(at: 0)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
}
