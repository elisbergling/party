import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:party/constants/global.dart';
import 'package:party/providers/friend_provider.dart';
import 'package:party/providers/party_provider.dart';
import 'package:party/providers/state_provider.dart';
import 'package:party/widgets/custom_text_field.dart';
import 'package:party/widgets/friend_tile.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('new partrry'),
      ),
      body: Form(
        key: _formKey,
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () async {
                    context.read(partyDateProvider).state =
                        await showDatePicker(
                      context: context,
                      initialDate: partyDate.state ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                  },
                  child: Text('Select Date'),
                ),
                RaisedButton(
                  onPressed: () async {
                    context.read(partyTimeOfDayProvider).state =
                        await showTimePicker(
                      context: context,
                      initialTime: partyTimeOfDay.state ?? TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input,
                    );
                  },
                  child: Text('Select Time'),
                ),
              ],
            ),
            Container(
              height: 160,
              child: friendFriendsStream.when(
                data: (friends) => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: friends.length,
                  itemBuilder: (context, index) => FriendTile(
                    friend: friends[index],
                    isForParty: true,
                  ),
                ),
                loading: () => MyLoadingWidget(),
                error: (e, s) => MyErrorWidget(e: e, s: s),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(partyDate.state.toString().split(' ')[0] + ' '),
                Text(partyTimeOfDay.state.toString())
              ],
            ),
            Text(invitedUids.state.toString()),
            !party.isLoading
                ? RaisedButton(
                    onPressed: () async {
                      await context.read(partyProvider).addParty(
                            about: controllerAbout.text,
                            imgUrl: '',
                            name: controllerName.text,
                            price: int.parse(controllerPrice.text),
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
                      }
                    },
                    child: Text('Create Party'),
                  )
                : MyLoadingWidget(),
          ],
        ),
      ),
    );
  }
}
