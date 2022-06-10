# NetsenseiOS

## Prerequisites

Use Xcode 13.2.1 or higher
Target iOS 10.0 or higher

## Step by step guide

### 1. Import the Mobile Ads SDK

- Right-click on the folder with the application, click "New terminal in the folder", and type ```pod init```

- Open your project's Podfile and add these lines to your app's target:
```
pod 'Google-Mobile-Ads-SDK'
pod 'Smart-Display-SDK'
pod 'AdformAdvertising'
pod 'GoogleMobileAdsMediationChartboost'
pod 'GoogleMobileAdsMediationTapjoy'
pod 'GoogleMobileAdsMediationChartboost'
pod 'GoogleMobileAdsMediationAdColony'
pod 'GoogleMobileAdsMediationAppLovin'
pod 'GoogleMobileAdsMediationFyber'
pod 'GoogleMobileAdsMediationInMobi'
pod 'GoogleMobileAdsMediationIronSource'
pod 'GoogleMobileAdsMediationMyTarget'
pod 'GoogleMobileAdsMediationTapjoy'
pod 'GoogleMobileAdsMediationUnity'
pod 'GoogleMobileAdsMediationFacebook'
pod 'GoogleMobileAdsMediationVungle'
```
- Then from the command line run:
```
pod install --repo-update
```

<img width="403" alt="Screenshot 2022-06-10 at 11 27 37" src="https://user-images.githubusercontent.com/42434498/173035889-47538813-3704-4269-8e02-ec6dcb5c81ac.png">


- Open the .xcworkspace file with Xcode

## Update your Info.plist
- A GADApplicationIdentifier key with a string value of your AdMob app ID.

```
/*The ID value in the current code is a test application ID, which allows you to verify the correctness of the implemented code and broadcast test ads. After the tests are completed, you should replace them with the target ID, appropriate for a given application and ad unit. The correct ID is available in the details of the application https://netsenseapp.com/application after its acceptance.*/

<key>GADApplicationIdentifier</key>
<string>ca-app-pub-3940256099942544~1458002511</string>
```

## Initialize the Mobile Ads SDK

- Before loading ads, call the startWithCompletionHandler: method on the GADMobileAds.sharedInstance, which initializes the SDK and calls back a completion handler once initialization is complete (or after a 30-second timeout). This only needs to be done once, ideally at app launch. You should call startWithCompletionHandler: as early as possible.

```
import GoogleMobileAds

@Main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    GADMobileAds.sharedInstance().start(completionHandler: nil)

    return true
  }

}
```

## Add AdformAdvertisingDFPAdapter and SASGMAAdapter folders to the xcode project

<img width="262" alt="Screenshot 2022-06-10 at 11 38 06" src="https://user-images.githubusercontent.com/42434498/173037851-d0634c0d-1856-4744-953f-0137606071db.png">

## Consent panel compliant with the TCF v2.0 standard
- Transparency & The Consent Framework (TCF), the Transparency and Consent Framework, is an industry tool supporting companies in the digital advertising ecosystem in fulfilling the obligations arising from the provisions of Regulation (EU) 2016/697 of the Parliament Of the European Parliament and of the Council of 27 April 2016 on the protection of individuals with regard to data processing personal data and on the free movement of such data (GDPR) and Directive 2002/58 / EC of the European Parliament and of the Council of 12 July 2002 on the processing of personal data and the protection of privacy in the electronic communications sector (Directive on privacy and electronic communications).

- 1.) Update your Info.plist to add the NSUserTrackingUsageDescription key with a custom message string describing your usage.

```
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

- 2.) Next, you'll need to link the AppTrackingTransparency framework:

<img width="900" alt="Screenshot 2022-06-10 at 11 50 25" src="https://user-images.githubusercontent.com/42434498/173039896-d806dee7-ed1f-4644-bc6e-0e6394a8c83a.png">

- 3.) Add requestConsent() and loadForm() methods to your project and call requestConsent() from viewDidLoad() method
```
import UserMessagingPlatform
...

override func viewDidLoad() {
    super.viewDidLoad()
    requestConsent()
}

func requestConsent() {
        // Create a UMPRequestParameters object.
        let parameters = UMPRequestParameters()
        // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false

        // Request an update to the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
              if error != nil {
                // Handle the error.
              } else {
                  let formStatus = UMPConsentInformation.sharedInstance.formStatus
                  if formStatus == UMPFormStatus.available {
                      self.loadForm()
                  }
              }
            })
    }
    
