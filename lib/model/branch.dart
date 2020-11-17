import 'package:amugong/model/business_hour.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branch.g.dart';

@JsonSerializable()
class Branch {
  int branchID;
  String branchName;
  double lat;
  double lng;
  String address;
  String branchIntro;
  int totalSeat;
  int curNum;
  String atmosphere;
  String music;
  String light;
  String amenity;
  String base;
  String hashTag;
  List<BusinessHour> businessHour;
  int price;

  Branch({
    this.address,
    this.branchID,
    this.branchIntro,
    this.branchName,
    this.curNum,
    this.lat,
    this.lng,
    this.totalSeat,
    this.businessHour,
    this.atmosphere,
    this.music,
    this.light,
    this.amenity,
    this.base,
    this.hashTag,
    this.price
  });

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
  Map<String, dynamic> toJson() => _$BranchToJson(this);

  String businessHourToString(){
    String res = "";
    for(int i = 0; i < businessHour.length; i++){
      final split = businessHour[i].dow.split(',');
      String dows = "";
      int start = 0;
      int end = -1;
      for(int j = 0; j < split.length; j++){
        if(start == 0) {
          start = int.parse(split[j]);
          end = start;
        }
        else if(end + 1 == int.parse(split[j])) {
          end += 1;
        }else end = -1;
        dows += dowToString(split[j]);
      }

      if(end != -1 && start != end && end == split.length){
        dows = dowToString(start.toString()) + "-" + dowToString(end.toString());
      }
      if(dows.length > 4){
        res += dows + "\n" + businessHour[i].businessHourStart + " ~ " +
            businessHour[i].businessHourEnd;
      }else {
        res += dows + " " + businessHour[i].businessHourStart + " ~ " +
            businessHour[i].businessHourEnd;
      }
      if(i != businessHour.length -1){
        res += "\n";
      }
    }
    return res;
  }

  String dowToString(String x){
    switch(x){
      case "0":
        return "일";
      case "1":
        return "월";
      case "2":
        return "화";
      case "3":
        return "수";
      case "4":
        return "목";
      case "5":
        return "금";
      case "6":
        return "토";
      default:
        return " ";
    }
  }
}
