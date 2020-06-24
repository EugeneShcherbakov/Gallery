import UIKit

class InfoController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageList: Image? = nil
    var imageDList: DownloadedImage? = nil
    var data: NSData?
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let il = imageList {
            imageView.image = UIImage(named: il.imageName)
        } else if let idl = imageDList {
            data = NSData(contentsOf: idl.urlImage as URL)
            imageView.image = UIImage(data: data! as Data)
        }
    }
}

extension InfoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        var category = ""
        var date = ""
        var camera = ""
        
        cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath)
        
        if let il = imageList {
            category = il.categoryName
            date = il.dateOfCreation
            camera = il.cameraModel
        } else if let idl = imageDList {
            category = "Downloaded"
            date = idl.dateDImage
            camera = idl.cameraDImage
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Category"
            cell.detailTextLabel?.text = category
        case 1:
            cell.textLabel?.text = "Date of creation"
            cell.detailTextLabel?.text = date
        case 2:
            cell.textLabel?.text = "Camera model"
            cell.detailTextLabel?.text = camera
        default:
            break
        }
        return cell
    }
}
              
