import 'dart:convert';

class apiEndPoint {

  static  String baseUrl = 'http://35.73.30.144:2008/api/v1';
  static String readProduct = '$baseUrl/ReadProduct';
  static String createProduct = '$baseUrl/CreateProduct';
  static deletePeoduct(id){return '$baseUrl/DeleteProduct/$id';}
  static updateProduct(id){return '$baseUrl/UpdateProduct/$id';}

}