//
//  FromWebViewController.swift
//  SKPhotoBrowserExample
//
//  Created by suzuki_keishi on 2015/10/06.
//  Copyright © 2015 suzuki_keishi. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import SDWebImage

class FromWebViewController: UIViewController {
    var images = [SKPhotoProtocol]()
    
    //https://s1.ax1x.com/2020/10/12/0WPV9H.gif
    //https://att.colg.cn/forum/202010/14/000050yeeiae1jo2s24wza.jpg/ori_jpg
    //https://att.colg.cn/forum/202010/14/155758h35jw90rwwj3bxf0.jpg/ori_jpg
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKCache.sharedCache.imageCache = CustomImageCache()
    }
    
    @IBAction func pushButton(_ sender: AnyObject) {
        let browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(0)
        browser.delegate = self
        
        present(browser, animated: true, completion: nil)
    }
}

// MARK: - SKPhotoBrowserDelegate

extension FromWebViewController: SKPhotoBrowserDelegate {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
    
    func didShowPhotoAtIndex(_ browser: SKPhotoBrowser, index: Int) {
        browser.downloadActionClosure = { photo in
            debugPrint(photo)
        }
    }
}

// MARK: - private

private extension FromWebViewController {
    func createWebPhotos() -> [SKPhotoProtocol] {
        let arrar = ["https://att.colg.cn/forum/202010/14/000050yeeiae1jo2s24wza.jpg/ori_jpg",
        "https://att.colg.cn/forum/202010/14/155758h35jw90rwwj3bxf0.jpg/ori_jpg",
        "https://s1.ax1x.com/2020/10/12/0WPV9H.gif"]
        
        return (0..<3).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImageURL(arrar[i])
//            photo.caption = caption[i%10]
            photo.shouldCachePhotoURLImage = true
            return photo
        }
    }
}

class CustomImageCache: SKImageCacheable {
    var cache: SDImageCache
    
    init() {
        let cache = SDImageCache(namespace: "com.suzuki.custom.cache")
        self.cache = cache
    }

    func imageForKey(_ key: String) -> UIImage? {
        guard let image = cache.imageFromDiskCache(forKey: key) else { return nil }
        
        return image
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.store(image, forKey: key)
    }

    func removeImageForKey(_ key: String) {}
    
    func removeAllImages() {}
    
}
