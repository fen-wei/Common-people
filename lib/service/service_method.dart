import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/servcie_url.dart';

// 获取首页主体内容

Future http(url,method,data) async{
  try{
    print('开始获取首页数据');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = ContentType.parse('application/x-www-form-urlencoded');
    if(method == 'get'){
      if(data == null){
        response= await dio.get(servicePath[url]);
      }else{
        response = await dio.get(servicePath[url],queryParameters: data);
      }
    }else{
      if(data == null){
        response = await dio.post(servicePath[url]);
      }else{
        response = await dio.post(servicePath[url],data:data);
      }
    }
    return response.data;
  }catch(e){
    return print('error: =====================>${e}');
  }
  
}
