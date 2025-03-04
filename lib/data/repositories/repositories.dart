import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/apiEndPoint.dart';
import '../models/models.dart';

class repositories {

  List<Data> product = [];

  Future<void>fetchProduct()async{
    final response = await http.get(Uri.parse(apiEndPoint.readProduct));
    print(response.statusCode);
    if(response.statusCode == 200){
      var getData = jsonDecode(response.body);
      readProductModel model = readProductModel.fromJson(getData);
      product = model.data!;
    }
  }

  Future<void>createProduct({required String productName, required String img, required int qty, required int unitPrice, required int totalPrice})async{
    final response = await http.post(Uri.parse(apiEndPoint.createProduct),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {
            "ProductName": productName,
            "ProductCode": DateTime.now().millisecondsSinceEpoch,
            "Img": img,
            "Qty": qty,
            "UnitPrice": unitPrice,
            "TotalPrice": totalPrice,
          }
      )
    );

    print('createProductStatusCode: ${response.statusCode}');
    fetchProduct();
  }

  Future<void>deleteProduct({required String id})async{
    final response = await http.get(Uri.parse(apiEndPoint.deletePeoduct(id)));
    print('deleteProductStatusCode: ${response.statusCode}');
    fetchProduct();
  }

  Future<void>updateProduct({required String id,  required String productName, required String img, required int qty, required int unitPrice, required int totalPrice})async {
    final response = await http.post(Uri.parse(apiEndPoint.updateProduct(id)),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {
              "ProductName": productName,
              "ProductCode": DateTime.now().millisecondsSinceEpoch,
              "Img": img,
              "Qty": qty,
              "UnitPrice": unitPrice,
              "TotalPrice": totalPrice,
            }
        )
    );
    print('updateProductStatusCode: ${response.statusCode}');
    fetchProduct();
  }



}