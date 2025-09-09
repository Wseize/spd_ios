import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spooding_exp_ios/20/view/wallet/controller.dart';

class WalletScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController usePointsController = TextEditingController();
  final List<Map<String, dynamic>> choices = [
    {'points': 200, 'carnets': 5, 'label': 'Bronze'},
    {'points': 500, 'carnets': 15, 'label': 'Silver'},
    {'points': 1000, 'carnets': 35, 'label': 'Golden'},
  ];
  WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          'My Wallet',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the icon color to white
        ),
      ),
      body: Obx(() {
        final wallet = walletController.wallet.value;

        if (wallet == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// === BALANCE CARD ===
              _buildSectionTitle("Mon Solde"),
              _buildBalanceCard(wallet),

              const SizedBox(height: 24),

              /// === REFERRAL CODE CARD ===
              _buildSectionTitle("Code de Parrainage"),
              _buildReferralCard(wallet.referralCode),

              const SizedBox(height: 24),
              _buildSectionTitle("Points → Carnet"),
              GestureDetector(
                onTap: () {
                  // Même fonctionnalité qu’avant au clic
                  Get.bottomSheet(
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      constraints: BoxConstraints(maxHeight: 300),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Choisissez le nombre de points :",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: choices.length,
                              separatorBuilder: (_, __) => Divider(),
                              itemBuilder: (context, index) {
                                final option = choices[index];
                                final optionPoints = option['points'];
                                final userPoints =
                                    walletController.wallet.value?.points ?? 0;
                                final isEnabled = userPoints >= optionPoints;

                                return ListTile(
                                  enabled: isEnabled,
                                  leading: Icon(
                                    Icons.point_of_sale,
                                    color:
                                        isEnabled ? Colors.orange : Colors.grey,
                                  ),
                                  title: Text(
                                    "${option['points']} SPD : ${option['label']} (${option['carnets']} DT)",
                                    style: TextStyle(
                                      color: isEnabled
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                  onTap: isEnabled
                                      ? () {
                                          Get.back();
                                          walletController
                                              .exchangePointsForCarnet(
                                            optionPoints,
                                          );
                                          Get.defaultDialog(
                                            title: "🎉 Félicitations",
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Tu as échangé ${optionPoints} points avec succès !",
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "📘 Va consulter ton carnet dans ton compte !",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textConfirm: "OK",
                                            confirmTextColor: Colors.white,
                                            buttonColor: Colors.green,
                                          );
                                        }
                                      : null,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 55,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade600,
                        Colors.deepOrange.shade400,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.6),
                        offset: Offset(0, 8),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Carnet contre points",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              /// === TRANSFER SECTION ===
              _buildSectionTitle("Envoyer des Points"),
              _buildTransferForm(
                phoneController,
                amountController,
                walletController,
              ),
              const SizedBox(height: 24),

              // /// === USE POINTS SECTION ===
              // _buildSectionTitle("Use Points"),
              // _buildUsePointsForm(usePointsController, walletController),

              const SizedBox(height: 24),

              /// === TRANSACTION HISTORY ===
              _buildSectionTitle("Transactions Récentes"),
              _buildTransactionList(walletController),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildBalanceCard(wallet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.deepOrange,
              size: 40,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${wallet.points.toStringAsFixed(2)} SPD',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${(wallet.points * 0.025).toStringAsFixed(2)} TND',
                  style: const TextStyle(color: Colors.green, fontSize: 16),
                ),
                const SizedBox(height: 6),
                const Text(
                  '10 SPD = 0.25 TND',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCard(String code) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: const Icon(Icons.copy, size: 40, color: Colors.deepOrange),
        title: const Text('Code de Parrainage', style: TextStyle(fontSize: 16)),
        subtitle: Text(
          code,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: code));
            Get.snackbar('Copied', 'Referral code copied to clipboard');
          },
        ),
      ),
    );
  }

  Widget _buildTransferForm(
    TextEditingController phoneCtrl,
    TextEditingController amountCtrl,
    WalletController walletCtrl,
  ) {
    return Column(
      children: [
        TextField(
          controller: phoneCtrl,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Téléphone du Destinataire',
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: amountCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Montant (SPD)',
            prefixIcon: const Icon(Icons.attach_money),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.send),
            label: const Text("Envoyer des Points"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // onPressed: () async {
            //   final phone = phoneCtrl.text.trim();
            //   final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;

            //   if (phone.isEmpty || amount <= 0) {
            //     Get.snackbar('Error', 'Please fill all fields correctly');
            //     return;
            //   }

            //   final success = await walletCtrl.transferPoints(phone, amount);
            //   if (success) {
            //     Get.snackbar('Success', 'Points sent successfully');
            //     walletCtrl.loadWallet();
            //     phoneCtrl.clear();
            //     amountCtrl.clear();
            //   } else {
            //     Get.snackbar('Error', 'Failed to send points');
            //   }
            // },
            onPressed: () async {
              final phone = phoneCtrl.text.trim();
              final amount = int.tryParse(amountCtrl.text.trim()) ?? 0;

              if (phone.isEmpty || amount <= 0) {
                Get.snackbar('Error', 'Please fill all fields correctly');
                return;
              }

              final (success, message) = await walletCtrl.transferPoints(
                phone,
                amount,
              );
              if (success) {
                Get.snackbar('Success', 'Points sent successfully');
                walletCtrl.loadWallet();
                phoneCtrl.clear();
                amountCtrl.clear();
              } else {
                Get.snackbar('Transfer Failed', message);
                print(message);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUsePointsForm(
    TextEditingController useCtrl,
    WalletController walletCtrl,
  ) {
    final RxInt selectedSuggestion = (-1).obs;

    return Obx(() {
      final int availablePoints = walletCtrl.wallet.value?.points ?? 0;

      const int spdPerTnd = 40;
      const int minPointStep = 20;
      const int maxSuggestions = 3;

      List<Map<String, dynamic>> suggestions = [];

      for (int i = maxSuggestions; i >= 1; i--) {
        final int points = i * minPointStep;
        if (availablePoints >= points) {
          final double discount = (points / spdPerTnd);
          suggestions.add({
            'label':
                'Use $points SPD for ${discount.toStringAsFixed(2)} TND discount',
            'points': points,
          });
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (suggestions.isNotEmpty) ...[
            const Text(
              'Suggestions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...List.generate(suggestions.length, (index) {
              final suggestion = suggestions[index];
              return CheckboxListTile(
                title: Text(suggestion['label']),
                value: selectedSuggestion.value == index,
                onChanged: (_) {
                  selectedSuggestion.value =
                      selectedSuggestion.value == index ? -1 : index;
                  useCtrl.text = selectedSuggestion.value == -1
                      ? ''
                      : suggestion['points'].toString();
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            }),
            const SizedBox(height: 8),
          ],
          TextField(
            controller: useCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Points to Use',
              prefixIcon: const Icon(Icons.remove_circle_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text("Use Points"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                final amount = int.tryParse(useCtrl.text.trim()) ?? 0;

                if (amount <= 0) {
                  Get.snackbar('Error', 'Enter a valid number of points');
                  return;
                }

                final (success, message) = await walletCtrl.usePoints(amount);
                if (success) {
                  Get.snackbar('Success', 'Points used successfully');
                  walletCtrl.loadWallet();
                  useCtrl.clear();
                  selectedSuggestion.value = -1;
                } else {
                  Get.snackbar('Error', message);
                }
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildTransactionList(WalletController controller) {
    return Obx(() {
      final transactions = controller.transactions;

      if (transactions.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(child: Text("No transactions yet.")),
        );
      }

      return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: transactions.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final isIncome = tx.change > 0;

          return ListTile(
            leading: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
            ),
            title: Text(tx.description),
            subtitle: Text(
              '${tx.createdAt.toLocal()}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Text(
              '${isIncome ? '+' : ''}${tx.change} pts',
              style: TextStyle(
                color: isIncome ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      );
    });
  }
}

class ReferralInputScreen extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());
  final TextEditingController referralController = TextEditingController();

  ReferralInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Entrer le code de parrainage",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.card_giftcard,
                        size: 50, color: Colors.deepOrangeAccent),
                    const SizedBox(height: 16),
                    const Text(
                      "Avez-vous été invité par quelqu’un ?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: referralController,
                      decoration: InputDecoration(
                        labelText: "Code de parrainage",
                        prefixIcon: const Icon(Icons.redeem),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: const Text("Valider le code"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final code = referralController.text.trim();
                          if (code.isEmpty) {
                            Get.snackbar('Erreur',
                                'Veuillez entrer un code de parrainage');
                            return;
                          }

                          final success =
                              await walletController.setReferralCode(code);
                          if (success) {
                            Get.snackbar(
                                "Succès", "Code de parrainage appliqué !");
                            Get.off(() => WalletScreen());
                          } else {
                            Get.snackbar(
                                "Erreur", "Code de parrainage invalide.");
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () async {
                        final success = await walletController.skipReferral();
                        if (success) {
                          Get.off(() => WalletScreen());
                        } else {
                          Get.snackbar("Erreur",
                              "Échec de la mise à jour de l'état de première utilisation.");
                        }
                      },
                      child: const Text(
                        "Passer, je n'ai pas été invité",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletLauncher extends StatelessWidget {
  final WalletController walletController = Get.put(WalletController());

  WalletLauncher({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: walletController.loadWallet(),
      builder: (context, snapshot) {
        return Obx(() {
          final wallet = walletController.wallet.value;

          if (wallet == null) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // Check if the user is accessing for the first time
          if (wallet.isFirstTime) {
            return ReferralInputScreen();
          }

          return WalletScreen();
        });
      },
    );
  }
}
