//
//  ChatPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol IChatPresenter: AnyObject {
    func viewDidLoad()
    func didTapPDF(with url: URL)
    func didTapSend(message: Message)
    func refreshMessages(timestamp: Double, older: Bool)
}

final class ChatPresenter {
    
    // Dependencies
    private let router: IChatRouter
    private let networkingService: NetworkingService
    private let pdfService: PDFService
    
    weak var view: IChatView?
    
    // UI
    
    // Private
    private var dialogId = UserDefaults.standard.integer(forKey: "DialogId")
    
    // MARK: - Initialization
    
    init(router: IChatRouter,
         networkingService: NetworkingService,
         pdfService: PDFService) {
        self.router = router
        self.networkingService = networkingService
        self.pdfService = pdfService
    }
    
    // MARK: - Private
    
    private func fetchMessages() {
        view?.shouldActivityIndicatorWorking(true)
        
        Task {
            do {
                var params: [String: String] = [:]
                
                params["dialogId"] = String(self.dialogId)
                
                let model = try await networkingService.getMessages(model: .init(dialogId: self.dialogId, limit: nil), params: params)
                
                await MainActor.run {
                    
                    view?.shouldActivityIndicatorWorking(false)
                    
                    self.view?.configure(with: .init(messages: model.messages.map {
                        print($0.messageType)
                        switch $0.messageType {
                        case .text:
                            return Message(text: $0.text,
                                           user: User(senderId: String($0.sender), displayName: String($0.sender)),
                                           messageId: $0.messageId,
                                           date: Date(milliseconds: $0.timestamp))
                        case .media:
                            let url = URL(string: $0.mediaUrl!)!
                            let data = try? Data(contentsOf: url)
                            return Message(image: UIImage(data: data!)!,
                                           user: User(senderId: "23424", displayName: ""),
                                           messageId: $0.messageId,
                                           date: Date(milliseconds: $0.timestamp))
                        default:
                            return Message(text: $0.text,
                                           user: User(senderId: String($0.sender), displayName: String($0.sender)),
                                           messageId: $0.messageId,
                                           date: Date(milliseconds: $0.timestamp))
                        }
                    }.sorted(by: {
                        $0.sentDate < $1.sentDate
                    })))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - IConversationPresenter

extension ChatPresenter: IChatPresenter {
    func viewDidLoad() {
        Task {
            do {
                let dialogModel = try await networkingService.getDialog()
                
                await MainActor.run {
                    self.dialogId = dialogModel.dialogId
                    UserDefaults.standard.set(String(dialogModel.dialogId), forKey: "DialogId")
                }
                
                fetchMessages()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapPDF(with url: URL) {
        router.showPDF(with: url)
    }
    
    func didTapSend(message: Message) {
        Task {
            do {
                
                switch message.kind {
                case .text(let text):
                    _ = try await networkingService.sendMessage(model: .init(message: .init(dialogId: dialogId,
                                                                                            text: text,
                                                                                            messageType: .text,
                                                                                            data: nil,
                                                                                            mediaUrl: nil)))
                default:
                    break
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func refreshMessages(timestamp: Double, older: Bool) {
        Task {
            do {
                var params: [String: String] = [:]
                
                params["dialogId"] = String(self.dialogId)
                params["older"] = older ? "TRUE" : "FALSE"
                
                let model = try await networkingService.getMessages(model: .init(dialogId: self.dialogId, limit: nil), params: params)
                
                await MainActor.run {
                    self.view?.addMessages(with: model.messages.map {
                        return Message(text: $0.text,
                                       user: User(senderId: String($0.sender), displayName: String($0.sender)),
                                       messageId: $0.messageId,
                                       date: Date(milliseconds: $0.timestamp))
                    }.sorted(by: {
                        $0.sentDate < $1.sentDate
                    }))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
