//
//  ChatViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit
import MessageKit
import InputBarAccessoryView

protocol IChatView: AnyObject {
    
}

let advisor = User(senderId: "1", displayName: "Advisor Михаил")
let me = User(senderId: "0", displayName: "Me")

final class ChatViewController: MessagesViewController {
    
    // Dependencies
    private let presenter: IChatPresenter
    
    // Private
    
    private var messages: [Message] = [.init(text: "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz",
                                             user: advisor,
                                             messageId: "1",
                                             date: Date(timeIntervalSince1970: 1668019840)),
                                       .init(text: "Привет! Закупай AAPl!авыфоафыораолролфывроларлофыроарлоыраловыфр",
                                             user: advisor,
                                             messageId: "1",
                                             date: Date(timeIntervalSince1970: 1668210669)),
                                       .init(text: "Привет! Закупай AAPl!авыфоафыораолролфывроларлофыроарлоыраловыфр",
                                             user: advisor,
                                             messageId: "1",
                                             date: Date()),
                                       .init(text: "Здарова! Ну что там с деньгами? АААААаааааа?",
                                             user: me,
                                             messageId: "2",
                                             date: Date(timeIntervalSince1970: 1668187979))]
    
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
        setUpConstraints()
        setUpDelegates()
        
        configureMessageCollectionView()
        configureMessageInputBar()
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
    
    private func setUpConstraints() {
        
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

      scrollsToLastItemOnKeyboardBeginsEditing = true // default false
//      maintainPositionOnInputBarHeightChanged = true // default false
      showMessageTimestampOnSwipeLeft = true // default false

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
                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                attributes: [
                    NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                    NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    //    func messageTopLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
    //        if !isFromCurrentSender(message: message) {
    //            let name = message.sender.displayName
    //            return NSAttributedString(
    //                string: name,
    //                attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    //        }
    //        return nil
    //    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at _: IndexPath) -> NSAttributedString? {
        let dateString = DateFormatter.mediumFormatter.string(from: message.sentDate)
        return NSAttributedString(
            string: dateString,
            attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
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
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(tail, .curved)
    }
    
    //    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at _: IndexPath, in _: MessagesCollectionView) {
    //      let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
    //      avatarView.set(avatar: avatar)
    //    }
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        18
    }
    
    func cellBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        17
    }
    
    func messageTopLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
        20
    }
    
    func messageBottomLabelHeight(for _: MessageType, at _: IndexPath, in _: MessagesCollectionView) -> CGFloat {
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

//  func didTapPlayButton(in cell: AudioMessageCell) {
//    guard
//      let indexPath = messagesCollectionView.indexPath(for: cell),
//      let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView)
//    else {
//      print("Failed to identify message when audio cell receive tap gesture")
//      return
//    }
//    guard audioController.state != .stopped else {
      // There is no audio sound playing - prepare to start playing for given audio message
//      audioController.playSound(for: message, in: cell)
//      return
//    }
//    if audioController.playingMessage?.messageId == message.messageId {
      // tap occur in the current cell that is playing audio sound
//      if audioController.state == .playing {
//        audioController.pauseSound(for: message, in: cell)
//      } else {
//        audioController.resumeSound()
//      }
//    } else {
      // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
//      audioController.stopAnyOngoingPlaying()
//      audioController.playSound(for: message, in: cell)
//    }
//  }

  func didStartAudio(in _: AudioMessageCell) {
    print("Did start playing audio sound")
  }

  func didPauseAudio(in _: AudioMessageCell) {
    print("Did pause audio sound")
  }

  func didStopAudio(in _: AudioMessageCell) {
    print("Did stop audio sound")
  }

  func didTapAccessoryView(in _: MessageCollectionViewCell) {
    print("Accessory view tapped")
  }
}
