import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maccave/models/bannermodel.dart';
import 'package:maccave/models/commentmodel.dart';
import 'package:maccave/models/cummunitymodel.dart';
import 'package:maccave/models/drinkmodel.dart';
import 'package:maccave/models/entrymodel.dart';
import 'package:maccave/models/gallerymodel.dart';
import 'package:maccave/models/marketmodel.dart';
import 'package:maccave/models/privacysmodel.dart';
import 'package:maccave/models/usermodel.dart';

class FireStoreData {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;
  static final _userColection = _db.collection('users');
  static final _bannerColection = _db.collection('banners');
  static final _drinkColection = _db.collection('drinks');
  static final _entryColection = _db.collection('entrys');
  static final _marketColection = _db.collection('markets');
  static final _commentColection = _db.collection('comments');
  static final _cummunityColection = _db.collection('cummunitys');
  static final _galleryColection = _db.collection('gallerys');
  static final _privacysColection = _db.collection('privacys');
  static final _storage = FirebaseStorage.instance;

  static Future<List<BannerModel>> getBanners() async {
    List<BannerModel> bannerInstances = [];
    final querySnapshot = await _bannerColection.get();
    bannerInstances = querySnapshot.docs
        .map((banner) =>
            BannerModel.fromJson({"id": banner.id, ...banner.data()}))
        .toList();
    return bannerInstances;
  }

  static Future<UserModel> getUser({String? id}) async {
    UserModel userInstances;
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot;
    if (id != null) {
      documentSnapshot = await _userColection.doc(id).get();
    } else {
      documentSnapshot = await _userColection.doc(_auth.currentUser!.uid).get();
    }
    if (documentSnapshot.exists) {
      userInstances = UserModel.fromJson(
          {"id": documentSnapshot.id, ...documentSnapshot.data()!});
      return userInstances;
    }
    throw Error();
  }

  static Future<bool> updateUser(
      {required String id, CroppedFile? cropFile, String? name}) async {
    bool userInstances = false;
    Map<String, dynamic>? data;

    if (cropFile != null) {
      final filename = cropFile.path.split('/');
      final path = 'user/$id/${filename[filename.length - 1]}';
      final file = File(cropFile.path);
      final ref = _storage.ref(path);
      final snapshot = await ref.putFile(file);
      final url = await snapshot.ref.getDownloadURL();

      if (name != null) {
        data = {"image": url, "name": name};
      } else {
        data = {"image": url};
      }
    } else if (name != null) {
      data = {"name": name};
    }
    if (data != null) {
      try {
        await _userColection
            .doc(id)
            .update(data)
            .then((value) => userInstances = true);
      } catch (e) {
        print('업데이트 에러');
      }
    }

    return userInstances;
  }

  static Future<List<CummunityModel>> getUserOnlyCummunity(String id) async {
    List<CummunityModel> cummunityInstances = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _cummunityColection.where('userid', isEqualTo: id).get();
    if (querySnapshot.docs.isNotEmpty) {
      cummunityInstances = querySnapshot.docs
          .map<CummunityModel>((cummunity) => CummunityModel.fromJson(
              {"id": cummunity.id, ...cummunity.data()}))
          .toList();
    }
    return cummunityInstances;
  }

  static Future<List<GalleryModel>> getUserOnlyGallery(String id) async {
    List<GalleryModel> galleryInstances = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _galleryColection.where('userid', isEqualTo: id).get();
    if (querySnapshot.docs.isNotEmpty) {
      galleryInstances = querySnapshot.docs
          .map<GalleryModel>((cummunity) =>
              GalleryModel.fromJson({"id": cummunity.id, ...cummunity.data()}))
          .toList();
    }
    return galleryInstances;
  }

  static Future<List<DrinkModel>> getUserLikeDrinks(
      List<dynamic> likeDrinks) async {
    List<DrinkModel> drinkInstances = [];
    final querySnapshot = await Future.wait(
        likeDrinks.map((drinkid) => _drinkColection.doc(drinkid).get()));
    drinkInstances = querySnapshot
        .map<DrinkModel>(
            (drink) => DrinkModel.fromJson({"id": drink.id, ...drink.data()!}))
        .toList();

    return drinkInstances;
  }

  static Future<List<EntryModel>> getEntrys({String? type, String? id}) async {
    List<EntryModel> drinksInstances = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot;
    try {
      if (type != null) {
        querySnapshot =
            await _entryColection.where('type', isEqualTo: type).get();
      } else if (id != null) {
        querySnapshot =
            await _entryColection.where('drinkid', isEqualTo: id).get();
      } else {
        querySnapshot = await _entryColection.get();
      }

      drinksInstances = querySnapshot.docs
          .map<EntryModel>(
              (entry) => EntryModel.fromJson({'id': entry.id, ...entry.data()}))
          .toList();
      return drinksInstances;
    } catch (e) {
      print('getEntrys err');
      print(e.toString());
      return drinksInstances;
    }
  }

