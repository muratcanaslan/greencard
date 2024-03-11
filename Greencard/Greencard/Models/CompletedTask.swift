//
//  CompletedTask.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 7.03.2024.
//

import Foundation

struct CompletedTaskResponse: Codable {
    let status: Int?
    let data: CompletedTaskData?
}

struct CompletedTaskData: Codable {
    let completedAt: Int?
    let createdAt: Int?
    let image: String?
    let processedAt: Int?
    let progress: Int?
    let returnType: Int?
    let state: Int?
    let stateDetail: String?
    let taskId: String?
    let timeElapsed: Int?

    enum CodingKeys: String, CodingKey {
        case completedAt = "completed_at"
        case createdAt = "created_at"
        case image
        case processedAt = "processed_at"
        case progress
        case returnType = "return_type"
        case state
        case stateDetail = "state_detail"
        case taskId = "task_id"
        case timeElapsed = "time_elapsed"
    }
}
