//
//  ContentView.swift
//  GPhoto_test
//
//  Created by cin on 2021/2/1.
//

import SwiftUI
import GPhotos
import Photos


struct ContentView: View {
    @ObservedObject var photoDocument = PhotoDocument()
    
    @State var isLogin = false
    @State var photoIndex = 0
    
    var body: some View {
        VStack(spacing:20) {
            Text(isLogin ? "Logout" : "Login")
                .font(Font.system(size: 20))
                .padding()
                .background(
                    Group {
                        if !isLogin {
                            Color.gray
                        } else {
                            Color.red
                        }
                    }
                    .cornerRadius(10).opacity(0.9)
                )
                .onTapGesture {
                    if !GPhotos.isAuthorized  {
                        GPhotos.authorize() { (success, error) in
                            if let error = error { print (error.localizedDescription) }
                            if success {self.isLogin = true}
                        }
                    } else {
                        GPhotos.logout()
                        photoDocument.items.removeAll()
                        photoDocument.currentPhoto = nil
                        self.isLogin = false
                    }
                }
                .padding()
            
            Button {
                listMediaItems()
            } label: {
                Text("List all MediaItems")
            }.disabled(!photoDocument.items.isEmpty)
            
            Button {
                showListItems()
            } label: {
                Text("Show Photo")
            }.opacity(photoDocument.items.isEmpty ? 0 : 1)
            
            HStack {
                Button {
                    photoDocument.pagingPhoto(-1)

                } label: {
                    Image(systemName: "arrow.left.circle").font(.system(size: 30, weight: .regular))
                }
                
                Button {
                    photoDocument.pagingPhoto(1)
                } label: {
                    Image(systemName: "arrow.right.circle").font(.system(size: 30, weight: .regular))
                }
            }.opacity(photoDocument.items.isEmpty ? 0 : 1)
            
            Rectangle().foregroundColor(self.photoDocument.currentPhoto == nil ? .white : .black).opacity(0.9).overlay(
                Group {
                    if self.photoDocument.currentPhoto != nil {
                        Image(uiImage: self.photoDocument.currentPhoto!)
                    }
                }
            )
        }
    }
}

extension ContentView {
    func listMediaItems() {
        self.photoDocument.listMediaItems()
    }
    
    func showListItems() {
        self.photoDocument.showListItems(atInstex: 0)
    }
}



