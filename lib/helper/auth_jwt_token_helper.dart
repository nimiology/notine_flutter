import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../screens/login.dart';

const storage = FlutterSecureStorage();

class AuthToken {

  static Future<String?> accessToken() async {
    String? token = await storage.read(key: 'access');
    if (token != null) {
      if (!JwtDecoder.isExpired(token)) {
        return token;
      } else {
        String? refreshToken = await AuthToken.refreshToken();
        if (refreshToken != null) {
          try {
            http.Response response = await http.post(
                Uri.parse('https://notine.pythonanywhere.com/auth/jwt/refresh/'),
                body: {'refresh': refreshToken});
            final tokensMap = json.decode(response.body);
            if (response.statusCode == 200) {
              AuthToken.saveFromMap(tokensMap);
              return tokensMap['access'];
            } else {
              print(response.statusCode);
            }
          } on SocketException catch (_) {
            print("There is no internet connection");
          } catch (_) {
            print("Something went wrong");
            throw _;
          }
        }
      }
    }
  }

  static Future<String?> refreshToken() async {
    String? token = await storage.read(key: 'refresh');
    if (!JwtDecoder.isExpired(token!)) {
      return token;
    }
    return null;
  }

  static Future<bool> isLogin() async {
    String? token = await storage.read(key: 'refresh');
    if (token != null) {
      final isExpired = await AuthToken.isRefreshTokenExpired(token);
      return !isExpired;
    }
    return (token != null);
  }

  static isAccessTokenExpired(String token) async {
    return JwtDecoder.isExpired(token);
  }

  static isRefreshTokenExpired(String token) async {
    return JwtDecoder.isExpired(token);
  }

  static saveAccessToken(String token) async {
    await storage.write(key: 'access', value: token);
  }

  static saveRefreshToken(String token) async {
    await storage.write(key: 'refresh', value: token);
  }

  static saveFromMap(Map map) async {
    await AuthToken.saveAccessToken(map['access']);
    await AuthToken.saveRefreshToken(map['refresh']);
  }

  static Future<int> getUserId() async {
    final access = await AuthToken.accessToken();
    final accessDecoded = JwtDecoder.decode(access ?? "");
    return accessDecoded['user_id'];
  }

  static deleteRefreshToken() async {
    await storage.delete(key: 'refresh');
  }

  static deleteAccessToken() async {
    await storage.delete(key: 'access');
  }

  static logout() async {
    await AuthToken.deleteAccessToken();
    await AuthToken.deleteRefreshToken();
  }
}
