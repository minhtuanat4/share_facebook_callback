import Flutter
import UIKit
import FBSDKShareKit
import PhotosUI

public class SwiftShareFacebookCallbackPlugin: NSObject, FlutterPlugin ,SharingDelegate{

  var result: FlutterResult?
  var shareURL: String?
  var documentInteractionController: UIDocumentInteractionController?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "share_facebook_callback", binaryMessenger: registrar.messenger())
    let instance = SwiftShareFacebookCallbackPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result
    if call.method == "getPlatformVersion" {
      print("APAddressBook initialization error:\n");
      result("iOS " + UIDevice.current.systemVersion)
    } else if call.method == "facebook_share" {
      NSLog("APAddressBook initialization error:\n%@", "Minh Tuan");
      if let arguments = call.arguments  as? [String : Any] {
        let type = arguments["type"] as? String ?? "ShareType.more"
        let shareQuote = arguments["quote"] as? String ?? ""
        let shareUrl = arguments["url"] as? String ?? ""
        _ = arguments["imageName"] as? String ?? ""

        switch type {
        case "ShareType.shareLinksFacebook":
            shareLinksFacebook(withQuote: shareQuote, withUrl: shareUrl)
            break
          case "ShareType.sharePhotoFacebook":
            // sharePhotoFacebook(imageUrl, quote, result)
            break
          default:
            self.result?("Method not implemented")
            break
    
        }
      }
    }
  }

   public func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
      NSLog("--------------------success")
      self.result?("success")
    }
    
    public func sharer(_ sharer: Sharing, didFailWithError error: Error) {
      NSLog("-----------------onError");
      self.result?("error")
    }
    
    public func sharerDidCancel(_ sharer: Sharing) {
      NSLog("-----------------onCancel");
      self.result?("cancel")
    }

  private func shareLinksFacebook(withQuote quote: String?, withUrl urlString: String?){
    DispatchQueue.main.async {
            let viewController = UIApplication.shared.delegate?.window??.rootViewController

            let shareContent = ShareLinkContent()

            if let url = urlString , let covertURl =  URL.init(string: url) {
              shareContent.contentURL = covertURl
            }

            if let quoteString = quote {
                shareContent.quote = quoteString
            }
           
            let shareDialog = ShareDialog(viewController: viewController, content: shareContent, delegate: self)
                    shareDialog.show()
        }
  }
}
