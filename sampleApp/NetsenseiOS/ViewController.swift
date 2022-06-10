//
//  ViewController.swift
//  NetsenseiOS
//
//  Created by Jakub Florkowski on 10/06/2022.
//

import UIKit
import GoogleMobileAds
import UserMessagingPlatform
import AdColonyAdapter
import AppLovinSDK
import IASDKCore
import InMobiAdapter
import MyTargetSDK
import Tapjoy
import UnityAds
import UnityAdapter
import VungleSDK
import VungleAdapter

class ViewController: UIViewController {
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitialAd?
    var rewardedAd: GADRewardedAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestConsent()
    }
    
    func loadRewardedAd() {
        GADRewardedAd.load(withAdUnitID:"ca-app-pub-3490076200755941/1923212334",
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
    
    @IBAction func loadInterstitialAd(_ sender: Any){
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
    
    func loadBannerAd() {
        bannerView = GADBannerView(adSize: GADAdSizeMediumRectangle)
                addBannerViewToView(bannerView)
                bannerView.adUnitID = "ca-app-pub-3490076200755941/4740947363"
                bannerView.rootViewController = self
                bannerView.load(GADRequest())
    }
    
    func loadInterstitialAd() {
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3490076200755941/6691806369",
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
    
//    @IBAction func displayInterstitialAd(_ sender: Any) {
//        if interstitial != nil {
//          interstitial?.present(fromRootViewController: self)
//        } else {
//          print("Ad wasn't ready")
//        }
//    }
    
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
    
    
    func requestConsent() {
        
        let options = GADMediationAdapterAdColony.appOptions
        options?.setPrivacyFrameworkOfType(ADC_GDPR, isRequired: true)
        options?.setPrivacyConsentString("1", forType: ADC_GDPR)
        ALPrivacySettings.setHasUserConsent(true)
        IASDKCore.sharedInstance().gdprConsent=IAGDPRConsentType.given
        IASDKCore.sharedInstance().gdprConsentString = "myGdprConsentString"
        var consentObject: [String : String] = [:]
        consentObject["gdpr"] = "1"
        consentObject[IM_GDPR_CONSENT_AVAILABLE] = "true"
        GADMInMobiConsent.updateGDPRConsent(consentObject)
        MTRGPrivacy.setUserConsent(true)
        Tapjoy.setUserConsent("1")
        let gdprConsentMetaData = UADSMetaData()
        gdprConsentMetaData.set("gdpr.consent", value: NSNumber(value: true))
        gdprConsentMetaData.commit()
        VungleRouterConsent.update(VungleConsentStatus.accepted)
        
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


}

