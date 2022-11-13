//
//  ChatViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SnapKit
import PDFKit

protocol IChatView: AnyObject {
    func configure(with model: ChatViewController.Model)
    func addMessages(with messages: [Message])
    func shouldActivityIndicatorWorking(_ flag: Bool)
}

let me = User(senderId: UserDefaults.standard.string(forKey: "UserId") ?? "", displayName: "Me")

final class ChatViewController: MessagesViewController {
    
    struct Model {
        var messages: [Message]
    }
    
    // Dependencies
    private let presenter: IChatPresenter
    
    // Private
    private var messages: [Message] = []
    
    let networkService = NetworkingService()
    
    var dialogId = UserDefaults.standard.integer(forKey: "DialogId")
    
    // UI
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
        return control
    }()
    
    private lazy var indicator = UIActivityIndicatorView(style: .large)
    
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
    
    // MARK: - Actions
    
    @objc func loadMoreMessages() {
        //        presenter.refreshMessages(timestamp: Double(messages.first!.sentDate.millisecondsSince1970), older: true)
        //        print(Double(messages.first!.sentDate.millisecondsSince1970))
    }
    
    // MARK: - Private
    
    private func setUpUI() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Advisory"
        
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
        if indexPath.section % 5 == 0 {
            return NSAttributedString(
                string: DateFormatter.ruRuLong(message.sentDate).string(from: message.sentDate),
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12),
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
    func shouldActivityIndicatorWorking(_ flag: Bool) {
        if flag {
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
        }
    }
    
    func configure(with model: Model) {
        self.messages = model.messages
        self.messages.append(Message(image: UIImage(systemName: "person.fill") ?? UIImage(),
                                     user: User(senderId: "2323223", displayName: ""),
                                     messageId: UUID().uuidString,
                                     date: Date()))
        self.messages.append(Message(linkItem: MockLinkItem(text: "Прикрепляю документ на подписание",
                                                            attributedText: nil,
                                                            url: URL(string: "http://www.pdf995.com/samples/pdf.pdf")!,
                                                            title: "Договор банка Открытие",
                                                            teaser: "",
                                                            thumbnailImage: PDFService().generatePDFThumbnail(of: CGSize(width: 120,
                                                                                                                         height: 120),
                                                                                                              for: URL(string: "http://www.pdf995.com/samples/pdf.pdf")!)!),
                                     user: User(senderId: "2323223", displayName: ""), messageId: UUID().uuidString, date: Date()))
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem()
    }
    
    func addMessages(with messages: [Message]) {
        self.messages.insert(contentsOf: messages, at: 0)
        messagesCollectionView.reloadData()
    }
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
        10
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        10
    }
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        16
    }
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        0
    }
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    @objc func inputBar(_: InputBarAccessoryView, didPressSendButtonWith _: String) {
        processInputBar(messageInputBar)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) {_, _, _ in }
        
        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = me
            if let str = component as? String {
                let message = Message(text: str, user: user, messageId: UUID().uuidString, date: Date())
                presenter.didTapSend(message: message)
                insertMessage(message)
            } else if let img = component as? UIImage {
                let message = Message(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
}

extension ChatViewController: MessageCellDelegate {
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            return
        }
        if case MessageKind.linkPreview(let item) = message.kind {
            presenter.didTapPDF(with: item.url)
        }
    }
    
    func didTapImage(in _: MessageCollectionViewCell) {
        print("Image tapped")
    }
}
