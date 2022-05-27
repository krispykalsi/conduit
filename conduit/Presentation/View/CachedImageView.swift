//
//  CachedImageView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 27/05/22.
//

import UIKit

class CachedImageView: UIImageView {
    static private let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(fromUrl urlString: String, useCache: Bool = true) {
        guard let url = URL(string: urlString) else {
            debugPrint("failed to download image due to invalid url - \(urlString)")
            return
        }
        if useCache, let imageFromCache = CachedImageView.cache.object(forKey: url as NSURL) {
            self.image = imageFromCache
            return
        }
        Task.detached(priority: .userInitiated) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else { return }
                await MainActor.run { [weak self] in
                    self?.image = image
                }
            } catch {
                debugPrint(error)
            }
        }
    }
}