  static Future<EntryModel> getEntryItem(String id) async {
    EntryModel entryItemInstances;
    try {
      final documentSnapshot = await _entryColection.doc(id).get();
      if (documentSnapshot.exists) {
        final mapdata = {
          'id': documentSnapshot.id,
          ...documentSnapshot.data()!
        };
        entryItemInstances = EntryModel.fromJson(mapdata);
        return entryItemInstances;
      }
    } catch (e) {
      print('getEntryItem err');
      print(e.toString());
    }
    throw Error();
  }

  static Future<DrinkModel> getDrinkItem(String? id) async {
    DrinkModel drinkItemInstances;
    try {
      final documentSnapshot = await _drinkColection.doc(id).get();
      if (documentSnapshot.exists) {
        final mapdata = {
          'id': documentSnapshot.id,
          ...documentSnapshot.data()!
        };
        drinkItemInstances = DrinkModel.fromJson(mapdata);
        return drinkItemInstances;
      }
    } catch (e) {
      print('getDrinkItem err');
      print(e.toString());
    }
    throw Error();
  }

  static Future<List<MarketModel>> getMarkets(String id) async {
    List<MarketModel> marketItemInstances = [];
    final queryDocumentSnapshot =
        await _marketColection.where('entryid', isEqualTo: id).get();
    marketItemInstances = queryDocumentSnapshot.docs
        .map<MarketModel>(
          (market) => MarketModel.fromJson(
            {
              'id': market.id,
              ...market.data(),
            },
          ),
        )
        .toList();
    return marketItemInstances;
  }

  static Future<MarketModel> getMarketItem(String? id) async {
    MarketModel marketItemInstances;
    try {
      final documentSnapshot = await _marketColection.doc(id).get();
      if (documentSnapshot.exists) {
        final mapdata = {
          'id': documentSnapshot.id,
          ...documentSnapshot.data()!
        };
        marketItemInstances = MarketModel.fromJson(mapdata);
        return marketItemInstances;
      }
    } catch (e) {
      print('getMarketItem err');
      print(e.toString());
    }
    throw Error();
  }

  static Future<List<CommentModel>> getComments(String id) async {
    List<CommentModel> commentInstances = [];
    final querySnapshot =
        await _commentColection.where('typeid', isEqualTo: id).get();
    commentInstances = querySnapshot.docs
        .map<CommentModel>((comment) =>
            CommentModel.fromJson({"id": comment.id, ...comment.data()}))
        .toList();
    return commentInstances;
  }

  static Future<int> getCommentsCount(String id) async {
    int countInstance = 0;
    final aggregateQuery =
        await _commentColection.where('typeid', isEqualTo: id).count().get();
    countInstance = aggregateQuery.count;
    return countInstance;
  }

  static bool setComment(String comment, String typeid) {
    bool result = false;
    final createdate = DateTime.now();

    final setData = {
      "userid": _auth.currentUser!.uid,
      "comment": comment,
      "likes": [],
      "typeid": typeid,
      "createdate": createdate,
    };
    _commentColection.add(setData);
    result = true;
    return result;
  }

  static Future<bool> setCummunity(
      String type, String title, String content) async {
    bool result = false;
    final createdate = DateTime.now();

    final setData = {
      "type": type,
      "title": title,
      "content": content,
      "userid": _auth.currentUser!.uid,
      "createdate": createdate,
    };
    await _cummunityColection.add(setData).then((value) => result = true);
    return result;
  }

  static Future<bool> updateCummunity(
      String id, String type, String title, String content) async {
    bool result = false;

    final editData = {
      "type": type,
      "title": title,
      "content": content,
    };
    await _cummunityColection
        .doc(id)
        .update(editData)
        .then((value) => result = true);
    return result;
  }

  static Future<CummunityModel?> getCummunity(String id) async {
    CummunityModel cummunityInstances;
    try {
      final documentSnapshot = await _cummunityColection.doc(id).get();
      if (documentSnapshot.exists) {
        cummunityInstances = CummunityModel.fromJson(
            {"id": documentSnapshot.id, ...documentSnapshot.data()!});

        return cummunityInstances;
      }
    } catch (e) {
      print('firebase exception');
      return null;
    }
    return null;
  }

  static Future<List<CummunityModel>> getCummunitys(String tyep) async {
    List<CummunityModel> cummunitysInstances = [];
    QuerySnapshot<Map<String, dynamic>> querySnapshot;

    if (tyep != '전체글') {
      querySnapshot = await _cummunityColection
          .where('type', isEqualTo: tyep)
          .orderBy('createdate', descending: true)
          .get();
    } else {
      querySnapshot = await _cummunityColection
          .orderBy('createdate', descending: true)
          .get();
    }
    cummunitysInstances = querySnapshot.docs
        .map<CummunityModel>((cummunity) =>
            CummunityModel.fromJson({"id": cummunity.id, ...cummunity.data()}))
        .toList();
    return cummunitysInstances;
  }

