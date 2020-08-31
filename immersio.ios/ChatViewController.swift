//
//  ViewController.swift
//  immersio.ios
//
//  Created by Rohan Garg on 2020-08-23.
//  Copyright © 2020 Immersio. All rights reserved.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore
import SDWebImage

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {


//    var currentUser: User = Auth.auth().currentUser!
    
    var user2Name: String?
    var user2ImgUrl: String?
    var user2UID: String?
    let baseUrl: String = "http://157.230.198.98:8000/api"
    
    private var docReference: DocumentReference?
//    let chat = Chat()
    var messages: [Message] = []
    
    var authToken: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        generateToken()
        self.title = user2Name ?? "Chat"

        navigationItem.largeTitleDisplayMode = .never
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
    }
    

    
    // MARK: - Custom messages handlers
    func generateToken(){
        let json: [String: Any] = ["username":"me", "password": "admin"]
        let jsonRequest = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: baseUrl + "/auth")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonRequest
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.authToken = responseJSON["access_token"] as! String?
                self.loadChat()
            }
        }

        task.resume()
        
    }
    
    func createNewChat() {
//        let users = [self.currentUser.uid, self.user2UID]
//         let data: [String: Any] = [
//             "users":users
//         ]
//
//         let db = Firestore.firestore().collection("Chats")
//         db.addDocument(data: data) { (error) in
//             if let error = error {
//                 print("Unable to create chat! \(error)")
//                 return
//             } else {
//                 self.loadChat()
//             }
//         }
    }
    
    func parseMessageHistory(messages: [[String: Any]]){
        var cleanedMessagedList = [[String: Any]]()
        for message_event in messages{
            if((message_event["event"] as? String == "user" ) || (message_event["event"] as? String == "bot")){
                cleanedMessagedList.append(message_event)
                var senderId = "user"
                var senderName = "bot"
                if(message_event["event"] as? String == "bot"){
                    senderId = "bot"
                    senderName = "user"
                }
                self.messages.append(Message.init(id: "N/A", content: message_event["text"] as! String, created:  message_event["timestamp"] as! TimeInterval, senderID: senderId, senderName: senderName))
                self.messagesCollectionView.reloadData()

                DispatchQueue.main.async {
                           self.messagesCollectionView.scrollToBottom(animated: true)
                }
               
            }
            
        }
        print(self.messages)
        
    }
    
    func loadChat() {
        //provide chat endpoint
        let CONVERSATION_PATH = "/conversations"
        let chatId = "/755b691c5df149de92c78d0dcbee7c8a"
        let MESSAGE_PATH = "/messages"
        //Fetch all the chats which has current user in it
        
        let url = URL(string: baseUrl + CONVERSATION_PATH + chatId + MESSAGE_PATH )!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(("Bearer " + self.authToken!), forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                self.parseMessageHistory(messages: responseJSON["events"] as! [[String : Any]])
            }
        }
        task.resume()
       

        
    }
    
    
    private func insertNewMessage(_ message: Message) {
        
        messages.append(message)
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
            
        })
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
            func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

                let message = Message(id: UUID().uuidString, content: text, created: TimeInterval.init(), senderID: "test", senderName: "currentUser.displayName!")

                messages.append(message)
                  insertNewMessage(message)
                  save(message)

                  inputBar.inputTextView.text = ""
                  messagesCollectionView.reloadData()
                  messagesCollectionView.scrollToBottom(animated: true)
            }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        
        return Sender(id: Auth.auth().currentUser!.uid, displayName: Auth.auth().currentUser?.displayName ?? "Name not found")
        
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
        
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue: .lightGray
    }

    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
//        if message.sender.senderId == currentUser.uid {
//            SDWebImageManager.shared.loadImage(with: currentUser.photoURL, options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
//        } else {
//            SDWebImageManager.shared.loadImage(with: URL(string: user2ImgUrl!), options: .highPriority, progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
//                avatarView.image = image
//            }
//        }
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {

        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)

    }
    
}
