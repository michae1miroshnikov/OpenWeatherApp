//
//  Custom Share Sheet.swift
//  NewApp
//
//  Created by Michael Miroshnikov on 06/03/2025.
//

import SwiftUI

struct CustomShareSheet: View {
    var shareText: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Share Via")
                .font(.title)
                .bold()
                .padding(.top)
            
            Button(action: {
                shareToTelegram()
            }) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Telegram")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: {
                shareToWhatsApp()
            }) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("WhatsApp")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            
            Button(action: {
                shareToSystem()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Other Apps")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
    }
    
    private func shareToTelegram() {
        if let url = URL(string: "tg://msg?text=\(shareText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func shareToWhatsApp() {
        if let url = URL(string: "whatsapp://send?text=\(shareText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func shareToSystem() {
        let activityViewController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}
