import UIKit

class ViewController: UIViewController, DataEnteredDelegate {
    
    let cellMargin: CGFloat = 10
    let cellCount = 3
    var section = 0
    var data: NSData? = nil
    
    var image = Storage()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map { $0.item }.sorted().reversed()
            
            for item in items {
                switch section {
                case 0:
                    image.ipadList.remove(at: item)
                case 1:
                    image.iphoneList.remove(at: item)
                case 2:
                    image.downloadedImageList.remove(at: item)
                default:
                    break
                }
            }
            collectionView.deleteItems(at: selectedCells)
            deleteButton.isEnabled = false
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        collectionView.allowsMultipleSelection = editing
        let indexPaths = collectionView.indexPathsForVisibleItems
        
        for indexPath in indexPaths {
            let cell = collectionView.cellForItem(at: indexPath) as! AppleCell
            cell.isInEditingMode = editing
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newImage" {
            let ac = segue.destination as! AddController
            ac.delegate = self
        }
    }
    
    func imageInfo(imageUrl: NSURL, imageName: String, dateOfCreation: String, camera: String) {
        
        image.addDwnImage(dImage: DownloadedImage(nameDImage: imageName, dateDImage: dateOfCreation, cameraDImage: camera, urlImage: imageUrl))
        
        self.collectionView.reloadData()
    }
    
    func imageFromUrl(urlStr: String, imageView: UIImageView) {
        
        if let url = URL(string: urlStr) {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        imageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
}
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return image.categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var num = 0
        
        switch section {
        case 0:
            num = image.ipadList.count
        case 1:
            num = image.iphoneList.count
        case 2:
            num = image.downloadedImageList.count
        default:
            break
        }
        
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: AppleCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppleCell", for: indexPath) as! AppleCell
        
        switch indexPath.section {
        case 0:
            let item = image.ipadList[indexPath.item]
            cell.imageView.image = UIImage(named: item.imageName)
            cell.isInEditingMode = isEditing
        case 1:
            let item = image.iphoneList[indexPath.item]
            cell.imageView.image = UIImage(named: item.imageName)
            cell.isInEditingMode = isEditing
        case 2:
            data = NSData(contentsOf: image.downloadedImageList[indexPath.item].urlImage as URL)
            cell.imageView.image = UIImage(data: data! as Data)
            cell.isInEditingMode = isEditing
        default:
            break
        }
        
        return cell
    }
    //Рaзмер заголовка
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: UIScreen.main.bounds.width, height: 40)
        
    }
    //Конструкция header и footer. Сначала выбираем storyboard, где выбираем Collection View, и справа ставим галочку в Accessories - section header/section footer.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var view: HeaderView!
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView
            
            for i in 0 ... image.categoryList.count - 1 {
                
                if indexPath.section == i {
                    view.headerLabel.text = image.categoryList[i]
                    view.backgroundColor = .systemGray6
                }
            }
            
        case UICollectionView.elementKindSectionFooter:
            view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as? HeaderView
        default:
            break
        }
        return view
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isEditing {
            deleteButton.isEnabled = true
            self.section = indexPath.section
            print("SECTION:", self.section)
        } else if let vc = storyboard?.instantiateViewController(withIdentifier: "info") {
            deleteButton.isEnabled = false
            
            if let ic = vc as? InfoController {
                
                switch indexPath.section {
                case 0:
                    ic.imageList = image.ipadList[indexPath.item]
                    ic.navigationItem.title = image.ipadList[indexPath.item].headerName
                case 1:
                    ic.imageList = image.iphoneList[indexPath.item]
                    ic.navigationItem.title = image.iphoneList[indexPath.item].headerName
                case 2:
                    ic.imageDList =  image.downloadedImageList[indexPath.item]
                    ic.navigationItem.title = image.downloadedImageList[indexPath.item].nameDImage
                default:
                    break
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let selectedItems = collectionView.indexPathsForSelectedItems, selectedItems.count == 0 {
            deleteButton.isEnabled = false
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //Отступы между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
    }
    //Размер ячейки по заданному индексу
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = floor(UIScreen.main.bounds.width - CGFloat(cellCount + 1) * cellMargin) / CGFloat(cellCount)
        
        return CGSize(width: width, height: width)
    }
    //Промежуток между строками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellMargin
    }
    //Промежуток между ячейками по горизонтали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return cellMargin
    }
}

