import 'package:sixam_mart/features/category/domain/models/category_model.dart';
import 'package:sixam_mart/features/item/domain/models/item_model.dart';
import 'package:sixam_mart/features/store/domain/models/store_model.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/features/category/domain/services/category_service_interface.dart';

class CategoryController extends GetxController implements GetxService {
  final CategoryServiceInterface categoryServiceInterface;
  CategoryController({required this.categoryServiceInterface});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? _subCategoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;

  List<Item>? _categoryItemList;
  List<Item>? get categoryItemList => _categoryItemList;

  List<Store>? _categoryStoreList;
  List<Store>? get categoryStoreList => _categoryStoreList;

  List<Item>? _searchItemList = [];
  List<Item>? get searchItemList => _searchItemList;

  List<Store>? _searchStoreList = [];
  List<Store>? get searchStoreList => _searchStoreList;

  List<bool>? _interestSelectedList;
  List<bool>? get interestSelectedList => _interestSelectedList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _pageSize;
  int? get pageSize => _pageSize;

  int? _restPageSize;
  int? get restPageSize => _restPageSize;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  int _subCategoryIndex = 0;
  int get subCategoryIndex => _subCategoryIndex;

  String _type = 'all';
  String get type => _type;

  bool _isStore = false;
  bool get isStore => _isStore;

  String? _searchText = '';
  String? get searchText => _searchText;

  int _offset = 1;
  int get offset => _offset;

  // Future<void> getCategoryList(bool reload, {bool allCategory = false}) async {
  //   if (_categoryList == null || reload) {
  //     _categoryList = null;
  //     List<CategoryModel>? categoryList =
  //         await categoryServiceInterface.getCategoryList(allCategory);

     
  //     if (categoryList != null) {
  //       _categoryList = [];
  //       _interestSelectedList = [];
  //       _categoryList!.addAll(categoryList);
  //       for (var column in _categoryList!) {
  //         //    print('category list harsh -->${column.toJson()})');

  //         getCategoryItemList1(column.id.toString(), 0, "all", true);
  //       }

  //       for (int i = 0; i < _categoryList!.length; i++) {
  //         _interestSelectedList!.add(false);
  //       }
  //     }
  //     update();
  //   }
  // }



  void getSubCategoryList(String? categoryID) async {
    _subCategoryIndex = 0;
    _subCategoryList = null;
    _categoryItemList = null;
    List<CategoryModel>? subCategoryList =
        await categoryServiceInterface.getSubCategoryList(categoryID);
    if (subCategoryList != null) {
      _subCategoryList = [];
      _subCategoryList!
          .add(CategoryModel(id: int.parse(categoryID!), name: 'all'.tr));
      _subCategoryList!.addAll(subCategoryList);
      getCategoryItemList(categoryID, 1, 'all', false);
    }
  }

  void setSubCategoryIndex(int index, String? categoryID) {
    _subCategoryIndex = index;
    if (_isStore) {
      getCategoryStoreList(
          _subCategoryIndex == 0
              ? categoryID
              : _subCategoryList![index].id.toString(),
          1,
          _type,
          true);
    } else {
      getCategoryItemList(
          _subCategoryIndex == 0
              ? categoryID
              : _subCategoryList![index].id.toString(),
          1,
          _type,
          true);
    }
  }

  void getCategoryItemList(
      String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _categoryItemList = null;
    }
    
      ItemModel? categoryItem = await categoryServiceInterface
        .getCategoryItemList(categoryID, offset, type);
   // print("category Item harsh");
    print('category Item harsh - ${categoryItem!.items}');
  //  print("category Item harsh");

   if (categoryItem != null) {
      
      if (offset == 1) {
        _categoryItemList = [];
      }
      _categoryItemList!.addAll(categoryItem.items ?? []);
      _pageSize = categoryItem.totalSize;
      print("category Item harsh inside categoryItem ${_categoryItemList!}");
      _isLoading = false;
    
    }
     update();
    
  }
 
 


Future<void> getCategoryList(bool reload, {bool allCategory = false}) async {
  if (_categoryList == null || reload) {
    _categoryList = [];
    _interestSelectedList = [];
    _isLoading = true;
    update(); // Notify loading state

    // Fetch category list
    List<CategoryModel>? categoryList =
        await categoryServiceInterface.getCategoryList(allCategory);

    if (categoryList != null) {
      _categoryList!.addAll(categoryList);

    //  print('caregory list--> ${categoryList.toList()}');

      for (var column in _categoryList!) {
        print('category list harsh -->${column.toJson()})');
        await getCategoryItemList1(column.id.toString(), 0, "all", true);
      }

      _interestSelectedList = List.generate(_categoryList!.length, (index) => false);
    }

    _isLoading = false;
    update(); // Notify listeners
  }
}










