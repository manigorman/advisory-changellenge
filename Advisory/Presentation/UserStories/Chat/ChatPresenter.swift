//
//  ChatPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol IChatPresenter: AnyObject {
    func viewDidLoad()
    func didTapPDF()
    func didTapSend(message: Message)
}

final class ChatPresenter {
    
    // Dependencies
    private let router: IChatRouter
    private let networkingService: NetworkingService
    
    weak var view: IChatView?
    
    // UI
    
    // Private
    private var dialogId = 0
    
    // MARK: - Initialization
    
    init(router: IChatRouter,
         networkingService: NetworkingService) {
        self.router = router
        self.networkingService = networkingService
    }
    
    private func fetchMessages() {
        Task {
                   do {
                       print(self.dialogId)
                       
                       var params: [String: String] = [:]
                       
                       params["dialogId"] = String(self.dialogId)
                       
                       let model = try await networkingService.getMessages(model: .init(dialogId: self.dialogId, limit: nil), params: params)
                       print(model)
                       
                       await MainActor.run {
                           self.view?.configure(with: .init(messages: model.messages.map {
                               Message(text: $0.text,
                                       user: User(senderId: String($0.sender), displayName: String($0.sender)),
                                       messageId: $0.messageId,
                                       date: Date(timeIntervalSince1970: $0.timestamp))
                           }))
                       }
                   } catch {
                       print(error.localizedDescription)
                   }
               }
    }
}

// IConversationPresenter

extension ChatPresenter: IChatPresenter {
    func viewDidLoad() {
        Task {
            do {
                let dialogModel = try await networkingService.getDialog()
                
                await MainActor.run {
                    self.dialogId = dialogModel.dialogId
                }
                
                fetchMessages()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func didTapPDF() {
        router.showPDF()
    }
    
    func didTapSend(message: Message) {
        Task {
            do {
                guard case let .text(text) = message.kind else {
                    return
                }
                
                let dialogModel = try await networkingService.sendMessage(model: .init(message: .init(dialogId: dialogId,
                                                                                                      text: text,
                                                                                                      messageType: .text,
                                                                                                      data: nil,
                                                                                                      mediaUrl: nil)))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
