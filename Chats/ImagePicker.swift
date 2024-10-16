//
//  ImagePicker.swift
//  Chats
//
//  Created by Yaroslav on 10/16/24.
//
import SwiftUI
import PhotosUI

struct ImagePicker: View {
    @Binding var shouldShowImagePicker: Bool
    @Binding var imageSelection: PhotosPickerItem?
    @Binding var uiImage: UIImage?
    
    var body: some View {
        Button {
            shouldShowImagePicker = true
        } label: {
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                    .shadow(radius: 5)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: 64))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 64).stroke(.black, lineWidth: 3))
            }
        }
        .photosPicker(isPresented: $shouldShowImagePicker, selection: $imageSelection, matching: .images)
        .onChange(of: imageSelection) { newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                    uiImage = image
                }
            }
        }
    }
}
