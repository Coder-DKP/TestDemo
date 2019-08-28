// AFSecurityPolicy.h
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <Security/Security.h>

/*
 HTTPS加密过程：
 1.客户端输入网址https://www.domain..com，连接到server的443端口。
 2.服务器返回一个证书（包含公钥、和证书信息，如证书的颁发机构，过期时间等），证书由服务器所拥有的私钥非对称加密生成。
 3.客户端对证书进行验证（首先会验证证书是否有效，比如颁发机构，过期时间等等）。
 4.如果客户端验证通过，客户端生成一个随机数，在用服务器返回的证书（公钥）进行加密传输。
 5.因为公钥是通过服务器的私钥生成，所以服务器是可以对客户端的传回的加密数据进行对称解密的。服务器拿到由客户端生成的随机数，对要传递的数据使用随机数加密。
 6.客户端收到服务器使用随机数加密的数据进行解密。
 
（1）服务器返回的证书是经服务器非对称加密的。
（2）随机数用来后面传递消息的对称加密。
（3）因为，对称加密效率要比不对成加密高。所以，证书可信任后面用的是对称加密。而校验证书用的非对称加密。
 
 注意：
   不过在app的开发中因为我们的app通常只需要和一个服务器端进行交互，所以不必要每次请求都从服务器那边获取证书（公钥），在开发中app直接将服务器对应生成的证书（公钥）放在沙盒中，HTTPS请求时只要直接和服务器返回的证书（公钥）进行比对。如果验证通过则使用公钥进行加密在传递回服务器。
      这样即使app中的证书（公钥）被截取，中间人使用证书冒充了服务器与客户端进行通信时（通过了验证），但因为从app返回的数据都是通过证书（公钥）加密的。而中间人从app截取的证书时公钥，缺少对应的私钥即使截获了信息也无法解密。能够最大的程度的保护传递的信息安全。

 */


typedef NS_ENUM(NSUInteger, AFSSLPinningMode) {
    AFSSLPinningModeNone,//代表客户端无条件地信任服务器端返回的证书。
    AFSSLPinningModePublicKey,//代表客户端会将服务器端返回的证书与本地保存的证书中，PublicKey的部分进行校验；如果正确，才继续进行
    AFSSLPinningModeCertificate,//代表客户端会将服务器端返回的证书和本地保存的证书中的所有内容，包括PublicKey和证书部分，全部进行校验；如果正确，才继续进行。
};

/**
 `AFSecurityPolicy` evaluates server trust against pinned X.509 certificates and public keys over secure connections.

 Adding pinned SSL certificates to your app helps prevent man-in-the-middle attacks and other vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged to route all communication over an HTTPS connection with SSL pinning configured and enabled.
 */

NS_ASSUME_NONNULL_BEGIN

@interface AFSecurityPolicy : NSObject <NSSecureCoding, NSCopying>

/**
 The criteria by which server trust should be evaluated against the pinned SSL certificates. Defaults to `AFSSLPinningModeNone`.
 */
/*
 返回SSL Pinning的类型。默认的是AFSSLPinningModeNone。
 */
@property (readonly, nonatomic, assign) AFSSLPinningMode SSLPinningMode;

/**
 The certificates used to evaluate server trust according to the SSL pinning mode. 

  By default, this property is set to any (`.cer`) certificates included in the target compiling AFNetworking. Note that if you are using AFNetworking as embedded framework, no certificates will be pinned by default. Use `certificatesInBundle` to load certificates from your target, and then create a new policy by calling `policyWithPinningMode:withPinnedCertificates`.
 
 Note that if pinning is enabled, `evaluateServerTrust:forDomain:` will return true if any pinned certificate matches.
 */

/*
 所有能用来根据SSL pinning Mode 评估服务器是否可用的证书集合。
 默认情况下，这个属性被设置为任何AFNetworking参与编译的工程中的.cer证书。值得注意的是，如果你正在使用AFNetworking作为嵌入框架，默认下不会指定任何证书。你需要使用`certificatesInBundle` 方法加载你工程中的所有证书，然后通过`policyWithPinningMode:withPinnedCertificates`，创建一个新的证书。
 注意，一旦使用指定，`evaluateServerTrust:forDomain:`方法将返回true,只要任何指定的证书匹配。
 
 
 */
