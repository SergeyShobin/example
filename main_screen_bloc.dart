import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fly_pie/models/banner.dart';
import 'package:fly_pie/models/category.dart';
import 'package:fly_pie/models/product_list.dart';
import 'package:fly_pie/repository/main_data_repository.dart';

abstract class MainScreenState {
  final List<Category> categories;
  final int activeCategoryId;
  final List<Product> products;
  final BannerModel bannerModel;

  MainScreenState({
    this.categories,
    this.activeCategoryId,
    this.products,
    this.bannerModel,
  });
}

class LoadingMainScreenState extends MainScreenState {}

class PartLoadMainScreenState extends MainScreenState {
  PartLoadMainScreenState({
    List<Category> categories,
    int activeCategoryId,
    List<Product> products,
    BannerModel bannerModel,
  }) : super(
          categories: categories,
          products: products,
          activeCategoryId: activeCategoryId,
          bannerModel: bannerModel,
        );
}

class DataMainScreenState extends MainScreenState {
  DataMainScreenState({
    List<Category> categories,
    int activeCategoryId,
    List<Product> products,
    BannerModel bannerModel,
  }) : super(
          categories: categories,
          products: products,
          activeCategoryId: activeCategoryId,
          bannerModel: bannerModel,
        );
}

class MainScreenBloc extends Cubit<MainScreenState> {
  MainScreenBloc() : super(LoadingMainScreenState()) {
    _load();
  }

  final _mainDataRepository = MainDataRepository();

  List<Category> _categories;

  int _activeCategoryId;

  List<Product> _products;

  BannerModel _bannerModel;

  Future<void> _load() async {
    _categories = await _mainDataRepository.getCategories();
    _bannerModel = await _mainDataRepository.getBanner();
    _activeCategoryId = _categories.first.id;
    _emitPartLoad();
    _loadCategoryItems();
  }

  void setActiveCategory(int categoryId) {
    _activeCategoryId = categoryId;
    _emitPartLoad();
    _loadCategoryItems();
  }

  void _emitPartLoad() {
    emit(
      PartLoadMainScreenState(
          categories: _categories,
          bannerModel: _bannerModel,
          activeCategoryId: _activeCategoryId,
          products: _products),
    );
  }

  Future<void> _loadCategoryItems() async {
    _products = await _mainDataRepository.getProducts(_activeCategoryId);
    emit(
      DataMainScreenState(
        categories: _categories,
        products: _products,
        activeCategoryId: _activeCategoryId,
        bannerModel: _bannerModel,
      ),
    );
  }

  void toStartPosition() {
    setActiveCategory(_categories.first.id);
  }
}
