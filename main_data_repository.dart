import 'package:fly_pie/api/api.dart';
import 'package:fly_pie/models/banner.dart';
import 'package:fly_pie/models/category.dart';
import 'package:fly_pie/models/product_list.dart';

class MainDataRepository {
  final _api = Api();

  Future<List<Category>> getCategories() async {
    return await _api.getCategories();
  }

  Future<BannerModel> getBanner() async {
    return await _api.getBanner();
  }

  Future<List<Product>> getProducts(int categoryId) async {
    return await _api.getProducts(categoryId);
  }
}
