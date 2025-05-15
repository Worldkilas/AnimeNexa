import 'package:anime_nexa/features/messaging/widgets/chat_list_tile.dart';
import 'package:anime_nexa/shared/constants/app_colors.dart';
import 'package:anime_nexa/shared/constants/app_typography.dart';
import 'package:anime_nexa/shared/widgets/custom_button.dart';
import 'package:anime_nexa/shared/widgets/reusable_confirmation_dialog.dart';
import 'package:anime_nexa/shared/widgets/reusable_search_bar.dart';
import 'package:anime_nexa/shared/widgets/reusbale_modal_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_theme.dart';
import '../../../shared/widgets/reusable_popup_button.dart';
import 'groups_tab.dart';
import 'chat_tab.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Messages',
            style: theme.textTheme.labelLarge,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                //TODO: Implement search functionality
              },
            ),
            ReusablePopupMenu<String>(
              onItemSelected: (value) {
                switch (value) {
                  case 'Add Friends':
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ReusableModalSheet(
                        title: value,
                        children: [
                          ReusableSearchBar(
                            hintText: 'Add by username',
                            onSearchSubmitted: (value) {},
                          )
                        ],
                      ),
                    );
                  case 'Create group':
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ReusableModalSheet(
                        actionWidget: TextButton(
                          onPressed: () {
                            //TODO: Create group
                          },
                          child: Text(
                            'Create',
                            style: AppTypography.textMediumBold.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        title: value,
                        children: [
                          ReusableSearchBar(
                            onSearchSubmitted: (value) {},
                          )
                        ],
                      ),
                    );
                  case 'Archived':
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ReusableModalSheet(
                        title: value,
                        children: List.generate(
                          7,
                          (index) => ChatListTile(
                            //TODO; Change to actual trailin
                            trailing: Column(
                              children: [
                                Text('10:00 AM'),
                                Container(
                                  width: 25,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: appTheme.primaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      20.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  case 'Blocked users':
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => ReusableModalSheet(
                        title: value,
                        children: List.generate(
                          20,
                          (index) => Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFECECEC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ChatListTile(
                              trailing: CustomButton(
                                text: 'Unblock',
                                height: 4.5.h,
                                width: 30.w,
                                onPressed: () {
                                  //TODO: Implement unblock funtionality
                                  showDialog(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) =>
                                        ReusableConfirmationDialog(
                                      headerIcon: Image.asset(
                                        'lib/assets/images/Unfriend.png',
                                      ),
                                      title:
                                          'Are you sure you want to Unblock this user?',
                                      description:
                                          'By unblocking this user, you will restore their access to your profile and allow them to interact with you again. if you are certain about unblocking this user and wish to give them another chance, click “Unblock” below.',
                                      confirmButtonText: 'Unblock',
                                      onConfirm: () {},
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  case 'Settings':
                    context.go('/messaging/settings');
                }
              },
              items: [
                PopupMenuItemData(
                  value: 'Add Friends',
                  label: 'Add Friends',
                  icon: Icons.person_add,
                ),
                PopupMenuItemData(
                  value: 'Create group',
                  label: 'Create group',
                  icon: Icons.group_add,
                ),
                PopupMenuItemData(
                  value: 'Archived',
                  label: 'Archived',
                  icon: Icons.archive,
                ),
                PopupMenuItemData(
                  value: 'Blocked users',
                  label: 'Blocked users',
                  icon: Icons.block,
                  textStyle: AppTypography.textMedium.copyWith(
                    color: Colors.red,
                  ),
                  iconColor: Colors.red,
                ),
                PopupMenuItemData(
                  value: 'Settings',
                  label: 'Settings',
                  icon: Icons.settings,
                ),
              ],
            )
          ],
          bottom: TabBar(
            indicatorColor: theme.primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            labelColor: theme.primaryColor,
            tabs: [
              Tab(text: 'Chats'),
              Tab(text: 'Groups'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatsTab(),
            GroupsTab(),
          ],
        ),
      ),
    );
  }
}
