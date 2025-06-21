//
//  AppController.swift
//  ImageConverter
//
//  Created by Dhruva Kumar on 6/21/25.
//


import Foundation
import Combine

class AppController: ObservableObject {
    let droppedFilesSubject = PassthroughSubject<[URL], Never>()
}