//
//  Task.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import Foundation

struct TaskResponse: Codable {
    let status: Int?
    let data: TaskData?
}

struct TaskData: Codable {
    let createdAt: Int?
    let processedAt: Int?
    let progress: Int?
    let state: Int?
    let stateDetail: String?
    let taskId: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case processedAt = "processed_at"
        case progress
        case state
        case stateDetail = "state_detail"
        case taskId = "task_id"
    }
}
