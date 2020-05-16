import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:order/Handlers/addressHandlers.dart';
import 'package:order/Handlers/authorization.dart';
import 'package:order/Models/address.dart';
import 'package:order/SharedPreferences/utils.dart';
import 'package:order/constants.dart';
import 'package:order/exceptions.dart';
import 'package:the_validator/the_validator.dart';

class AddressPage extends StatefulWidget {
  AddressPage({Key key}) : super(key: key);

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();
  List<Address> addresses = [];

  Address _newAddress = Address();

  void fetchAddress() {
    read_uid().then((id) {
      getUserWithUid(id).then(
        (user) => setState(() {
          this.addresses = user.address;
        }),
      );
    });
  }

  @override
  void initState() {
    this.fetchAddress();
    super.initState();
  }

  void saveAddress(context, Address address) {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    try {
      address.validate();
      updateAddressForUser(address).then((value) {
        if (value) {
          Navigator.pop(context, true);
        } else {
          Navigator.pop(context, false);
        }
        this.fetchAddress();
      });
    } on ValidationException catch (err) {
      Navigator.pop(context, false);
    }
  }

  void removeAddress(Address address) {
    _formKey.currentState.save();
    print(address);
    updateAddressForUser(address, delete: true).then((value) {
      if (value) {
        Navigator.pop(context, true);
      } else {
        Navigator.pop(context, false);
      }
      this.fetchAddress();
    });
  }

  void makeDefaultAddress(Address address) {
    address.isDefault = true;
    updateAddressForUser(address).then((value) {
      if (value) {
        this.fetchAddress();
      } else {}
    });
  }

  Future<bool> renderForm(BuildContext context, Address address) async {
    bool val = await showDialog(
        context: context,
        child: AlertDialog(
          content: Container(
            color: Colors.white,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "*Outside ${Constants().restrictedArea} not allowed",
                        style: TextStyle(
                            color: Colors.orange[400],
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        initialValue: address.houseNumber,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: 'House/Flat No',
                        ),
                        maxLines: 1,
                        validator: (value) => Validator.isRequired(value)
                            ? null
                            : "Required Field",
                        onSaved: (val) => address.houseNumber = val,
                      ),
                      TextFormField(
                        initialValue: address.landmark,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Landmark',
                        ),
                        maxLines: 1,
                        onSaved: (val) => address.landmark = val,
                      ),
                      TextFormField(
                        initialValue: address.area,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Area',
                        ),
                        maxLines: 1,
                        validator: (value) => Validator.isRequired(value)
                            ? null
                            : "Required Field",
                        onSaved: (val) => address.area = val,
                      ),
                      TextFormField(
                        initialValue:
                            address.zip ?? Constants().allowedPinCode[0],
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Pin Code',
                        ),
                        maxLines: 1,
                        validator: (value) => Validator.isRequired(value) &&
                                Constants().allowedPinCode.contains(value)
                            ? null
                            : "Invalid Pin Code",
                        onSaved: (val) => address.zip = val,
                      ),
                      TextFormField(
                        initialValue: Constants().restrictedArea,
                        enabled: false,
                        style: TextStyle(
                          fontSize: ScreenUtil().setSp(28),
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          labelText: 'City',
                        ),
                        maxLines: 1,
                        validator: (value) => Validator.isRequired(value)
                            ? null
                            : "Required Field",
                        onSaved: (val) => address.city = val,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "CANCEL",
                  style: TextStyle(
                      color: Colors.orange[400],
                      fontSize: ScreenUtil().setSp(26),
                      fontFamily: "Poppins-Bold"),
                )),
            this.addresses.contains(address)
                ? FlatButton(
                    onPressed: () {
                      this.removeAddress(address);
                    },
                    child: Text(
                      "DELETE",
                      style: TextStyle(
                          color: Colors.orange[400],
                          fontSize: ScreenUtil().setSp(26),
                          fontFamily: "Poppins-Bold"),
                    ),
                  )
                : Container(),
            FlatButton(
              onPressed: () {
                this.saveAddress(context, address);
              },
              child: Text(
                "SAVE",
                style: TextStyle(
                    color: Colors.orange[400],
                    fontSize: ScreenUtil().setSp(26),
                    fontFamily: "Poppins-Bold"),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          renderForm(context, this._newAddress);
        },
        isExtended: true,
        backgroundColor: Colors.orange[400],
        tooltip: "Add New",
        child: Icon(
          Icons.add,
          size: 36,
        ),
      ),
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.orange[500],
            ),
            onPressed: () => Navigator.pop(context)),
        centerTitle: true,
        title: Text(
          'Manage Address',
          style: TextStyle(
            color: Colors.orange[500],
            fontSize: ScreenUtil().setHeight(30),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(20.0),
                    vertical: ScreenUtil().setHeight(20)),
                width: double.infinity,
                child: Text(
                  this.addresses.length == 0
                      ? 'YOU HAVE NO ADDRESS'
                      : 'YOUR ADDRESSES',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: ScreenUtil().setSp(24),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins-Bold"),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(30)),
              this.addresses.length > 0
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "LONG PRESS TO EDIT",
                        style: TextStyle(
                            fontFamily: "Poppins-Medium",
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: Colors.black45),
                      ),
                    )
                  : Container(),
              SizedBox(height: ScreenUtil().setHeight(10)),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(20.0),
                ),
                width: double.infinity,
                child: Column(
                  children: List.generate(
                    this.addresses.length,
                    (idx) => Column(
                      children: <Widget>[
                        ListTile(
                          onLongPress: () =>
                              renderForm(context, this.addresses[idx]),
                          dense: true,
                          title: Text(
                            addresses[idx].houseNumber,
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(22),
                            ),
                          ),
                          subtitle: Text(
                            [addresses[idx].area, addresses[idx].city]
                                .join(", "),
                            style: TextStyle(
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w600,
                              fontSize: ScreenUtil().setSp(20),
                            ),
                          ),
                          trailing: RaisedButton(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            color: addresses[idx].isDefault
                                ? Colors.grey[100]
                                : Colors.orange[300],
                            onPressed: () {
                              this.makeDefaultAddress(addresses[idx]);
                            },
                            child: Container(
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              width: ScreenUtil().setWidth(150),
                              height: ScreenUtil().setHeight(30),
                              child: Center(
                                child: Text(
                                  addresses[idx].isDefault
                                      ? 'Default'
                                      : 'Make Default',
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(20),
                                      fontFamily: "Poppins Medium",
                                      color: addresses[idx].isDefault
                                          ? Colors.grey
                                          : Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(height: 0)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
