import 'package:sixam_mart/features/category/controllers/category_controller.dart';
import 'package:sixam_mart/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart/helper/route_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:sixam_mart/common/widgets/custom_image.dart';
import 'package:sixam_mart/common/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../language/controllers/language_controller.dart';

class CategoryProducstView extends StatefulWidget {
  const CategoryProducstView({Key? key}) : super(key: key);

  @override
  State<CategoryProducstView> createState() => _CategoryProducstViewState();
}

class _CategoryProducstViewState extends State<CategoryProducstView> {
  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
          categoryController.categoryList!.isEmpty)
          ? const SizedBox()
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TitleWidget(
                title: 'categories'.tr,
                onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
          ),
          if (categoryController.categoryList != null) ...[
            SizedBox(
              height: 188,
              child: GridView.builder(
                // shrinkWrap :true,
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 0.0),
                  itemCount: categoryController.categoryList!.length,

                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        if(index == 9 && categoryController.categoryList!.length > 10) {
                          Get.toNamed(RouteHelper.getCategoryRoute());
                        } else {
                          Get.toNamed(RouteHelper.getCategoryItemRoute(
                            categoryController.categoryList![index].id, categoryController.categoryList![index].name!,
                          ));
                        }
                      },
                      child: SizedBox(
                        width: 60,
                        child: Column(children: [
                          SizedBox(
                            height: 60, width: 60,
                            child: Stack(children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFfff6fb),
                                  //borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                    //shape: BoxShape.circle
                                ),
                                child: CustomImage(
                                  image: '${categoryController.categoryList![index].imageFullUrl}',
                                  height: 60, width: 60, fit: BoxFit.cover,
                                ),
                              ),

                            ]),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Padding(
                            padding: EdgeInsets.only(right: index == 0 ? Dimensions.paddingSizeExtraSmall : 0),
                            child: Text(
                              /* (index == categoryController.categoryList!.length -1 && categoryController.categoryList!.length > 10) ? 'see_all'.tr :*/ categoryController.categoryList![index].name!,
                              style: robotoMedium.copyWith(fontSize: 11, color: (index == 9 && categoryController.categoryList!.length > 10) ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium!.color),
                              maxLines: Get.find<LocalizationController>().isLtr ? 2 : 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                            ),
                          ),

                        ]),
                      ),
                    );

                  }),
            )
          ] else ...[
            CategoryShimmer(categoryController: categoryController)
          ],
          const SizedBox(
            height: 10,
          ),
        ],
      );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;

  const CategoryShimmer({Key? key, required this.categoryController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, crossAxisSpacing: 4.0, mainAxisSpacing: 10.0),
        itemCount: 8,
        padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Container(
                // height: 65,
                // width: 65,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