@property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;

/**
 Whether or not to trust servers with an invalid or expired SSL certificates. Defaults to `NO`.
 */
/*
 是否信任过期或无效证书。默认NO
 */
@property (nonatomic, assign) BOOL allowInvalidCertificates;

/**
 Whether or not to validate the domain name in the certificate's CN field. Defaults to `YES`.
 */

/*
 是否要验证证书中CN的域名。默认YES
 */
@property (nonatomic, assign) BOOL validatesDomainName;

///-----------------------------------------
/// @name Getting Certificates from the Bundle
///-----------------------------------------

/**
 Returns any certificates included in the bundle. If you are using AFNetworking as an embedded framework, you must use this method to find the certificates you have included in your app bundle, and use them when creating your security policy by calling `policyWithPinningMode:withPinnedCertificates`.

 @return The certificates included in the given bundle.
 */

/*
获取包中的所有证书。
 如果你正在使用AFNetworking作为嵌入式框架，你必须使用该方法获得你APP包中的所有证书，然后当需要创建安全策略时调用`policyWithPinningMode:withPinnedCertificates`.
*/
+ (NSSet <NSData *> *)certificatesInBundle:(NSBundle *)bundle;

///-----------------------------------------
/// @name Getting Specific Security Policies
///-----------------------------------------

/**
 Returns the shared default security policy, which does not allow invalid certificates, validates domain name, and does not validate against pinned certificates or public keys.

 @return The default security policy.不信任无效证书，验证域名，不对指定证书和公钥进行验证

 */
/*
默认安全策略。
 */
+ (instancetype)defaultPolicy;

///---------------------
/// @name Initialization
///---------------------

/**
 Creates and returns a security policy with the specified pinning mode.

 @param pinningMode The SSL pinning mode.

 @return A new security policy.
 */
/*
 根据指定模式创建ecurity policy
 */
+ (instancetype)policyWithPinningMode:(AFSSLPinningMode)pinningMode;

/**
 Creates and returns a security policy with the specified pinning mode.

 @param pinningMode The SSL pinning mode.
 @param pinnedCertificates The certificates to pin against.

 @return A new security policy.
 */
/*
 根据指定模式创建ecurity policy
 */
+ (instancetype)policyWithPinningMode:(AFSSLPinningMode)pinningMode withPinnedCertificates:(NSSet <NSData *> *)pinnedCertificates;

///------------------------------
/// @name Evaluating Server Trust
///------------------------------

/**
 Whether or not the specified server trust should be accepted, based on the security policy.

 This method should be used when responding to an authentication challenge from a server.

 @param serverTrust The X.509 certificate trust of the server.
 @param domain The domain of serverTrust. If `nil`, the domain will not be validated.

 @return Whether or not to trust the server.
 */
/*
 核心方法
 第一个参数：serverTrust是服务器发放的X.509信任证书；
 第二个参数：domain是发放信任证书的服务器域名。
 这个方法是基于security policy来验证指定的服务器是否可信任。这个方法应该在响应服务器身份验证挑战时使用。
 
 */
- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(nullable NSString *)domain;

@end

NS_ASSUME_NONNULL_END

///----------------
/// @name Constants
///----------------

/**
 ## SSL Pinning Modes

 The following constants are provided by `AFSSLPinningMode` as possible SSL pinning modes.

 enum {
 AFSSLPinningModeNone,
 AFSSLPinningModePublicKey,
 AFSSLPinningModeCertificate,
 }

 `AFSSLPinningModeNone`
 Do not used pinned certificates to validate servers.

 `AFSSLPinningModePublicKey`
 Validate host certificates against public keys of pinned certificates.

 `AFSSLPinningModeCertificate`
 Validate host certificates against pinned certificates.
*/
