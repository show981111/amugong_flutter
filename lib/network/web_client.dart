import 'dart:convert';

import 'package:amugong/data/locator.dart';
import 'package:amugong/data/user_provider.dart';
import 'package:amugong/model/branch.dart';
import 'package:amugong/model/reservation.dart';
import 'package:amugong/model/seat.dart';
import 'package:amugong/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';

import '../data/cached_shared_preference.dart';

class WebClient {
  final Dio dio = Dio();
  final CachedSharedPreference sp = locator<CachedSharedPreference>();

  WebClient() {
    dio.options.baseUrl = "http://3.34.91.138:8000/api/";
    dio.options.connectTimeout = 3000;
    dio.options.receiveTimeout = 3000;
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      responseBody: true,
      requestBody: true,
      error: true,
    ));

    if (sp.haveUser()) {
      dio.options.headers['Authorization'] =
          "Bearer ${sp.getString(SharedPreferenceKey.AccessToken)}";
//      dio.options.headers['content-Type'] = 'application/json';
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e) {
          if (e.response.statusCode == 401) {
            String res = e.response.data['detail'][0];
            if (res == 'Invalid token') {
              sp.clearAll();
            }
          }
        },
      ),
    );
  }

  Future<String> login({@required String id, @required String password, String token}) async {
    Response dioResponse;

    try {
      dioResponse = await dio.post(
        'user/login',
        data: {'userID': id, 'userPassword': password, 'token' : token},
      );

      if (dioResponse.statusCode == 200) {
        bool isSuccess = await saveToken(dioResponse.data[0]['jwt']);
        if (isSuccess) {
          return null;
        }
      }
    } on DioError catch (e) {

      if (e.response.statusCode == 404) {
        return '존재하지 않는 아이디입니다';
      } else if (e.response.statusCode == 400) {
        return '올바른 전화번호/비밀번호 형식을 입력해주세요';
      } else if (e.response.statusCode == 403) {
        return '비밀번호가 일치하지 않습니다!';
      } else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '로그인에 실패했습니다';
  }

  Future<String> register({@required String userID, @required String userPassword, @required String name, @required String token}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.post(
        'user/register',
        data: {'userID': userID, 'userPassword': userPassword,'name': name, 'token': token},
      );

      if (dioResponse.statusCode == 200) {
        return "success";
      }
    } on DioError catch (e) {

      if (e.response.statusCode == 400) {
        return '올바른 전화번호/비밀번호 형식을 입력해주세요';
      } else if (e.response.statusCode == 403) {
        return '먼저 전화번호 인증을 해주세요!';
      }else if (e.response.statusCode == 404) {
        return '이미 가입하신 아이디입니다!';
      } else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '회원가입 실패했습니다';
  }

  Future<String> verifyPhone({@required String userID}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.post(
        'auth/phone',
        data: {'userID': userID},
      );

      if (dioResponse.statusCode == 200) {
        return "success";
      }
    } on DioError catch (e) {

      if (e.response.statusCode == 400) {
        return '올바른 전화번호/비밀번호 형식을 입력해주세요';
      } else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '인증번호 전송 실패했습니다. 다시 한번 시도해주세요!';
  }

  Future<String> verifyCode({@required String userID,@required String code}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.post(
        'auth/phone/verify',
        data: {'userID': userID, 'code' : code},
      );

      if (dioResponse.statusCode == 200) {
        return "success";
      }
    } on DioError catch (e) {

      if (e.response.statusCode == 400) {
        return '올바른 전화번호/비밀번호 형식을 입력해주세요';
      }else if (e.response.statusCode == 403) {
        return '인증 유효 기간이 만료되었습니다!';
      }else if (e.response.statusCode == 404) {
        return '코드가 올바르지 않습니다!';
      }else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }

    }
    return '오류가 발생했습니다. 다시 한번 시도해주세요!';
  }

  Future<bool> logOut() async {
    print("log out !");
    if (sp.haveUser()) {
      print("log out jave !");
      dio.options.headers.remove('Authorization');
      await sp.clearAll();
      return true;
    } else
      return false;
  }

  Future<User> getUser() async {
    if (sp.haveUser()) {
      final Response dioResponse = await dio.get('auth/login');

      if (dioResponse.statusCode == 200) {
        List<dynamic> json = dioResponse.data;
        if (json != null) {
          print(json);
          return json.map((e) => User.fromJson(e)).toList()[0];
        }
      } else {
        return null;
      }
    }else{
      print("get user called but do not have user");
    }
    return null;
  }

  Future<List<Branch>> getAllBranch() async {
    if (sp.haveUser()) {
      final Response dioResponse = await dio.get('branch');
      if (dioResponse.statusCode == 200) {
        List<dynamic> json = dioResponse.data;
        if (json != null) {
          return json.map((e) => Branch.fromJson(e)).toList();
//          return json.map((e) => User.fromJson(e)).toList()[0];
        }
      } else if(dioResponse.statusCode == 403){
        throw ("Forbidden");
      }
      else {
        return null;
      }
    }
    return null;
  }

  Future<List<Seat>> getSeatList({@required int branchID, @required String startTime,@required String endTime }) async {
    if (sp.haveUser()) {
      final Response dioResponse = await dio.get('reservation/seat/${branchID}/${startTime}/${endTime}');
      if (dioResponse.statusCode == 200) {
        List<dynamic> json = dioResponse.data;
        if (json != null) {
          return json.map((e) => Seat.fromJson(e)).toList();
//          return json.map((e) => User.fromJson(e)).toList()[0];
        }
      } else if(dioResponse.statusCode == 403){
        throw ("Forbidden");
      } else if(dioResponse.statusCode == 404){
        throw ("NotOpen");
      }
      else {
        return null;
      }
    }
    return null;

  }

  Future<String> reserveSeat({@required int seatID, @required String startTime, @required String endTime, @required int price}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.post(
        'reservation/seat',
        data: jsonEncode({'seatID': seatID, 'startTime': startTime, 'endTime' : endTime, 'price' : price}),
      );

      if (dioResponse.statusCode == 200) {
        print(dioResponse.data);
        return "success";
      }
    } on DioError catch (e) {
      print(e.response.data.toString());
      if (e.response.statusCode == 404) {
        if(e.response.data.toString() == 'filled'){
          return '이미 예약된 좌석입니다!';
        }else{
          return '예약이 불가능한 시간대입니다!';
        }
      } else if (e.response.statusCode == 400) {
        return '다시한번 시도해주세요!';
      } else if (e.response.statusCode == 403) {
        return '다시 로그인 해주세요!';
      } else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '오류가 발생했습니다';
  }

  Future<List<Reservation>> getMyReservation({@required String term, @required String option}) async {
    if (sp.haveUser()) {
      final Response dioResponse = await dio.get('reservation/${term}/${option}');
      if (dioResponse.statusCode == 200) {
        List<dynamic> json = dioResponse.data;
        if (json != null) {
          return json.map((e) => Reservation.fromJson(e)).toList();
        }
      } else if(dioResponse.statusCode == 403){
        throw ("Forbidden");
      } else{
        throw ("Internal error");
      }
    }
    return null;
  }

  Future<String> deleteReservation({@required int num}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.put('reservation/${num}');
      if (dioResponse.statusCode == 200) {
        return "success";
      }
    } on DioError catch (e) {
      print(e);
      if (e.response.statusCode == 403) {
        return '다시 로그인 해주세요!';
      } else if (e.response.statusCode == 404) {
        return '예약취소는 예약 시작시간 기준 30분 후까지만 가능합니다!';
      }else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '오류가 발생했습니다';
  }

  Future<String> qrScanEnter({@required int num, @required int isKing, @required int seatID,
    @required String rsrv_startTime, @required String rsrv_endTime, @required String purchasedAt,
    @required int branchID, @required String scanContent}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.put(
        'visit/enter',
        data: {'num': num, 'isKing': isKing, 'seatID' : seatID,
          'rsrv_startTime': rsrv_startTime, 'rsrv_endTime': rsrv_endTime, 'purchasedAt' : purchasedAt,
          'branchID' : branchID, 'scanContent' : scanContent},

      );
      if (dioResponse.statusCode == 200) {
        return "success";
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return '입장가능한 시간이 아닙니다!(입장은 5분전, 30분후 까지 가능합니다)';
      } else if (e.response.statusCode == 403) {
        return '다시 로그인 해주세요!';
      } else if (e.response.statusCode == 404) {
        return '일치하는 예약내역이 없습니다! 예약내역을 다시한번 확인해주세요!';
      }else if (e.response.statusCode == 405) {
        return '이용하시려는 지점과 예약내역이 일치하지 않습니다!!';
      }else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '오류가 발생했습니다';
  }

  Future<String> qrScanExit({@required int num, @required int seatID, @required String rsrv_endTime ,
    @required int branchID, @required String scanContent}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.put(
        'visit/exit',
        data: {'num': num, 'seatID' : seatID, 'rsrv_endTime': rsrv_endTime,
              'branchID' : branchID, 'scanContent' : scanContent},

      );
      if (dioResponse.statusCode == 200) {
        return "success";
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return '입장가능한 시간이 아닙니다!(입장은 5분전, 30분후 까지 가능합니다)';
      } else if (e.response.statusCode == 403) {
        return '다시 로그인 해주세요!';
      } else if (e.response.statusCode == 404) {
        return '일치하는 예약내역이 없거나 이미 퇴장 처리가 되었습니다!';
      }else if (e.response.statusCode == 405) {
        return '이용하시려는 지점과 예약내역이 일치하지 않습니다!!';
      }else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '오류가 발생했습니다';
  }

  Future<List<String>> getImageKeyList({@required int branchID}) async {
    if (sp.haveUser()) {
      final Response dioResponse = await dio.get('resources/${branchID}');
      if (dioResponse.statusCode == 200) {
//        print(jsonDecode(dioResponse.data));
        var keyList = (dioResponse.data as List<dynamic>)?.cast<String>();
//        print('tes');
        print(keyList);
        if (keyList != null) {
          return keyList;
        }
//        return dioResponse.data;
      } else if(dioResponse.statusCode == 403){
        throw ("Forbidden");
      } else{
        throw ("Internal error");
      }
    }
    return null;
  }

  Future<String> resetPassword({@required String userID, @required String userPassword}) async {
    Response dioResponse;
    try {
      dioResponse = await dio.put(
        'user/reset',
        data: jsonEncode({'userID': userID, 'userPassword': userPassword}),
      );

      if (dioResponse.statusCode == 200) {
        print(dioResponse.data);
        return "success";
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 400) {
        return '다시 한번 시도해주세요!';
      } else if (e.response.statusCode == 403) {
        return '먼저 전화번호 인증을 해주세요!';
      } else if (e.response.statusCode == 404) {
        return '아이디가 존재하지 않습니다. 회원가입을 해주세요!';
      } else if (e.response.statusCode == 500) {
        return '오류가 발생했습니다';
      }
    }
    return '오류가 발생했습니다';
  }


  Future<bool> saveToken(String token) async {
    if (token != null) {
      await locator<WebClient>().setAccessTokenToHeader(token);
      return true;
    } else {
      return false;
    }
  }

  Future<void> setAccessTokenToHeader(String token) async {
    await sp.setString(SharedPreferenceKey.AccessToken, token);
    dio.options.headers['Authorization'] = "Bearer $token";
    return;
  }
}
