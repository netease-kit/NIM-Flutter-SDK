// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:json_annotation/json_annotation.dart';

part 'nim_sdk_server_config.g.dart';

@JsonSerializable(explicitToJson: true)
class NIMServerConfig {
  /// 连接云信服务器加密数据通道的公钥参数1 rsaModulus
  final String? module;

  /// 连接云信服务器加密数据通道的公钥的版本号（默认0）
  final int publicKeyVersion;

  /// IM LBS服务器地址，通过它获取IM link 地址信息
  /// 填http/https地址
  /// [NIMServerConfig.lbsBackup]
  final String? lbs;

  /// IM 默认的link服务器地址，当IM LBS不可用时先连接该地址
  /// 填"IP/Host:PORT"
  final String? defaultLink;

  /// NOS上传LBS服务器地址
  /// 填http/https地址
  final String? nosUploadLbs;

  /// NOS上传默认的link服务器地址，当NOS LBS不可用时先连接该地址
  /// 填http/https地址
  final String? nosUploadDefaultLink;

  /// NOS上传服务器主机地址（仅nosSupportHttps=true时有效，用作https上传时的域名校验及http header host字段填充）
  /// 填host地址
  final String? nosUpload;

  /// NOS上传是否需要支持https。SDK 3.2版本后默认支持https，同时需要配置 nosUpload， 默认 true;
  final bool nosSupportHttps;

  /// NOS下载地址拼接模板，用于拼接最终得到的下载地址。
  /// 默认是 {bucket}.nosdn.127.net/{object}，SDK 上传资源后生成的下载地址为 https://bucket.nosdn.127.net/object
  final String? nosDownloadUrlFormat;

  /// NOS下载地址的host，用于拼接最终获得的文件URL地址，也支持该host替换成下载加速域名/地址 nosAccess.
  /// 填host地址, 默认是 nos.netease.com
  final String? nosDownload;

  ///
  /// NOS下载加速域名/地址，用于替换NOS下载url中的 nosDownload。
  /// 提供两种方式：
  /// 1) [4.4.0+开始支持]模板方式：填写云信规定的两种模板：{bucket}.nosdn.127.net/{object} 或者 nosdn.127.net/{bucket}/{object}，其中 {bucket} 和 {object} 作为标识符，必须填写。域名部分可以替换为您申请的加速域名。
  /// 2) [所有版本支持]非模板方式：填写用于加速的 http/https地址，例如：http://111.222.111.22:9090
  ///
  final String? nosAccess;

  /// "交换密钥"协议加密算法 {1(RSA),2(SM2)}, def:1(RSA) 非对称加密，默认 [AsymmetricType.rsa]
  final AsymmetricType negoKeyNeca;

  /// "交换密钥"协议加密算法密钥版本 version 自定义时则必填
  final int? negoKeyEncaKeyVersion;

  /// "交换密钥"协议加密算法密钥 part A 自定义时则必填 BigNumHex string 不含0x RSA: module, SM2: X
  final String? negoKeyEncaKeyParta;

  /// "交换密钥"协议加密算法密钥 part B 自定义时则必填 BigNumHex string 不含0x RSA: EXP, SM2: Y
  final String? negoKeyEncaKeyPartb;

  /// 通信加密算法 {1(RC4), 2(AES128), 4(SM4)}
  /// 默认: 1(RC4) 对称加密[SymmetryType.rc4]
  final SymmetryType commEnca;

  /// ipv6的缺省连接地址
  final String? linkIpv6;

  /// IP协议版本{0(IPV4), 1(IPV6), 2(Auto, SDK测试后自行选择, 存在性能损耗)}。
  /// 默认: 0(IPV4) 非对称加密[IPVersion.ipv4]
  final IPVersion ipProtocolVersion;

  /// 探测ipv4地址类型使用的url,  [IPVersion.any]时生效
  final String? probeIpv4Url;

  /// 探测ipv6地址类型使用的url,  [IPVersion.any]时生效
  final String? probeIpv6Url;

  /// 握手协议选择字段，默认[NimHandshakeType.v1]
  final NimHandshakeType handshakeType;

  /// 是否优先使用Cdn域名进行NOS下载，默认true
  final bool nosCdnEnable;

  /// 每个元素为使用过的NOS下载地址的特征以及桶名是否在host中组成的{@link Pair}对象
  /// 如new Pair("nim.nos.netease.com", true), new Pair("nos.netease.com/nim", false)等
  final Set<String>? nosDownloadSet;

  NIMServerConfig(
      {this.module,
      this.publicKeyVersion = 0,
      this.lbs,
      this.defaultLink,
      this.nosUploadLbs,
      this.nosUploadDefaultLink,
      this.nosUpload,
      this.nosSupportHttps = true,
      this.nosDownloadUrlFormat,
      this.nosDownload,
      this.nosAccess,
      this.negoKeyNeca = AsymmetricType.rsa,
      this.negoKeyEncaKeyVersion,
      this.negoKeyEncaKeyParta,
      this.negoKeyEncaKeyPartb,
      this.commEnca = SymmetryType.rc4,
      this.linkIpv6,
      this.ipProtocolVersion = IPVersion.ipv4,
      this.probeIpv4Url,
      this.probeIpv6Url,
      this.handshakeType = NimHandshakeType.v1,
      this.nosCdnEnable = true,
      this.nosDownloadSet});

  factory NIMServerConfig.fromJson(Map<String, dynamic> json) =>
      _$NIMServerConfigFromJson(json);

  Map<String, dynamic> toJson() => _$NIMServerConfigToJson(this);
}

enum AsymmetricType {
  /// RSA/ECB/PKCS1Padding
  rsa,
  sm2,

  /// RSA/ECB/OAEPWithSHA-1AndMGF1Padding
  rsaOaep1,

  /// RSA/ECB/OAEPWithSHA-256AndMGF1Padding
  rsaOaep256,
}

enum SymmetryType {
  rc4,
  aes,
  sm4,
}

enum IPVersion {
  /// 仅支持ipv4
  ipv4,

  /// 仅支持ipv4
  ipv6,

  /// 用户配置: 自动选择; 上报服务器获取LBS: 同时支持IPv4和IPv6
  any,
}

enum NimHandshakeType {
  v0,
  v1,
}
