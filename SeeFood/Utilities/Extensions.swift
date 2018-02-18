import Foundation
import UIKit

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
}

extension UIView {
    func pinFullScreen(to superView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            self.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        } else {
            self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor).isActive = true
        } else {
            self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            self.safeAreaLayoutGuide.topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            self.topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        }
        if #available(iOS 11.0, *) {
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            self.bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        }
    }
}

extension UIViewController {
    func transition(from current: UIViewController, to replacing: UIViewController, duration: TimeInterval, setup: () -> Void, animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
        current.willMove(toParentViewController: nil)
        addFullScreen(controller: replacing, animationDuration: duration, setup: setup, animation: animation) {
            current.view.removeFromSuperview()
            current.removeFromParentViewController()
            completion?()
        }
    }
    
    func addFullScreen(controller: UIViewController, animationDuration duration: TimeInterval, setup: () -> Void, animation: @escaping () -> Void, completion: (() -> Void)? = nil) {
        controller.willMove(toParentViewController: self)
        addChildViewController(controller)
        
        view.insertSubview(controller.view, at: 1)
        if #available(iOS 11.0, *) {
            controller.view.pinFullScreen(to: view)
        } else {
            // Fallback on earlier versions
        }
        setup()
        UIView.animate(withDuration: duration, animations: animation, completion: { complete in
            controller.didMove(toParentViewController: self)
            completion?()
        })
    }
    
    func displayAlertWith(title: String? = nil, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
