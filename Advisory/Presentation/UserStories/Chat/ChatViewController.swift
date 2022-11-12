//
//  ChatViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import PDFKit

protocol IChatView: AnyObject {
    
}

let advisor = User(senderId: "1", displayName: "Advisor")
let me = User(senderId: "0", displayName: "Me")

func generatePDFThumbnail(of thumbnailSize: CGSize, for documentURL: URL) -> UIImage? {
    let pdfDocument = PDFDocument(url: documentURL)
    let pdfDocumentPage = pdfDocument?.page(at: 0)
    return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
}

final class ChatViewController: MessagesViewController {
    
    // Dependencies
    private let presenter: IChatPresenter
    
    // Private
    private var messages: [Message] = [.init(text: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz",
                                             user: advisor,
                                             messageId: "1",
                                             date: Date(timeIntervalSince1970: 1662979536)),
                                       .init(text: "Привет! Закупай AAPl!авыфоафыораолролфывроларлофыроарлоыраловыфр",
                                             user: advisor,
                                             messageId: "1",
                                             date: Date(timeIntervalSince1970: 1667386012)),
                                       .init(text: "Привет! Закупай AAPl!авыфоафыораолролфывроларлофыроарлоыраловыфр",
                                             user: advisor,
                                             messageId: "1",
                                             date: Date()),
                                       .init(text: "Здарова! Ну что там с деньгами? АААААаааааа?",
                                             user: me,
                                             messageId: "2",
                                             date: Date(timeIntervalSince1970: 1668187979)),
                                       .init(linkItem: MockLinkItem(text: "Привет! Прикрепляю документ на подписание, это договор на наше взаимодействие.",
                                                                    attributedText: nil,
                                                                    url: URL(string: "https://www.africau.edu/images/default/sample.pdf")!,
                                                                    title: "Документ на подпись",
                                                                    teaser: "10,9 MB",
                                                                    thumbnailImage: generatePDFThumbnail(of: CGSize(width: 100, height: 100),
                                                                                                         for: URL(string: "https://www.africau.edu/images/default/sample.pdf")!)!),
                                             user: advisor, messageId: "323", date: Date()),
                                       .init(image: UIImage(systemName: "person.fill")!, user: advisor, messageId: "12891", date: Date())
//                                       .init(custom: [:], user: advisor, messageId: "23903", date: Date())
    ]
    
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    // UI
    
    // MARK: - Initialization
    
    init(presenter: IChatPresenter) {
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
        setUpDelegates()
        
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    let networkService = NetworkingService()
    
    var dialogId = -1
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            do {
                
                let auth = try await networkService.authorize(model: AuthenticationRequestNetworkModel(login: "iceland", password: "iceland_395"))
                print(auth)
                let dialogModel = try await networkService.getDialog()
                print(dialogModel)
                await MainActor.run {
                    self.dialogId = dialogModel.dialogId
                }
                
                print(self.dialogId)
                
                var params: [String: String] = [:]
                
                params["dialogId"] = String(self.dialogId)
                
                let model = try await networkService.getMessages(model: .init(dialogId: self.dialogId, limit: nil), params: params)
                print(model)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let msg = MessageNetworkModel(
//            dialogId: 1,
//            text: "Привет всем участникам Hack & Change!",
//            messageType: .widget,
//            data: "{\"widget\":\"custom data\"}",
//            mediaUrl: "https://cdn-icons-png.flaticon.com/512/945/945244.png"
//        )
//        _ = SendMessageRequestNetworkModel(message: msg)
//
//        Task {
//            do {
//                let requestModel = AuthenticationRequestNetworkModel(
//                    login: "iceland",
//                    password: "iceland_395"
//                )
//                let authResponse = try await networkService.authorize(model: requestModel)
//                print(authResponse.jwtToken)
//
//                // swiftlint:disable line_length
//                await networkService.changeToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwMDUwMCwibG9naW4iOiJ0ZXN0VXNlciIsInJvbGUiOiJDTElFTlQiLCJpYXQiOjE2NjgyNzI2MzZ9.eiK8FU0ApZAWpn1KUkr2Pj-yuq4JdC7uZ8KzskJdGpc")
//
//                foo()
//
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//     }
    
    @MainActor
    func foo() {
        
    }
    
    // MARK: - Actions
    
    @objc
    func loadMoreMessages() {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 1) {
            //        SampleData.shared.getMessages(count: 20) { messages in
            //          DispatchQueue.main.async {
            //            self.messageList.insert(contentsOf: messages, at: 0)
            //            self.messagesCollectionView.reloadDataAndKeepOffset()
            //            self.refreshControl.endRefreshing()
            //          }
            //        }
        }
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Центр заботы о клиентах"
        
        view.backgroundColor = BackgroundColorScheme.background
        messagesCollectionView.backgroundColor = BackgroundColorScheme.background
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        }
    }
    
    private func setUpDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }
    
    func configureMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnKeyboardFrameChanged = true
        showMessageTimestampOnSwipeLeft = true
        
        messagesCollectionView.refreshControl = refreshControl
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        messageInputBar.inputTextView.tintColor = TextColorScheme.foreground
        messageInputBar.sendButton.setTitleColor(ApplicationColorScheme.accent, for: .normal)
        messageInputBar.sendButton.setTitleColor(
            ApplicationColorScheme.accent.withAlphaComponent(0.3),
            for: .highlighted)
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(
                string: DateFormatter.ruRuLong(message.sentDate).string(from: message.sentDate),
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func insertMessage(_ message: Message) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func messageTimestampLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let messageDate = message.sentDate
        let dateString = DateFormatter.mediumFormatter.string(from: messageDate)
        return NSAttributedString(string: dateString, attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

// MARK: - IConversationView

extension ChatViewController: IChatView {
    
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return me
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
    
//    func customCell(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UICollectionViewCell {
//        return UICollectionViewCell(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
//    }
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? ApplicationColorScheme.fixedWhite : TextColorScheme.foreground
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        isFromCurrentSender(message: message) ? ApplicationColorScheme.accent : BackgroundColorScheme.background2
    }
    
    func messageStyle(for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> MessageStyle {
        switch message.kind {
        case .custom:
            return .none
        default:
            let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
            return .bubbleTail(tail, .curved)
        }
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        16
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    // MARK: Internal
    
    @objc
    func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { _, range, _ in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    // MARK: Private
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = me
            if let str = component as? String {
                let message = Message(text: str, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = Message(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapAvatar(in _: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in _: MessageCollectionViewCell) {
        print("Message tapped")
        presenter.didTapPDF()
    }
    
    func didTapImage(in _: MessageCollectionViewCell) {
        print("Image tapped")
    }
    
    func didTapCellTopLabel(in _: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in _: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in _: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in _: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapAccessoryView(in _: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}
