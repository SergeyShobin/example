import 'package:fly_pie/models/banner.dart';
import 'package:fly_pie/models/basket_model.dart';
import 'package:fly_pie/models/category.dart';
import 'package:fly_pie/models/order.dart';
import 'package:fly_pie/models/product_list.dart';

import '../utils/utils.dart';

class Api {
  final _client = Static.dio();

  Future<List<Category>> getCategories() async {
    final response = await _client.get(
      ApiPath.categories,
    );

    return (response.data['data'] as List)
        .map((e) => Category.fromJson(e))
        .toList();
  }

  Future<List<Product>> getProducts(int categoryId) async {
    final response = await _client.get(
      ApiPath.products(categoryId),
    );
    return (response.data['products'] as List)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  Future<List<Product>> getOthers() async {
    final response = await _client.get(
      ApiPath.relatedProducts,
    );
    return (response.data['related_products'] as List)
        .map((e) => Product.fromJson(e))
        .toList();
  }

  Future<BannerModel> getBanner() async {
    final response = await _client.get(
      ApiPath.banner,
    );
    return BannerModel.fromJson((response.data as List).first);
  }

  Future<Order> createOrder(int sum) async {
    final response = await _client.post(
      ApiPath.order,
      queryParameters: {'sum': sum},
    );
    return Order.fromJson(response.data['data']);
  }

  Future<void> addProductToOrder({
    int id,
    List<BasketModel> products,
  }) async {
    final data = [];
    for (var i in products) {
      data.add({
        'product_id': i.product.id,
        'quantity': i.count,
      });
    }
    await _client.post(
      '${ApiPath.orderProducts}/$id',
      data: data,
    );
  }

  Future<Order> getOrderStatus(int id) async {
    final response = await _client.get(
      '${ApiPath.orderStatus}/$id',
    );
    return Order.fromJson(response.data);
  }
}
