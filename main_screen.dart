import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fly_pie/bloc/basket_bloc.dart';
import 'package:fly_pie/bloc/main_screen_bloc.dart';
import 'package:fly_pie/models/category.dart';
import 'package:fly_pie/models/product_list.dart';
import 'package:fly_pie/screens/basket_screen.dart';
import 'package:fly_pie/utils/utils.dart';
import 'package:fly_pie/widgets/icons.dart';
import 'package:provider/provider.dart';

import '../bloc/main_screen_bloc.dart';
import 'detail_product_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        if (state is LoadingMainScreenState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final basketBloc = context.watch<BasketBloc>();
        return WillPopScope(
          onWillPop: () => Future.value(false),
          child: Scaffold(
            body: Column(
              children: [
                _Banner(),
                SizedBox(height: 20),
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 121,
                        child: ListView.separated(
                          itemCount: state.categories.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (_, i) {
                            return _CategoryItem(
                              category: state.categories[i],
                              isActive:
                              state.categories[i].id == state.activeCategoryId,
                            );
                          },
                          separatorBuilder: (_, i) => Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 2),
                              child: Container(
                                width: 2,
                                height: 10,
                                color: i == 0
                                    ? Colors.transparent
                                    : AppColors.lightBlue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      if (state is PartLoadMainScreenState) ...[
                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Column(
                              children: [
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 15,
                                      childAspectRatio: 1.25,
                                    ),
                                    itemCount: state.products.length,
                                    itemBuilder: (_, i) {
                                      return _ProductItem(
                                        product: state.products[i],
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  width: MediaQuery.of(context).sizeidth,
                                  height: 123,
                                  color: AppColors.lightBlue,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Товаров:'.toUpperCase(),
                                                  style: AppTypography.font14
                                                      .copyWith(
                                                    fontWeight: FontWeight700,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  '${basketBloc.items.length}',
                                                  style: AppTypography.font14
                                                      .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${basketBloc.sum} ₽',
                                              style:
                                                  AppTypography.font24.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            final bloc =
                                                context.read<BasketBloc>();
                                            if (bloc.items.isNotEmpty)
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) =>
                                                      BasketScreen(),
                                                ),
                                              );
                                          },
                                          child: Container(
                                            width: 213,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: AppColors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'перейти В корзину'
                                                      .toUpperCase(),
                                                  style: AppTypography.font14
                                                      .copyWith(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8),
                                                  child: Icon(
                                                    Icons.chevron_right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final Category category;
  final bool isActive;

  const _CategoryItem({
    Key key,
    this.category,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<MainScreenBloc>().setActiveCategory(
            category.id,
          ),
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Container(
            width: 117,
            height: 106,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(isActive ? 40 : 0),
              ),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: Color.fromRGBO(35, 41, 41, 0.1),
                    offset: Offset(1, 2),
                    blurRadius: 10,
                  ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: 11),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 70),
                    child: CachedNetworkImage(
                      imageUrl: '${ApiPath.storage}${category.imageUrl}',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const Spacer(),
                Text(category.name, style: AppTypography.font9),
                const Spacer(),
              ],
            ),
          ),
          if (!isActive)
            Container(
              width: 2,
              height: 106,
              color: AppColors.lightBlue,
            ),
        ],
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;

  const _ProductItem({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DetailProductScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(35, 41, 41, 0.1),
              blurRadius: 10,
              offset: Offset(2, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                ),
                CachedNetworkImage(
                  imageUrl: '${ApiPath.storage}${product.productUrl}',
                  width: MediaQuery.of(context).size.width,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 4,
                  top: 9,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                      ),
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '${product.height} г',
                      style: AppTypography.font10.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width : 148,
                        child: Text(
                          product.name,
                          style: AppTypography.font10,
                          maxLines: 15,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${product.price.toString()} ₽',
                        style: AppTypography.font13.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: 29,
                    height: 29,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange,
                    ),
                    child: Center(
                      child: AppIcons.basket(),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MainScreenBloc>();
    final banner = bloc.state.bannerModel;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '${ApiPath.storage}${banner.image}',
          width: MediaQuery.of(context).size.width,
          height: 200,
          fit: BoxFit.fitWidth,
        ),
        Positioned(
          left: 25,
          top: 35,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner.title ?? '',
                style: AppTypography.font36.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 14),
                child: Text(
                  banner.description ?? '',
                  style: AppTypography.font14.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  bloc.setActiveCategory(banner.categoryId);
                },
                child: Container(
                  width: 173,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.yellow,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'перейти'.toUpperCase(),
                          style: AppTypography.font14.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.chevron_right,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
