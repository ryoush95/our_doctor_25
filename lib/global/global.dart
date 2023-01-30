//user level
import 'package:event_bus/event_bus.dart';
import 'package:ourdoctor/models/app_res_model.dart';
import 'package:ourdoctor/models/childinfo_res_model.dart';
import 'package:ourdoctor/models/login_res_model.dart';
import 'package:ourdoctor/models/monitor_day_res_model.dart';
import 'package:ourdoctor/pages/monitoring/monitoring_main.dart';

String CUSTOMER_CENTER = "admin@kyadmeeting.com";
const String API_BASE_URL = "http://wooadoctor.com:3000/"; //real server
// const String API_BASE_URL = "http://192.168.0.22:8207/"; //local server
//마캣 url
const String APPSTORE_URL = "http://itunes.apple.com/app/id1607310254?mt=8"; //앱스토어
const String MARKET_URL = "https://play.google.com/store/apps/details?id=com.kyad.ourdoctor"; //구글 마캣
const String ONESOTRE_URL = "https://onesto.re/0000761223"; //원스토어
const String KAKAOTALK_CHAT = "https://pf.kakao.com/_JAjBb/chat"; //카톡 문의
// const String DATEBOOK_URL = "https://wooadoctor.com/databook"; //발달리포트 자료집
const String DATEBOOK_URL = "https://blog.naver.com/mingling_2019/222999320667"; //발달리포트 자료집
const String HEALTH_CALENDAR = "http://woorisoa.co.kr/clinic/clinic_07.php"; //검진캘린더  연결페이지
const String vaccine_CALENDAR = "http://woorisoa.co.kr/bbs/board.php?bo_table=vaccine"; //예방접종클리닉 페이지(접종캘린더)
const String HEALTH_URL1 = "https://nip.kdca.go.kr/irgd/index.html"; //예방 접종정보 확인하기
const String HEALTH_URL2 = "https://www.nhis.or.kr/nhis/healthin/retrieveInfntExmdDtInq.do"; //영유아건강검진 정보 확인하기

const String POLICY_URL = "http://wooadoctor.com/privacy"; //개인정보처리방침
const String TERMS_URL = "http://wooadoctor.com/terms"; //서비스 이용약관
const String HEALTH_URL = "http://wooadoctor.com/privacy2"; //고유식별정보 수집동의 및 처리방침
const String AD_URL = "http://wooadoctor.com/privacy3"; //개인 민감(건강)정보 처리방침 동의

String gLangCode = "en";
// List<AreaList>? gAreaList;
List<String>? gCityList;
List<DistrictList>? gDistrictList;
// List<HospitalDto>? gHospitalList;
bool isOneStore = true; //true : Onestore. false : google
bool faqFromSide = false;
bool isFirstApp = true;
UserInfoDto? gUserInfo;
MonitorWriteDto? dicWriteDto;
EventBus eventBus = EventBus();
String gAppVer = "";
bool gReview = false;
bool gSignupMonitoring = false;
bool gBodyTab = true; //true : 신체, false : 두뇌
List<SymptomList>? gSymptomList;
List<RelationInfo>? gRelationList;
HistoryDiseaseInfo? gDiseaseList;
List<ReviewPoint>? gReviewPoint;

MonitoringDayDto? monitoringData;

ChildDto? gSelChildInfo;

enum ResultStatus { success, error }

enum MainTab { home, monitoring, home_care, community }

enum PhoneAuthType { login, signup, changePhone }
