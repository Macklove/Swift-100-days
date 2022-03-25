import UIKit

class DetailVieViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var selectedImgIndex:String?
    var imageCount:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(selectedImage != nil, "Unselected.")
        title = "\(selectedImgIndex!) / \(imageCount!)"
        navigationItem.largeTitleDisplayMode = .never
        if let imageToLoad=selectedImage{
            imageView.image=UIImage(named: imageToLoad)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
}
