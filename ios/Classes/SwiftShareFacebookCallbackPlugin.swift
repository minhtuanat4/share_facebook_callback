import Flutter
import UIKit
import FBSDKShareKit

public class SwiftShareFacebookCallbackPlugin: NSObject, FlutterPlugin ,SharingDelegate{

  var result: FlutterResult?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "share_facebook_callback", binaryMessenger: registrar.messenger())
    let instance = SwiftShareFacebookCallbackPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result
    if call.method == "getPlatformVersion" {
      result("iOS " + UIDevice.current.systemVersion)
    } else if call.method == "facebook_share" {
      if let arguments = call.arguments  as? [String : Any] {
        let type = arguments["type"] as? String ?? "ShareType.more"
        let shareQuote = arguments["quote"] as? String ?? ""
        let shareUrl = arguments["url"] as? String ?? ""
        let uint8Image = arguments["uint8Image"] as? FlutterStandardTypedData
        _ = arguments["imageName"] as? String ?? ""

        switch type {
        case "ShareType.shareLinksFacebook":
            shareLinksFacebook(withQuote: shareQuote, withUrl: shareUrl)
            break
          case "ShareType.sharePhotoFacebook":
            sharePhotoFacebook(withuint8Image: uint8Image, withQuote: shareQuote)
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
    
  private  func sharePhotoFacebook(withuint8Image uint8Image: FlutterStandardTypedData?,  withQuote quote: String?) {
      
   DispatchQueue.main.async {
            guard let data = uint8Image else {
                    return
            }
       
            let viewController = UIApplication.shared.delegate?.window??.rootViewController
       
            let uiImage = UIImage(data: data.data)!
       
            let photo = SharePhoto(
                    image: uiImage,
                    isUserGenerated: true)
       
            let content = SharePhotoContent()
                content.photos = [photo]
       
            let shareDialog = ShareDialog(viewController: viewController, content: content, delegate: self)
                shareDialog.show()
            }
        }
    }
