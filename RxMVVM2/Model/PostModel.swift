//
//  PostModel.swift
//  RxMVVM2
//
//  Created by Lucas Soares on 04/07/2018.
//  Copyright © 2018 Lucas Soares. All rights reserved.
//


class PostModel: Codable {
    
    var userId: Int?
    var id: Int?
    var title: String?
    var body: String?
    
    
    init (userId: Int?, id: Int?, title: String?, body: String?) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
    }
}
