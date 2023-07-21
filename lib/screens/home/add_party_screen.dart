import 'package:cloud_firestore/cloud_firestore.dart';
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

class AddPartyScreen extends HookConsumerWidget {
  const AddPartyScreen({super.key});

  static const routeName = '/add_party';

  String? validator(value) {
    if (value.isEmpty) {
      return 'Well, you have to enter a name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final party = ref.watch(partyProvider);
    final controllerName = useTextEditingController();
    final controllerAbout = useTextEditingController();
    final controllerPrice = useTextEditingController();
    final invitedUids = ref.watch(invitedUidsProvider);
    final friendFriendsStream = ref.watch(friendFriendsStreamProvider);
    final partyDate = ref.watch(partyDateProvider);
    final partyTimeOfDay = ref.watch(partyTimeOfDayProvider);
    final locationInfo = ref.watch(locationInfoProvider);
    return BackgroundGradient(
      child: Scaffold(
        appBar: AppBar(
          leading: const CustomBackButton(shouldNotJustPop: true),
          title: const Text(
            'New Party',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: MyColors.white,
            ),
          ),
        ),
        body: Form(
          key: formKey,
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
                        ref.read(partyDateProvider.notifier).state =
                            await showDatePicker(
                          context: context,
                          initialDate: partyDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 365)),
                        );
                      },
                      text: 'Select Date',
                    ),
                    CustomButton(
                      onTap: () async {
                        ref.read(partyTimeOfDayProvider.notifier).state =
                            await showTimePicker(
                          context: context,
                          initialTime: partyTimeOfDay ?? TimeOfDay.now(),
                          initialEntryMode: TimePickerEntryMode.input,
                        );
                      },
                      text: 'Select Time',
                    ),
                    CustomButton(
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) =>
                              const MapDialog(shouldAdd: true)),
                      text: 'Select Location',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 141,
                  child: friendFriendsStream.when(
                    data: (friends) => ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: friends.length,
                      itemBuilder: (context, index) => FriendTile(
                        friend: friends[index],
                        isForParty: true,
                        isForGroup: false,
                      ),
                    ),
                    loading: () => const MyLoadingWidget(),
                    error: (e, s) => MyErrorWidget(e: e, s: s),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 26,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const SizedBox(width: 20),
                      InfoBox(
                        text: partyDate != null
                            ? '${partyDate.toString().split(' ')[0]} '
                            : 'date',
                      ),
                      const SizedBox(width: 20),
                      InfoBox(
                        text: partyTimeOfDay != null
                            ? partyTimeOfDay
                                .toString()
                                .split('(')[1]
                                .split(')')[0]
                            : 'time',
                      ),
                      const SizedBox(width: 20),
                      InfoBox(
                        text: locationInfo != null
                            ? locationInfo.address.split(',')[0]
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
                          await ref.read(partyProvider.notifier).addParty(
                                locationInfo: locationInfo,
                                about: controllerAbout.text,
                                imgUrl: '',
                                name: controllerName.text,
                                price:
                                    int.tryParse(controllerPrice.text.trim()),
                                time:
                                    partyDate != null && partyTimeOfDay != null
                                        ? Timestamp.fromDate(
                                            partyDate.add(
                                              Duration(
                                                hours: partyTimeOfDay.hour,
                                                minutes: partyTimeOfDay.minute,
                                              ),
                                            ),
                                          )
                                        : null,
                                invitedUids: invitedUids,
                              );
                          showActionDialog(
                            ctx: context,
                            onPressed: () =>
                                ref.read(partyProvider.notifier).setError(''),
                            message: party.error,
                            title: party.error == ''
                                ? 'Created Party Sucessfully'
                                : 'Something went wrong',
                          );
                          if (party.error == '') {
                            controllerName.text = '';
                            controllerAbout.text = '';
                            controllerPrice.text = '';
                            ref
                                .read(invitedUidsProvider.notifier)
                                .state
                                .clear();
                            ref.read(partyDateProvider.notifier).state = null;
                            ref.read(partyTimeOfDayProvider.notifier).state =
                                null;
                            ref.read(locationInfoProvider.notifier).state =
                                null;
                          }
                        },
                        text: 'Create Party',
                      )
                    : const MyLoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
