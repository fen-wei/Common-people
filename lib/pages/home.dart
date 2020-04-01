import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home> {
  List formList;
  int page=1;
  List hotList=[];
  initState() {
    super.initState();
    getBanner(); // 调用轮播图接口
    getHot();
  }
  // 轮播图
  Future getBanner() async{
    try {
      var res =await http('HomePageBanner', 'get', null);
      res['result'].forEach((item){
        item['pic'] = item['pic'].replaceAll(new RegExp(r'\\'),'/');
      });
      setState(() {
        formList = res['result'];
      });
      return res;
    } catch (e) {
      return print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('百姓生活+')),
        body: EasyRefresh(
          child: ListView(
            children: <Widget>[
              _banner(), // banner 轮播
              TopNavigator(), // nav区域
              _getImg, // 公告
              hotGoodsList()
            ]
          ),
          
          onLoad: () async{
            print(page);
            var pg = {'page': page};
            await http('HomePageShopList', 'get', pg).then((val){
              var res = val['result'];
              res.forEach((item){
                item['pic'] = item['pic'].replaceAll(new RegExp(r'\\'),'/');
                item['s_pic'] = item['s_pic'].replaceAll(new RegExp(r'\\'),'/');
              });
              
              if(hotList.length == page*10-10){
                setState(() {
                  hotList.addAll(res) ;
                  page++;
                });
                print(hotList.length);
                print(page*10-10);
              }else{
                print('1111111111111111111111111111111111111');
              }
            });
          },
        ),
      ),
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
    );
  }
  // 公告
  Widget _getImg = Container(
    child: Image.asset('images/12.jpg'),
  );
  // banner 轮播
  Widget _banner(){
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(400),
      child:Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network(
            'http://jd.itying.com/${formList[index]['pic']}',
            width: ScreenUtil().setWidth(750),
          );
        },
        itemCount: formList.length,
        pagination: SwiperPagination(),
        autoplay: true, 
      ),
    );
  }
  
  void getHot(){
    print(page);
    var pg = {'page': page};
    http('HomePageShopList', 'get', pg).then((val){
      var res = val['result'];
      res.forEach((item){
        item['pic'] = item['pic'].replaceAll(new RegExp(r'\\'),'/');
        item['s_pic'] = item['s_pic'].replaceAll(new RegExp(r'\\'),'/');
      });
      setState(() {
        hotList.addAll(res) ;
        page++;
      });
    });
  }
  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    child: Text('火爆专区')
  );
  // 火爆专区内容
  Widget _warpList(){
    if(hotList.length!=0){
      List<Widget> ListWidget = hotList.map((val){
        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            height:ScreenUtil().setHeight(600) ,
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network('http://jd.itying.com/${val['pic']}',width: ScreenUtil().setWidth(372),height: ScreenUtil().setHeight(400),fit: BoxFit.cover,),
                Text(
                  val['title'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: ScreenUtil().setSp(26)
                  )
                ),
                Row(
                  children:<Widget>[
                    Text('￥${val['price']}'),
                    Text(
                      '￥${val['old_price']}',
                      style: TextStyle(
                        color: Colors.black26,
                        decoration: TextDecoration.lineThrough
                      ),
                    )
                  ] 
                )
              ]
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: ListWidget,
      );
    }else{
      return Text('');
    }
  }

  Widget hotGoodsList(){
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          Text(''),
          _warpList()
        ],
      )
    );
  }
}

// 首页导航部分
class TopNavigator extends StatelessWidget {
  const TopNavigator({Key key}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context){
    return InkWell(
      child: Column(
        children: <Widget>[
          Image.asset('images/4.jpg',width: ScreenUtil().setWidth(95)),
          Text('白酒')
        ]
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      margin: EdgeInsets.only(top: 10.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
          _gridViewItemUI(context),
        ],
      ),
    );
  }
}