  static Future<bool> removeCummunity(String id) async {
    bool cummunitysInstances = false;
    try {
      await _cummunityColection
          .doc(id)
          .delete()
          .then((doc) => cummunitysInstances = true);
      return cummunitysInstances;
    } catch (e) {
      return cummunitysInstances;
    }
  }

  static Future<List<GalleryModel>> getGallerys() async {
    List<GalleryModel> gallerysInstances = [];
    final querySnapshot = await _galleryColection.get();
    gallerysInstances = querySnapshot.docs
        .map(
          (gallery) => GalleryModel.fromJson({
            "id": gallery.id,
            ...gallery.data(),
          }),
        )
        .toList();
    return gallerysInstances;
  }

  static Future<GalleryModel?> getGalleryItem(String id) async {
    GalleryModel galleryInstances;
    try {
      final documentSnapshot = await _galleryColection.doc(id).get();
      if (documentSnapshot.exists) {
        galleryInstances = GalleryModel.fromJson(
            {"id": documentSnapshot.id, ...documentSnapshot.data()!});
        return galleryInstances;
      }
    } on FirebaseException catch (e) {
      print('파이어베이스 에러');
      return null;
    }
    return null;
  }

  static Future<int> getGalleryCount(String id) async {
    int countInstance = 0;
    final aggregateQuery = await _userColection
        .where('gallerylikes', arrayContains: id)
        .count()
        .get();
    countInstance = aggregateQuery.count;
    return countInstance;
  }

  static Future<String> _setStorage(String mainpath, XFile xFile) async {
    String url = '';
    final path = '$mainpath/${_auth.currentUser!.uid}/${xFile.name}';
    final file = File(xFile.path);
    final ref = _storage.ref(path);
    final snapshot = await ref.putFile(
      file,
    );
    url = await snapshot.ref.getDownloadURL();
    return url;
  }

  static Future<void> _delStorage(String mainpath, String xFile) async {
    final path = '$mainpath/${_auth.currentUser!.uid}/${xFile}';
    final ref = _storage.ref(path);
    await ref.delete();
  }

  static Future<bool> setGallerys(String title, List<XFile> images) async {
    final createdate = DateTime.now();
    bool galleryInstance = false;
    late Map<String, dynamic> data;
    try {
      data = await Future.wait(images
              .map((xFile) async => await _setStorage('gallerys', xFile))
              .toList())
          .then((urls) {
        return {
          "title": title,
          "images": urls,
          "userid": _auth.currentUser!.uid,
          "likes": [],
          "createdate": createdate,
        };
      });
      await _galleryColection.add(data);
      galleryInstance = true;
      return galleryInstance;
    } catch (e) {
      return galleryInstance;
    }
  }

  static Future<bool> updateGallery(String id, String title) async {
    bool galleryInstances = false;
    final data = {"title": title};
    try {
      await _galleryColection
          .doc(id)
          .update(data)
          .then((value) => galleryInstances = true);
      return galleryInstances;
    } catch (e) {
      print('updateGallery false');
      return galleryInstances;
    }
  }

  static Future<bool> removeGalleryItem(String id) async {
    bool cummunitysInstances = false;
    try {
      await _galleryColection.doc(id).delete();
      cummunitysInstances = true;
      return cummunitysInstances;
    } catch (e) {
      print('removeGalleryItem err');
      return cummunitysInstances;
    }
  }

  static Future<bool> getFavorite(String id, String type) async {
    bool favoriteInstance = false;
    final documentSnapshot =
        await _userColection.doc(_auth.currentUser!.uid).get();
    if (documentSnapshot.exists &&
        (documentSnapshot.data()![type] as List<dynamic>).contains(id)) {
      favoriteInstance = true;
    }
    return favoriteInstance;
  }

  static Future<void> setFavorite(String id, String type) async {
    final documentSnapshot =
        await _userColection.doc(_auth.currentUser!.uid).get();
    if (documentSnapshot.exists) {
      final listtemp = (documentSnapshot.data()![type] as List<dynamic>);
      if (listtemp.contains(id)) {
        _userColection.doc(_auth.currentUser!.uid).update({
          type: FieldValue.arrayRemove([id])
        });
      } else {
        _userColection.doc(_auth.currentUser!.uid).update({
          type: FieldValue.arrayUnion([id])
        });
      }
    }
  }

  static Future<int> getCumAndGallCount(String id) async {
    int countInstance = 0;
    final cumAggregateQuery =
        await _cummunityColection.where('userid', isEqualTo: id).count().get();
    final gallAggregateQuery =
        await _galleryColection.where('userid', isEqualTo: id).count().get();
    countInstance = cumAggregateQuery.count + gallAggregateQuery.count;
    return countInstance;
  }

  static Future<PrivacysModel> getPrivacys(String id) async {
    late PrivacysModel privacysInstance;
    try {
      final documentSnapshot = await _privacysColection.doc(id).get();
      if (documentSnapshot.exists) {
        privacysInstance = PrivacysModel.fromJson({
          "id": documentSnapshot.id,
          ...documentSnapshot.data()!,
        });
      }
    } catch (e) {}
    return privacysInstance;
  }
}
