import Foundation

class Storage {
    
    var downloadedImageList: Array<DownloadedImage> = []
    
    var ipadList = [
        Image(imageName: "ipad air", headerName: "iPad Air 2018", categoryName: "iPad", dateOfCreation: "02.02.1990", cameraModel: "Sony"),
        Image(imageName: "ipad pro", headerName: "iPad Pro 2020", categoryName: "iPad", dateOfCreation: "02.07.1996", cameraModel: "Sony")
    ]
   
    var iphoneList = [
           Image(imageName: "iphone 5", headerName: "iPhone 5", categoryName: "iPhone", dateOfCreation: "08.02.1995", cameraModel: "Nikon"),
           Image(imageName: "iphone 7", headerName: "iPhone 7", categoryName: "iPhone", dateOfCreation: "10.07.1999", cameraModel: "Canon"),
           Image(imageName: "iphone 11", headerName: "iPhone 11", categoryName: "iPhone", dateOfCreation: "08.10.2019", cameraModel: "Sony")
       ]
   
    var categoryList = ["iPad", "iPhone", "Downloaded"]
    
    func addDwnImage(dImage: DownloadedImage) {
        downloadedImageList.append(dImage)
    }
}
