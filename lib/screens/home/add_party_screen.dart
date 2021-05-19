import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/colors.dart';
import 'package:party/constants/global.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/map_dialog.dart';
import 'package:party/widgets/background_gradient.dart';
import 'package:party/widgets/custom_back_button.dart';
import 'package:party/widgets/custom_button.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/friend_tile.dart';
import 'package:party/widgets/info_box.dart';
import 'package:party/widgets/temp/my_error_widget.dart';
import 'package:party/widgets/temp/my_loading_widget.dart';

class AddPartyScreen extends HookWidget {
  const AddPartyScreen({
    Key key,
  }) : super(key: key);

  static const routeName = '/add_party';

  String validator(value) {
    if (value.isEmpty) {
      return 'Well, you have to enter a name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final party = useProvider(partyProvider);
    final controllerName = useTextEditingController();
    final controllerAbout = useTextEditingController();
    final controllerPrice = useTextEditingController();
    final invitedUids = useProvider(invitedUidsProvider);
    final friendFriendsStream = useProvider(friendFriendsStreamProvider);
    final partyDate = useProvider(partyDateProvider);
    final partyTimeOfDay = useProvider(partyTimeOfDayProvider);
    final locationInfo = useProvider(locationInfoProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          leading: CustomBackButton(shouldNotJustPop: true),
          title: Text(
            'New Party',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: dark,
            ),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  text: 'name',
                  isForm: true,
                  textEditingController: controllerName,
                  validator: validator,
                ),
                CustomTextField(
                  text: 'about',
                  isForm: true,
                  textEditingController: controllerAbout,
                  validator: validator,
                ),
                CustomTextField(
                  text: 'price(kr)',
                  isForm: true,
                  textEditingController: controllerPrice,
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      onTap: () async {
                        context.read(partyDateProvider).state =
                            await showDatePicker(
                          context: context,
                          initialDate: partyDate.state ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                      },
                      text: 'Select Date',
                    ),
                    CustomButton(
                      onTap: () async {
                        context.read(partyTimeOfDayProvider).state =
                            await showTimePicker(
                          context: context,
                          initialTime: partyTimeOfDay.state ?? TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.input,
                        );
                      },
                      text: 'Select Time',
                    ),
                    CustomButton(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) => MapDialog(shouldAdd: true)),
                      text: 'Select Location',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 141,
                  child: friendFriendsStream.when(
                    data: (friends) => ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) => FriendTile(
                        friend: friends[index],
                        isForParty: true,
                        isForGroup: false,
                      ),
                    ),
                    loading: () => MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 26,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    children: [
                      const SizedBox(width: 20),
                      InfoBox(
                        text: partyDate.state != null
                            ? partyDate.state.toString().split(' ')[0] + ' '
                            : 'date',
                      ),
                      const SizedBox(width: 20),
                      InfoBox(
                        text: partyTimeOfDay.state != null
                            ? partyTimeOfDay.state
                                .toString()
                                .split('(')[1]
                                .split(')')[0]
                            : 'time',
                      ),
                      const SizedBox(width: 20),
                      InfoBox(
                        text: locationInfo.state != null
                            ? locationInfo.state.address.split(',')[0]
                            : 'adress',
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                !party.isLoading
                    ? CustomButton(
                        onTap: () async {
                          await context.read(partyProvider).addParty(
                                locationInfo: locationInfo.state,
                                about: controllerAbout.text,
                                imgUrl: '',
                                name: controllerName.text,
                                price: controllerPrice.text != null &&
                                        controllerPrice.text != ''
                                    ? int.parse(controllerPrice.text.trim())
                                    : null,
                                time: Timestamp.fromDate(
                                  partyDate.state.add(
                                    Duration(
                                      hours: partyTimeOfDay.state.hour,
                                      minutes: partyTimeOfDay.state.minute,
                                    ),
                                  ),
                                ),
                                invitedUids: invitedUids.state,
                              );
                          showActionDialog(
                            ctx: context,
                            service: party,
                            message: party.error,
                            title: party.error == ''
                                ? 'Created Party Sucessfully'
                                : 'Something went wrong',
                          );
                          if (party.error == '') {
                            controllerName.text = '';
                            controllerAbout.text = '';
                            controllerPrice.text = '';
                            context.read(invitedUidsProvider).state.clear();
                            context.read(partyDateProvider).state = null;
                            context.read(partyTimeOfDayProvider).state = null;
                            context.read(locationInfoProvider).state = null;
                          }
                        },
                        text: 'Create Party',
                      )
                    : MyLoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
