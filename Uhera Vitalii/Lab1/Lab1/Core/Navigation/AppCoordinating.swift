//
//  AppCoordinating.swift
//  Lab1
//
//  Created by UnseenHand on 19.12.2025.
//


protocol AppCoordinating: AnyObject {
    func openRepository(_ repo: Repository, developer: DeveloperProfile?)
    func openDeveloper(_ developer: DeveloperProfile)
}