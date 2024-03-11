import 'package:delivery_app/features/view/admin/widgets/mytextwidget.dart';
import 'package:delivery_app/const/controllers.dart';
import 'package:delivery_app/const/utils.dart';
import 'package:delivery_app/features/view/user/commonWidgets/cartbadgeWidget.dart';
import 'package:delivery_app/features/view/user/commonWidgets/productCardWidget.dart';
import 'package:delivery_app/models/categoryModel.dart';
import 'package:delivery_app/features/view/user/home/homeSubScreeen/productsByCategoryScreen.dart';
import 'package:delivery_app/features/view/user/home/homeSubScreeen/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            ///custom app bar
            _homeAppBar(),

            SliverToBoxAdapter(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 15),
                      child: MyText(
                        text: "Categories",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),

                    ///show all categories with gridview

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          ...categoryController.categories.map((element) {
                            final index =
                                categoryController.categories.indexOf(element);

                            return GestureDetector(
                              onTap: (){
                                navigatorPush(context, ProductByCategory(category: element.categoryName.toString()));
                              },
                              child: Container(
                                width: 125,
                                // height: 165,
                                constraints: BoxConstraints(),
                                margin: index == 0
                                    ? EdgeInsets.only(left: 15)
                                    : EdgeInsets.symmetric(horizontal: 5),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: getColorByCode(
                                    element.colorCode.toString(),
                                  ).withOpacity(0.2),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Image.network(
                                        "${element.categoryImage}",
                                        fit: BoxFit.cover,
                                        // width: 65,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      // width: double.infinity,
                                      child: Center(
                                        child: Text("${element.categoryName}"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        ],
                      ),
                    ),



                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 15,top: 25),
                      child: MyText(
                        text: "Products",
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),


                    ...productController.products.map((element){
                      return Column(
                        children: [
                          ProductCardWidget(product: element, onTap: (){}, backgroundColor: Colors.white),
                          SizedBox(height: 10),
                        ],
                      );
                    }).toList()

                    // () => GridView.builder(
                    //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: categoryController.categories.length,
                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     crossAxisCount: 3,
                    //     mainAxisSpacing: 15,
                    //     crossAxisSpacing: 10,
                    //     childAspectRatio: 0.75,
                    //   ),
                    //   itemBuilder: (context, index) {
                    //     CategoryModel category =
                    //         categoryController.categories[index];
                    //     return _categoryGridWidget(category, context);
                    //   },
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///category card widget to show each category
  GestureDetector _categoryGridWidget(
      CategoryModel category, BuildContext context) {
    return GestureDetector(
      onTap: () {
        userProductController
            .getProductsbyCategory(category.categoryName.toString());
        navigatorPush(
          context,
          ProductByCategory(category: category.categoryName.toString()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              blurRadius: 10,
              color: Colors.grey.shade100,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: getColorByCode(category.colorCode.toString())
                    .withOpacity(0.3),
              ),
              child: Image.network(
                "${category.categoryImage}",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 9),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: MyText(
                      text: category.categoryName.toString(),
                      fontSize: 13,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///cusom sliver appbar
  SliverAppBar _homeAppBar() {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.grey.shade50,
      pinned: true,
      title: Text("Home"),
      expandedHeight: 200,
      actions: [CartBadgeWidget(context: context)],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.grey.shade50,
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.only(top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Got Delivered",
                      fontSize: 15,
                      color: Colors.grey.shade700,
                    ),
                    MyText(text: "everything you need", fontSize: 22),
                  ],
                ),
              ),
              SizedBox(height: 15),
              FakeSearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class FakeSearchBar extends StatelessWidget {
  const FakeSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //navigate to search screen
        navigatorPush(context, SearchScreen());
      },
      child: Container(
        width: double.infinity,
        height: 45,
        margin: EdgeInsets.symmetric(horizontal: 15),
        padding: EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              Ionicons.search,
              color: Theme.of(context).primaryColor,
            ),
            SizedBox(width: 15),
            MyText(text: "Search Items or Products", color: Colors.grey)
          ],
        ),
      ),
    );
  }
}
