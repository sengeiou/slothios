//
//	Data.swift
//
//	Create by Fly on 16/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper

class ChatTarget: NSObject {
    var targetId: String?
    var targetName: String?
}

class ChatListData : NSObject, NSCoding, Mappable{

	var chatOfficialGroupVo : ChatOfficialGroupVo?
	var chatUserGroupVos : [ChatUserGroupVo]?
	var privateChatVos : [PrivateChatVo]?


	class func newInstance(map: Map) -> Mappable?{
		return ChatListData()
	}
	required init?(map: Map){}
	private override init(){}
    
    public func getChatUserGroupVo(groupId: String?) -> AnyObject?{
        guard let groupId = groupId,
              let chatUserGroupVos = chatUserGroupVos else {
              return nil
        }
        if groupId == chatOfficialGroupVo?.officialGroupUuid {
            return chatOfficialGroupVo
        }
        for group in chatUserGroupVos {
            if group.userGroupUuid == groupId{
                return group
            }
        }
        return nil
    }
    
    public func getPrivateChatVo(privateChatId: String?) -> PrivateChatVo?{
        guard let privateChatId = privateChatId,
            let privateChatVos = privateChatVos else {
                return nil
        }
        for privateChat in privateChatVos {
            if privateChat.userUuid == privateChatId ||
               privateChat.privateChatUuid == privateChatId{
                return privateChat
            }
        }
        return nil
    }
    
    public func getTargetModel(targetId: String?) -> ChatTarget?{
        if let privateChat = getPrivateChatVo(privateChatId: targetId) {
            let target = ChatTarget()
            target.targetId = privateChat.userUuid
            target.targetName = privateChat.nickname
            return target
        }
        
        if let group = getChatUserGroupVo(groupId: targetId) {
            if group.isKind(of: ChatUserGroupVo.self) {
                let userGroup = group as! ChatUserGroupVo
                let target = ChatTarget()
                target.targetId = userGroup.userGroupUuid
                target.targetName = userGroup.userGroupName
                return target
                
            }else if group.isKind(of: ChatOfficialGroupVo.self){
                let officialGroup = group as! ChatOfficialGroupVo
                let target = ChatTarget()
                target.targetId = officialGroup.officialGroupUuid
                target.targetName = officialGroup.officialGroupName
                return target
            }            
        }
        return nil
    }

	func mapping(map: Map)
	{
		chatOfficialGroupVo <- map["chatOfficialGroupVo"]
		chatUserGroupVos <- map["chatUserGroupVos"]
		privateChatVos <- map["privateChatVos"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         chatOfficialGroupVo = aDecoder.decodeObject(forKey: "chatOfficialGroupVo") as? ChatOfficialGroupVo
         chatUserGroupVos = aDecoder.decodeObject(forKey: "chatUserGroupVos") as? [ChatUserGroupVo]
         privateChatVos = aDecoder.decodeObject(forKey: "privateChatVos") as? [PrivateChatVo]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if chatOfficialGroupVo != nil{
			aCoder.encode(chatOfficialGroupVo, forKey: "chatOfficialGroupVo")
		}
		if chatUserGroupVos != nil{
			aCoder.encode(chatUserGroupVos, forKey: "chatUserGroupVos")
		}
		if privateChatVos != nil{
			aCoder.encode(privateChatVos, forKey: "privateChatVos")
		}

	}

}
