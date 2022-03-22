import CoreML
import UIKit
import Vision
import PlaygroundSupport

// First, we will import the image as UIImage, next to the playground file
var image = UIImage(named: "someface.jpeg")
// display the image
let imageView = UIImageView(image: image)

extension UIImage {
    func coreOrientation() -> CGImagePropertyOrientation {
        switch imageOrientation {
        case .up: return .up
        case .upMirrored: return .upMirrored
        case .down: return .down // 0th row at bottom, 0th column on right  - 180 deg rotation
        case .downMirrored: return .downMirrored // 0th row at bottom, 0th column on left   - vertical flip
        case .leftMirrored: return .leftMirrored // 0th row on left,   0th column at top
        case .right: return .right // 0th row on right,  0th column at top    - 90 deg CW
        case .rightMirrored: return .rightMirrored // 0th row on right,  0th column on bottom
        case .left: return .left // 0th row on left,   0th column at bottom - 90 deg CCW
        @unknown default:
            fatalError()
        }
    }
}

func handleDetection(request: VNRequest, errror: Error?) {
    guard let observations = request.results as? [VNFaceObservation] else {
        fatalError("unexpected result type!")
    }

    print("Detected \(observations.count) faces")
}

var faceDetectionRequest: VNDetectFaceRectanglesRequest = {
    let faceLandmarksRequest = VNDetectFaceRectanglesRequest(completionHandler: handleDetection)
    return faceLandmarksRequest
}()

func launchDetection(image: UIImage) {
    let orientation = image.coreOrientation()
    guard let coreImage = CIImage(image: image) else { return }

    DispatchQueue.global().async {
        let handler = VNImageRequestHandler(ciImage: coreImage, orientation: orientation)
        do {
            try handler.perform([faceDetectionRequest])
        } catch {
            print("Failed to perform detection .\n\(error.localizedDescription)")
        }
    }
}

launchDetection(image: image!)
