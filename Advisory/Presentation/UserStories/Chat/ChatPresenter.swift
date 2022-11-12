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
                
                let model = try await networkingService.getMessages(model: .init(dialogId: 11, limit: nil))
                print(model)
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

                var s = ""
                switch message.kind {
                case .text(let str):
                    print(str)
                    s = str
                default:
                    break
                }

                let dialogModel = try await networkingService.sendMessage(model: .init(message: .init(dialogId: 11,
                                                                                                      text: s,
                                                                                                      messageType: .text,
                                                                                                      data: nil,
                                                                                                      mediaUrl: nil)))
                print("======", dialogModel)

                let model = try await networkingService.getMessages(model: .init(dialogId: dialogId, limit: 20))
                print(model)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
