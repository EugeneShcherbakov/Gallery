import UIKit

protocol DataEnteredDelegate: class {
    func imageInfo(imageUrl: NSURL, imageName: String, dateOfCreation: String, camera: String)
}
class AddController: UIViewController {
    
    weak var delegate: DataEnteredDelegate? = nil
    @IBOutlet weak var iView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var cameraTF: UITextField!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    var imageUrl: NSURL?
    var data: NSData? = nil
    
    @IBAction func addBtn(_ sender: Any) {
        
        showImagePickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        delegate?.imageInfo(imageUrl: imageUrl!, imageName: nameTF.text ?? "", dateOfCreation: dateTF.text ?? "", camera: cameraTF.text ?? "")
        
        navigationController?.popViewController(animated: true)
    }
}

extension AddController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let iUrl = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.imageURL.rawValue)] {
            
            imageUrl = iUrl as? NSURL
            
            if let imageUrl = imageUrl {
                doneBtn.isEnabled = true
                data = NSData(contentsOf: imageUrl as URL)
                self.iView.image = UIImage(data: data! as Data)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
