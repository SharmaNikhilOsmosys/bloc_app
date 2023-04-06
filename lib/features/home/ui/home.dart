import 'package:bloc_app/features/cart/ui/cart.dart';
import 'package:bloc_app/features/home/bloc/home_bloc.dart';
import 'package:bloc_app/features/home/ui/product_tile_widget.dart';
import 'package:bloc_app/features/wishlist/ui/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeBloc homeBloc = HomeBloc();
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToWishListPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WishList()));
        }
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cart()));
        }
      },
      bloc: homeBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Groceries'),
                actions: [
                  IconButton(
                      onPressed: () =>
                          {homeBloc.add(HomeWishlistButtonNavigateEvent())},
                      icon: Icon(Icons.favorite_outline)),
                  IconButton(
                      onPressed: () =>
                          {homeBloc.add(HomeCartButtonNavigateEvent())},
                      icon: Icon(Icons.shopping_cart_outlined)),
                ],
              ),
              body: ListView.builder(
                  itemCount: successState.products.length,
                  itemBuilder: (BuildContext context, int index) =>
                      ProductTileWidget(
                          productDataModel: successState.products[index])),
            );
          case HomeErrorState:
            return Scaffold(
              body: Center(
                child: Text('Error'),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}
