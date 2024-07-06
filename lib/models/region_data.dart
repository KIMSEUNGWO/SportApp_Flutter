

import 'package:flutter_sport/common/language_enum.dart';

enum RegionParent {

  ALL("전체", "All", "전체일본어"),

  // 홋카이도 지방
  HOKKAIDO("홋카이도", "Hokkaido", "北海道"),

  // 도호쿠 지방
  AOMORI("아오모리현", "Aomori", "青森県"),
  AKITA("아키타현", "Akita", "秋田県"),
  YAMAGATA("야마가타현", "Yamagata", "山形県"),
  IWATE("이와테현", "Iwate", "岩手県"),
  FUKUSHIMA("후쿠시마현", "Fukushima", "福島県"),
  MIYAGI("미야기현", "Miyagi", "宮城"),

  // 간토 지방
  KANAGAWA("가나가와현", "Kanagawa", "神奈川県"),
  GUNMA("군마현", "Gunma", "群馬県"),
  TOCHIGI("도치기현", "Tochigi", "栃木県"),
  TOKYO("도쿄도", "Tokyo", "東京都"),
  SAITAMA("사이타마현", "Saitama", "埼玉県"),
  IBARAKI("이바라키현", "Ibaraki", "茨城県"),
  CHIBA("치바현", "Chiba", "千葉県"),

  // 주부 지방
  GIFU("기후현", "Gifu", "岐阜県"),
  NAGANO("나가노현", "Nagano", "長野県"),
  NIIGATA("니가타현", "Niigata", "新潟県"),
  TOYAMA("토야마현", "Toyama", "富山県"),
  SHIZUOKA("시즈오카현", "Shizuoka", "静岡県"),
  AICHI("아이치현", "Aichi", "愛知県"),
  YAMANASHI("야마나시현", "Yamanashi", "山梨県"),
  ISHIKAWA("이시카와현", "Ishikawa", "石川県"),
  FUKUI("후쿠이현", "Fukui", "福井県"),

  // 긴키 지방
  KYOTO("교토부", "Kyoto", "京都府"),
  NARA("나라현", "Nara", "奈良県"),
  MIE("미에현", "Mie", "三重県"),
  SHIGA("시가현", "Shiga", "滋賀県"),
  OSAKA("오사카부", "Osaka", "大阪府"),
  WAKAYAMA("와카야마현", "Wakayama", "和歌山県"),
  HYOGO("효고현", "Hyogo", "兵庫県"),

  // 주고쿠 지방
  TOTTORI("돗토리현", "Tottori", "鳥取県"),
  SHIMANE("시마네현", "Shimane", "島根県"),
  YAMAGUCHI("야마구치현", "Yamaguchi", "山口県"),
  OKAYAMA("오카야마현", "Okayama", "岡山県"),
  HIROSHIMA("히로시마현", "Hiroshima", "広島県"),

  // 시코쿠 지방
  KAGAWA("가가와현", "Kagawa", "香川県"),
  KOCHI("고치현", "Kochi", "高知県"),
  TOKUSHIMA("도쿠시마현", "Tokushima", "徳島県"),
  EHIME("에히메현", "Ehime", "愛媛県"),

  // 규슈 지방
  KAGOSHIMA("가고시마현", "Kagoshima", "鹿児島県"),
  KUMAMOTO("구마모토현", "Kumamoto", "熊本県"),
  NAGASAKI("나가사키현", "Nagasaki", "長崎県"),
  MIYAZAKI("미야자키현", "Miyazaki", "宮崎県"),
  SAGA("사가현", "Saga", "佐賀県"),
  OITA("오이타현", "Oita", "大分県"),
  OKINAWA("오키나와현", "Okinawa", "沖縄県"),
  FUKUOKA("후쿠오카현", "Fukuoka", "福岡県");
  
  final String ko;
  final String en;
  final String jp;

  const RegionParent(this.ko, this.en, this.jp);
  

  bool isStartWith(LanguageType langType, String word) {
    return switch (langType) {
      LanguageType.JP => jp.startsWith(word),
      LanguageType.KO => ko.startsWith(word),
      LanguageType.EN => en.toLowerCase().startsWith(word.toLowerCase())
    };
  }