func loadForm() {
    UMPConsentForm.load(completionHandler: { form, loadError in
    if loadError != nil {
      // Handle the error.
    } else {
      // Present the form. You can also hold on to the reference to present
      // later.
      if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
        form?.present(
            from: self,
            completionHandler: { dismissError in
              if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                // App can start requesting ads.
              }

            })
      } else {
        // Keep the form available for changes to user consent.
      }
    }
  })
}
```

## Displaying ads

### Banner and rectangle Ads

#### Create a GADBannerView

- Banner ads are displayed in GADBannerView objects, so the first step toward integrating banner ads is to include a GADBannerView in your view hierarchy. This is typically done either with the Interface Builder or programmatically.

#### - Interface Builder

- A GADBannerView can be added to a storyboard or xib file like any typical view. When using this method, be sure to add width and height constraints to match the ad size you'd like to display. For example, when displaying a banner (320x50), use a width constraint of 320 points, and a height constraint of 50 points.

####  - Programmatically

- A GADBannerView can also be instantiated directly. Here's an example of how to create a GADBannerView, aligned to the bottom center of the safe area of the screen, with a banner size of 320x50:

```
import GoogleMobileAds
...
var bannerView: GADBannerView!

override func viewDidLoad() {
    super.viewDidLoad()
    requestConsent()
    loadBannerAd()
}

func loadBannerAd() {

    /*The ID value in the current code is a test application ID, which allows you to verify the correctness of the implemented code and broadcast test ads. After the tests are completed, you should replace them with the target ID, appropriate for a given application and ad unit. The correct ID is available in the details of the application https://netsenseapp.com/application after its acceptance.*/

    bannerView = GADBannerView(adSize: GADAdSizeMediumRectangle)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
}

// Change GADAdSizeBanner to GADAdSizeMediumRectangle if you want to implement a rectangle ad
func addBannerViewToView(_ bannerView: GADBannerView) {
  bannerView.translatesAutoresizingMaskIntoConstraints = false
  view.addSubview(bannerView)
  view.addConstraints(
    [NSLayoutConstraint(item: bannerView,
                        attribute: .bottom,
                        relatedBy: .equal,
                        toItem: bottomLayoutGuide,
                        attribute: .top,
                        multiplier: 1,
                        constant: 0),
     NSLayoutConstraint(item: bannerView,
                        attribute: .centerX,
                        relatedBy: .equal,
                        toItem: view,
                        attribute: .centerX,
                        multiplier: 1,
                        constant: 0)
    ])
 }
```

### Interstitial Ads

- Loading an ad is accomplished using the static loadWithAdUnitID:request:completionHandler: method on the GADInterstitialAd class. The load method requires your ad unit ID, a GADRequest object, and a completion handler which gets called when ad loading succeeds or fails. The loaded GADInterstitialAd object is provided as a parameter in the completion handler. The below example shows how to load a GADInterstitialAd in your ViewController class.

```
import GoogleMobileAds
...
private var interstitial: GADInterstitialAd?

override func viewDidLoad() {
  super.viewDidLoad()
  requestConsent()
  loadInterstitialAd() 
}

func loadInterstitialAd() {


    /*The ID value in the current code is a test application ID, which allows you to verify the correctness of the implemented code and broadcast test ads. After the tests are completed, you should replace them with the target ID, appropriate for a given application and ad unit. The correct ID is available in the details of the application https://netsenseapp.com/application after its acceptance.*/
    
    GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910",
                                request: GADRequest(),
                      completionHandler: { [self] ad, error in
                        if let error = error {
                          print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                          return
                        }
                        interstitial = ad
                      }
    )
}

@IBAction func displayInterstitialAd(_ sender: Any) {
  if interstitial != nil {
    interstitial.present(fromRootViewController: self)
  } else {
    print("Ad wasn't ready")
  }
}

 ```
 
 ### Rewarded Ads
 
- Loading an ad is accomplished using the static loadWithAdUnitID:request:completionHandler: method on the GADRewardedAd class. The load method requires your ad unit ID, a GADRequest object, and a completion handler which gets called when ad loading succeeds or fails. The loaded GADRewardedAd object is provided as a parameter in the completion handler. The below example shows how to load a GADRewardedAd in your ViewController class.

 ```
 import GoogleMobileAds
 ...
var rewardedAd: GADRewardedAd?

override func viewDidLoad() {
    super.viewDidLoad()
    requestConsent()
    loadRewardedAd()

}

func loadRewardedAd() {
        /*The ID value in the current code is a test application ID, which allows you to verify the correctness of the implemented code and broadcast test ads. After the tests are completed, you should replace them with the target ID, appropriate for a given application and ad unit. The correct ID is available in the details of the application https://netsenseapp.com/application after its acceptance.*/
    GADRewardedAd.load(withAdUnitID:"ca-app-pub-3940256099942544/1712485313",
                       request: GADRequest(),
                       completionHandler: { [self] ad, error in
      if let error = error {
        print("Failed to load rewarded ad with error: \(error.localizedDescription)")
        return
      }
      rewardedAd = ad
      print("Rewarded ad loaded.")
    }
    )
}

@IBAction func displayRewardedlAd(_ sender: Any){
  if let ad = rewardedAd {
    ad.present(fromRootViewController: self) {
      let reward = ad.adReward
      print("Reward received with currency \(reward.amount), amount \(reward.amount.doubleValue)")
      // TODO: Reward the user.
    }
  } else {
    print("Ad wasn't ready")
  }
}
  ```
