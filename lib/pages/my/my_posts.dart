import 'dart:developer';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:ourdoctor/global/app_colors.dart';
import 'package:ourdoctor/global/app_styles.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/common_util.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/community_list_res_model.dart';
import 'package:ourdoctor/pages/base/page_layout.dart';
import 'package:ourdoctor/pages/community/community_detail.dart';
import 'package:ourdoctor/pages/components/h12.dart';
import 'package:ourdoctor/pages/components/h14.dart';
import 'package:ourdoctor/pages/components/h18.dart';
import 'package:ourdoctor/pages/components/simple_header.dart';
import 'package:ourdoctor/pages/intro/first.dart';
import 'package:ourdoctor/stores/my_page_store.dart';

class MyPostsPage extends StatefulWidget {
  MyPostsPage({Key? key, required this.like}) : super(key: key);

  int like;

  @override
  State<MyPostsPage> createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  HttpService httpService = HttpService();
  ScrollController _controller = ScrollController();
  final myPageStore = GetIt.I<MyPageStore>();
  bool _isLoading = false;
  bool _isLast = true;
  int _page = 0;

  _loadList() async {
    _isLoading = true;
    setState(() {});

    await myPageStore.loadList(ctx: context, page: _page);
    _isLast = myPageStore.isLast;

    _isLoading = false;
    setState(() {});
  }

  Future<void> loadLikeList() async {
    Future<CommunityListResModel> info = httpService.getMyLikePosts(_page);
    info.then((CommunityListResModel value) async {
      if (value.result == 0) {
        if (_page == 0 && myPageStore.posts.isNotEmpty) {
          myPageStore.posts.clear();
        }
        _isLast = value.data!.isLast!;
        myPageStore.posts.addAll(value.data!.contents!);
        setState(() {});
      } else {
        showToast(value.msg ?? "");
        if (value.result == 106) {
          //token expired
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => FirstPage()));
        }
      }
    }).catchError((onError) {
      showToast(onError.toString());
    });
  }

  _scrollListener() {
    if (!_isLoading) {
      if (_controller.position.pixels == _controller.position.maxScrollExtent) {
        if (_isLast) {
          return;
        }
        _page = _page + 1;
        if (widget.like == 1) {
          loadLikeList();
        } else {
          _loadList();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.like == 1) {
      loadLikeList();
    } else {
      _loadList();
    }
    _controller.addListener(() {
      _scrollListener();
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      isLoading: _isLoading,
      child: Column(
        children: [
          header(),
          _isLoading
          ? const SizedBox()
          : content(),
        ],
      ),
    );
  }

  header() => SimpleHeader(
    title: LanguageService.trans("view_my_posts"),
    onBackPressed: () => Navigator.pop(context),
  );

  content() => Expanded(
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: const Color(0xFFF8F9FA),
      child: Observer(
      builder: (_) => myPageStore.posts.isNotEmpty
        ? list()
        : Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .35),
          child: H18(text: '작성한 게시글이 없습니다.', weight: FW.regular),
        ),
      ),
    ),
  );

  list() =>  Container(
      color: const Color(0xFFF8F9FA),
      child: Observer(
        builder: (_) => ListView.builder(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          itemCount: myPageStore.posts.length,
          controller: _controller,
          itemBuilder: (ctx, idx) {
            final imgUrl = splitImgUrl(myPageStore.posts[idx]);
            return post(myPageStore.posts[idx], imgUrl);
          },
        ),
      ),
  );

  post(CommunityDto post, String imgUrl) => GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: () {
      Navigator.push(context, SlideRightTransRoute(builder: (ctx) => CommunityDetailPage(uid: post.uid)));
    },
    child: Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 32, top: 32, right: 20, bottom: 32),
      height: 140,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Container(
                alignment: Alignment.topLeft,
                width: imgUrl == "" ? MediaQuery.of(context).size.width - 80 : MediaQuery.of(context).size.width - 160,
                child: H18(text: post.title ?? ''),
              ),
              const SizedBox(height: 6),
              H12(
                text: '${diffTime(post.regTime!)}・좋아요 ${post.likeCnt}・댓글 ${post.commentCnt}', 
                color: AppColor_BlackText.withOpacity(.4),
                weight: FW.regular,
              ),
              const SizedBox(height: 14),
              Container(
                width: post.imgUrls!.isNotEmpty ? 220 : 300,
                child: H14(
                  text: post.content ?? '', 
                  weight: FW.regular, 
                  align: TextAlign.left,
                  maxLine: 1,
                  ellipsis: true,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          post.imgUrls!.isNotEmpty 
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ExtendedImage.network(
                imgUrl,
                width: 73,
                height: double.infinity,
                fit: BoxFit.fill,
                cache: true,
              ),
          )
          : const SizedBox(),
        ],
      ),
    ),
  );

  splitImgUrl(CommunityDto post) {
    if (post == null || post.imgUrls!.isEmpty) {
      return '';
    }

    var imgUrls = post.imgUrls!;
    var lastChar = imgUrls.substring(imgUrls.length - 1, imgUrls.length);
    if (lastChar == ",") {
      imgUrls = imgUrls.substring(0, imgUrls.length - 1);
    }
    var arr = imgUrls.split(",");
    return arr[0].toString();
  }
}