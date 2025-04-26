import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../shared/constants/app_typography.dart';
import '../../../shared/utils/utils.dart';
import '../widgets/settings_lis_tile.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  bool showAccountInfo = false;
  bool showWalletInfo = false;
  final String walletAddy = '3rLojDoVPUKBXnr2vybXJA3Lh3wKBxxDHx7fxJn8m3ZM';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'Account',
              style: AppTypography.linkLarge.copyWith(color: Colors.black),
            ),
            Text(
              '@janeCooper',
              style: AppTypography.linkXSmall.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            SizedBox(height: 1.h),
            Center(
              child: Text(
                'See information about your account.',
                style: AppTypography.linkXSmall.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            SettingsListTile(
              icon: Icons.person_outline,
              title: 'Account Information',
              isExpandable: true,
              isExpanded: showAccountInfo,
              onTap: () {
                setState(() {
                  showAccountInfo = !showAccountInfo;
                });
              },
              expandedChild: _buildAccountInfoWidget(),
            ),
            SettingsListTile(
              icon: Icons.vpn_key_outlined,
              title: 'Change password',
              onTap: () {
                //TODO: Go to change password screen
              },
            ),
            SettingsListTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet intergration',
              isExpandable: true,
              isExpanded: showWalletInfo,
              onTap: () {
                setState(() {
                  showWalletInfo = !showWalletInfo;
                });
              },
              expandedChild: Container(
                child: Column(
                  children: [
                    _buildInfoRow(
                      'Wallet address',
                      shortenWalletAddress(walletAddy),
                    ),
                  ],
                ),
              ),
            ),
            SettingsListTile(
              icon: Icons.block,
              title: 'Deactivate account',
              onTap: () {
                //TODO: implement deactivate account
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.linkSmall.copyWith(),
          ),
          Text(
            value,
            // overflow: TextOverflow.ellipsis,
            style: AppTypography.linkXSmall.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('Username', '@jane_cooper'),
          _buildInfoRow('Email', 'bakaridi43@gmail.com'),
        ],
      ),
    );
  }
}
