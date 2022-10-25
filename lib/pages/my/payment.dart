import 'package:flutter/material.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:ourdoctor/global/global.dart';
import 'package:ourdoctor/global/http_service.dart';
import 'package:ourdoctor/helpers/transition.dart';
import 'package:ourdoctor/language/language_service.dart';
import 'package:ourdoctor/models/order_detail_res_model.dart';
import 'package:ourdoctor/pages/base/base_state.dart';

import '../app_event.dart';
import 'order_complete.dart';

class PaymentPage extends StatefulWidget {
  String? payMethod;
  String? merchantUid;
  int? orderID;
  int? totalMoney;

  PaymentPage({
    Key? key,
    this.payMethod,
    this.merchantUid,
    this.orderID,
    this.totalMoney,
  }) : super(key: key) {
    this.payMethod ??= "CARD";
    this.merchantUid ??= "";
    this.orderID ??= 0;
    this.totalMoney ??= 0;
  }

  @override
  PaymentPageState createState() => PaymentPageState();
}

class PaymentPageState extends BaseState<PaymentPage> {
  String title = "";
  String payMethod = "";

  final HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    print(widget.orderID!.toString());
    print(gUserInfo!.id!);
    if (widget.payMethod == "CARD") {
      title = LanguageService.trans("card");
      payMethod = "card";
    } else if (widget.payMethod == "TRANS") {
      title = LanguageService.trans("deposit_without_bankbook");
      payMethod = "trans";
    } else if (widget.payMethod == "PHONE") {
      title = LanguageService.trans("mobile");
      payMethod = "phone";
    }
    setState(() {});

    eventBus.on<PaymentFinish>().listen((event) {
      if (mounted) {
        if (event.order_id == widget.orderID.toString()) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => OrderCompletePage(orderID: widget.orderID)));
        }
      }
    });
  }

  Future<bool> onBackPressed() async {
    Navigator.pop(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return IamportPayment(
      appBar: AppBar(
        title: Text(title),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              //Image.asset('assets/images/iamport-logo.png'),
              Padding(padding: EdgeInsets.symmetric(vertical: 15)),
              Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      // userCode: 'imp46037969',
      userCode: 'imp45752383',
      /* [필수입력] 결제 데이터 */
      data: PaymentData(
        pg: 'html5_inicis',
        // PG사
        payMethod: payMethod,
        // 결제수단
        name: '상품 결제',
        // 주문명
        merchantUid: widget.merchantUid!,
        // 주문번호
        amount: widget.totalMoney!,
        // 결제금액
        buyerName: gUserInfo!.name!,
        // 구매자 이름
        buyerTel: gUserInfo!.phone!,
        // 구매자 연락처
        buyerEmail: "",
        // 구매자 이메일
        buyerAddr: gUserInfo!.deliverAddress! + " " + gUserInfo!.deliverAddressDetail!,
        // 구매자 주소
        buyerPostcode: gUserInfo!.deliverPostcode,
        // 구매자 우편번호
        appScheme: 'ourdoctor',
        // 앱 URL scheme
        displayCardQuota: [2, 3],
        //결제창 UI 내 할부개월수 제한
        digital: false,
        mRedirectUrl: API_BASE_URL + "api/Order/pay_complete",
      ),
      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        /*
        String status = result["success"] ?? ""; //성공 여부
        print(status);
        String imp_uid = result["imp_uid"] ?? ""; //아임포트 번호
        print(imp_uid);
        String merchant_uid = result["merchant_uid"] ?? ""; //주문번호
        print(merchant_uid);
        String error_msg = result["error_msg"] ?? ""; //실패한 경우, 에러메시지
        print(error_msg);

        payConfirm(imp_uid, merchant_uid);

        String makeContent = "";
        makeContent = "성공 여부 : " + status;
        makeContent = makeContent + "\n아임포트 번호 : " + imp_uid;
        makeContent = makeContent + "\n주문번호 : " + merchant_uid;
        makeContent = makeContent + "\n실패한 경우, 에러메시지 : " + error_msg;
        showDialog(context: context, builder: (_) => OneBtnTitleDialog(title: title, content: makeContent));
         */
        getOrder();
      },
    );
  }

  bool getIsSuccessed(Map<String, String> result) {
    if (result['imp_success'] == 'true') {
      return true;
    }
    if (result['success'] == 'true') {
      return true;
    }
    return false;
  }

  Future<void> getOrder() async {
    setState(() {
      isLoading = true;
    });
    Future<OrderDetailResModel> info = httpService.getOrderDetail(widget.orderID!.toString());
    info.then((OrderDetailResModel value) async {
      setState(() {
        isLoading = false;
      });
      if (value.result == 0) {
        OrderDto? order = value.data;

        if (int.parse(order!.status!) == 1 || int.parse(order.status!) == 2) {
          Navigator.pop(context);
          Navigator.pushReplacement(context, SlideRightTransRoute(builder: (context) => OrderCompletePage(orderID: widget.orderID)));
        }
      }
    }).catchError((onError) {
      setState(() {
        isLoading = false;
      });
    });
  }
}