Future<List<Item>> getCategoryItemList1(
     categoryID,  offset, String type, bool notify) async {
  _offset = offset;

  // Initialize if null
  _categoryItemList ??= [];

  _isLoading = true;
  update(); // Notify loading state

  try {
    // Fetch data
    ItemModel? categoryItem =
        await categoryServiceInterface.getCategoryItemList(categoryID, offset, type);

    if (categoryItem != null) {
      // Debugging logs
      print('Category list item harsh --> ${categoryItem.toJson()}');
      print('Current Category ItemList length: ${_categoryItemList!.length}');

      // Directly assign if items are already of type List<Item>
      if (categoryItem.items is List<Item>) {
        return categoryItem.items as List<Item>;
      }

      // Parse items if they are in Map<String, dynamic> format
      final List<Item> items = (categoryItem.items ?? [])
          .map((item) => Item.fromJson(item as Map<String, dynamic>))
          .toList();

      // Update the page size
      _pageSize = categoryItem.totalSize ?? 0;

      return items; // Return the parsed items
    }
  } catch (e) {
    print('Error fetching category items: $e');
  } finally {
    _isLoading = false;
    if (notify) update(); // Notify listeners of state change
  }

  // Return an empty list if no items or on failure
  return [];
}



















//  void getCategoryItemList1(
//       String? categoryID, int offset, String type, bool notify) async {
//     _offset = offset;
//       _isLoading = false;
//       update();
//     // if (offset == 1) {
//     //   if (_type == type) {
//     //     _isSearching = false;
//     //   }
//     //   _type = type;    
//     //   _categoryItemList = null;
//     // }   
//       ItemModel? categoryItem = await categoryServiceInterface
//         .getCategoryItemList(categoryID, offset, type);
//    // print("category Item harsh");
//     print('category Item harsh - ${categoryItem!.items}');
//   //  print("category Item harsh");
//    // if (categoryItem != null) {    
//       // if (offset == 1) {
//        _categoryItemList = [];
//       // }
//       _categoryItemList!.addAll(categoryItem.items ?? []);
//       _pageSize = categoryItem.totalSize;
//       print("category Item harsh inside categoryItem ${_categoryItemList!}");   
//    // }
//     // update();category Item   
//       if (notify)  update();
//   }
 
 
//  void getCategoryItemList1(
//     String? categoryID, int offset, String type, bool notify) async {
//   _offset = offset;
//   _isLoading = true;
//   update(); // Notify loading state
//   ItemModel? categoryItem = await categoryServiceInterface
//       .getCategoryItemList(categoryID, offset, type);
//   if (categoryItem != null) {
//     _categoryItemList ??= [];
//     _categoryItemList!.addAll(categoryItem.items ?? []);
//     _pageSize = categoryItem.totalSize;
//   }
//   _isLoading = false;
//   if (notify) update(); // Notify changes
// }

 
 
 
 
 
 
 
  void getCategoryStoreList(
      String? categoryID, int offset, String type, bool notify) async {
    _offset = offset;
    if (offset == 1) {
      if (_type == type) {
        _isSearching = false;
      }
      _type = type;
      if (notify) {
        update();
      }
      _categoryStoreList = null;
    }
    StoreModel? categoryStore = await categoryServiceInterface
        .getCategoryStoreList(categoryID, offset, type);
    if (categoryStore != null) {
      if (offset == 1) {
        _categoryStoreList = [];
      }
      _categoryStoreList!.addAll(categoryStore.stores!);
      _restPageSize = categoryStore.totalSize;
      _isLoading = false;
    }
    update();
  }

  void searchData(String? query, String? categoryID, String type) async {
    if ((_isStore && query!.isNotEmpty) ||
        (!_isStore && query!.isNotEmpty /*&& query != _itemResultText*/)) {
      _searchText = query;
      _type = type;
      _isStore ? _searchStoreList = null : _searchItemList = null;
      _isSearching = true;
      update();

      Response response = await categoryServiceInterface.getSearchData(
          query, categoryID, _isStore, type);
      if (response.statusCode == 200) {
        if (query.isEmpty) {
          _isStore ? _searchStoreList = [] : _searchItemList = [];
        } else {
          if (_isStore) {
            _searchStoreList = [];
            _searchStoreList!
                .addAll(StoreModel.fromJson(response.body).stores!);
            update();
          } else {
            _searchItemList = [];
            _searchItemList!.addAll(ItemModel.fromJson(response.body).items!);
          }
        }
      }
      update();
    }
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    _searchItemList = [];
    if (_categoryItemList != null) {
      _searchItemList!.addAll(_categoryItemList!);
    }
    update();
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  Future<bool> saveInterest(List<int?> interests) async {
    _isLoading = true;
    update();
    bool isSuccess =
        await categoryServiceInterface.saveUserInterests(interests);
    _isLoading = false;
    update();
    return isSuccess;
  }

  void addInterestSelection(int index) {
    _interestSelectedList![index] = !_interestSelectedList![index];
    update();
  }

  void setRestaurant(bool isRestaurant) {
    _isStore = isRestaurant;
    update();
  }
}