  List<Region> getRegionChildList() {
    return Region.findByRegionParent(this);
  }

  String _getRegion(LanguageType langType) {
    return switch (langType) {
      LanguageType.JP => jp,
      LanguageType.KO => ko,
      LanguageType.EN => en
    };
  }
  
  int compareTo(RegionParent o2, LanguageType langType) {
    return _getRegion(langType).compareTo(o2._getRegion(langType));
  }

}



enum Region {
  // 도쿄도
  ADACHI("아다치구", "Adachi", "足立区", RegionParent.TOKYO),
  ARAKAWA("아라카와구", "Arakawa", "荒川区", RegionParent.TOKYO),
  ITABASHI("이타바시구", "Itabashi", "板橋区", RegionParent.TOKYO),
  EDOGAWA("에도가와구", "Edogawa", "江戸川区", RegionParent.TOKYO),
  OTA("오타구", "Ota", "大田区", RegionParent.TOKYO),
  KATSUSHIKA("카츠시카구", "Katsushika", "葛飾区", RegionParent.TOKYO),
  KITA("키타구", "Kita", "北区", RegionParent.TOKYO),
  KOTO("고토구", "Koto", "江東区", RegionParent.TOKYO),
  SHINAGAWA("시나가와구", "Shinagawa", "品川区", RegionParent.TOKYO),
  SHIBUYA("시부야구", "Shibuya", "渋谷区", RegionParent.TOKYO),
  SHINJUKU("신주쿠구", "Shinjuku", "新宿区", RegionParent.TOKYO),
  SUGINAMI("스기나미구", "Suginami", "杉並区", RegionParent.TOKYO),
  SUMIDA("스미다구", "Sumida", "墨田区", RegionParent.TOKYO),
  SETAGAYA("세타가야구", "Setagaya", "世田谷区", RegionParent.TOKYO),
  TAITO("다이토구", "Taito", "台東区", RegionParent.TOKYO),
  CHUO("주오구", "Chuo", "中央区", RegionParent.TOKYO),
  CHIYODA("치요다구", "Chiyoda", "千代田区", RegionParent.TOKYO),
  TOSHIMA("도시마구", "Toshima", "豊島区", RegionParent.TOKYO),
  NAKANO("나카노구", "Nakano", "中野区", RegionParent.TOKYO),
  NERIMA("네리마구", "Nerima", "練馬区", RegionParent.TOKYO),
  BUNKYO("분쿄구", "Bunkyo", "文京区", RegionParent.TOKYO),
  MINATO("미나토구", "Minato", "港区", RegionParent.TOKYO),
  MEGURO("메구로구", "Meguro", "目黒区", RegionParent.TOKYO),
  ALL("전체", "All", "전체일본어", RegionParent.ALL);
  
  final String ko;
  final String en;
  final String jp;
  final RegionParent parent;

  const Region(this.ko, this.en, this.jp, this.parent);

  bool isStartWith(LanguageType langType, String word) {
    return switch (langType) {
      LanguageType.JP => jp.startsWith(word),
      LanguageType.KO => ko.startsWith(word),
      LanguageType.EN => en.toLowerCase().startsWith(word.toLowerCase())
    };
  }

  String _getRegion(LanguageType langType) {
    return switch (langType) {
      LanguageType.JP => jp,
      LanguageType.KO => ko,
      LanguageType.EN => en
    };
  }

  static List<Region> findByRegionParent(RegionParent parent) {
    return Region.values
        .where((region) => region != Region.ALL && region.parent == parent)
        .toList();
  }

  int compareTo(Region o2, LanguageType langType) {
    return _getRegion(langType).compareTo(o2._getRegion(langType));
  }

  static Region findByName(String? regionName) {
    return Region.values
        .firstWhere(
          (region) => region.name == regionName,
          orElse: () => Region.ALL
        );
  }

  String getFullName() {
    return (this == Region.ALL)
        ? '($ko)'
        : '(${parent.ko} $ko)';
  }
  
}