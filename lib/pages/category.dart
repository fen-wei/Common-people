import 'package:flutter/material.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List arr1;
  List arr2;
  String _pid;

  void initState() { 
    super.initState();
    getList1();
    getList2();
  }
  // 分类左侧数据
  Future getList1() async{
    var res =await http('CategPageSl', 'get', null);
    Object all={
      'title':'全部',
      '_id':' 59f1e1ada1da8b15d42234e9'
    };
    res['result'].forEach((item){
      item['pic'] = item['pic'].replaceAll(new RegExp(r'\\'),'/');
    });
    var req = res['result']..insert(0,all);
    setState(() {
      arr1 = req;
    });
  }

  // 右侧数据
  Future getList2() async{
    var res=await http('CategPageSl', 'get', {"pid":_pid});
    res['result'].forEach((item){
      item['pic'] = item['pic'].replaceAll(new RegExp(r'\\'), '/');
    });
    setState(() {
      arr2 = res['result'];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: Flex(
          direction:Axis.horizontal,//左右排列
          children: <Widget>[
            Expanded(
              flex:2,
              child:leftlist()
            ),
            Expanded(
              flex: 8,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        // Text('全部'),
                        leftlist1()
                        ],
                    )
                  ),
                  Expanded(
                    flex:9,
                    child:rightlist()
                  )
                ],
              )
            )
          ],
        )
      )
    );
  }

  Widget leftlist(){
    List<Widget> list1=[];
    for(var val in arr1){
      list1.add(
        GestureDetector(
          onTap: (){
            setState(() {
              _pid="${val['_id']}";
            });
            getList2();
            // print(_pid);
          },
          child:new Container(
          child: new Text("${val['title']}",
            style: TextStyle(
              color: val['_id']==_pid?Colors.red:Colors.grey
            ),
          ),
          width: ScreenUtil().setWidth(190),
          height: ScreenUtil().setHeight(150),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border(
              bottom:BorderSide(
                width: .5,
                color: Colors.grey[300]
              ),
              right:BorderSide(
                width: .5,
                color: Colors.grey[300]
              )
              )
          ),
        ) ,
        )
      );
    }
    return ListView(children:list1,);
  }
    Widget leftlist1(){
      List<Widget> list1=[];
      for(var val in arr1){
        list1.add(
          new Container(
            child: new Text("${val['title']}",
            style: TextStyle(
              color:val['_id']==_pid?Colors.red:Colors.grey
              ),
            ),
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
          )

        );
        print('$val');
      }
      return Row(children:list1,);
    }
    Widget rightlist(){
      List<Widget> list2=[];
      for(var val in arr2){
        list2.add(
          new Container(
            child: Row(
              children: <Widget>[
                Image.network("http://jd.itying.com/${val['pic']}",
                  width: ScreenUtil().setWidth(100),
                  height: ScreenUtil().setHeight(100),
                  
                ),
                Column(
                  children: <Widget>[
                   new Container(
                     child:  Text("${val['title']}"),
                     margin: EdgeInsets.only(left:20),
                   )
                    // Text("${val['title']}")
                  ],
                )
              ],
            ),
            padding: EdgeInsets.all(10),
          )
        );
        print('$val');
      }
      return ListView(children:list2,);
    }
}