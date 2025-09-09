import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:spooding_exp_ios/20/view/wallet/controller.dart';
import 'package:spooding_exp_ios/20/view/wallet/model.dart';
import 'package:spooding_exp_ios/20/view/wallet/view.dart';

class CarnetScreen extends StatefulWidget {
  final String userToken;

  CarnetScreen({Key? key, required this.userToken}) : super(key: key);

  @override
  _CarnetScreenState createState() => _CarnetScreenState();
}

class _CarnetScreenState extends State<CarnetScreen> {
  late WalletController walletController;
  late Future<List<Carnet>> _futureCarnets;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    walletController = Get.put(WalletController());
    _futureCarnets = walletController.fetchCarnets();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _refreshCarnets() {
    setState(() {
      _futureCarnets = walletController.fetchCarnets();
    });
  }

  Widget _successDialogWidget() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
              SizedBox(height: 15),
              Text(
                'نجاح',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'تم استعمال الكارنيه بنجاح!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  _pollingTimer?.cancel();
                  Navigator.pop(context);
                  _refreshCarnets();
                },
                child: Text('حسنا', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showQrDialog(Carnet carnet) async {
    Carnet displayedCarnet = carnet;

    _pollingTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      try {
        List<Carnet> currentCarnets = await walletController.fetchCarnets();
        Carnet? updatedCarnet = currentCarnets.firstWhere(
          (c) => c.token == displayedCarnet.token,
          orElse: () => displayedCarnet,
        );

        bool isUsed = updatedCarnet.usageCount > displayedCarnet.usageCount ||
            !updatedCarnet.isActive;

        if (isUsed) {
          timer.cancel();
          if (Navigator.canPop(context)) Navigator.pop(context);
          _refreshCarnets();

          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black54,
            transitionDuration: Duration(milliseconds: 300),
            pageBuilder: (context, animation1, animation2) {
              return _successDialogWidget();
            },
            transitionBuilder: (context, animation1, animation2, child) {
              return FadeTransition(
                opacity: animation1,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: animation1,
                    curve: Curves.easeOutBack,
                  ),
                  child: child,
                ),
              );
            },
          );
        }
      } catch (e) {
        print("Polling error: $e");
      }
    });

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => WillPopScope(
        onWillPop: () async {
          _pollingTimer?.cancel();
          return true;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImageView(
                  data: carnet.token,
                  version: QrVersions.auto,
                  size: 200,
                ),
              ),
              SizedBox(height: 10),
              Text('Présentez ce QR au restaurant pour l’utiliser'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _pollingTimer?.cancel();
                Navigator.pop(context);
                _refreshCarnets();
              },
              child: Text('Fermer'),
            ),
          ],
        ),
      ),
    );

    _pollingTimer?.cancel();
  }

  List<Color> _getGradientColors(String type) {
    switch (type) {
      case 'Silver':
        return [
          Colors.grey.shade600,
          Colors.grey.shade500,
          Colors.grey.shade400,
        ];
      case 'Golden':
        return [
          Colors.amber.shade700,
          Colors.amber.shade500,
          Colors.amber.shade300,
        ];
      case 'Bronze':
      default:
        return [
          Colors.deepOrange.shade700,
          Colors.deepOrange.shade400,
          Colors.deepOrange.shade200,
        ];
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Silver':
        return Icons.star_half;
      case 'Golden':
        return Icons.star;
      case 'Bronze':
      default:
        return Icons.star_border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        return Scaffold(
          appBar: AppBar(
            title: Text('Mes Carnets'),
            centerTitle: true,
          ),
          body: FutureBuilder<List<Carnet>>(
            future: _futureCarnets,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wallet_giftcard,
                          size: 250,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'لا يوجد أي كارنيه نشط',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'يمكنك الحصول على كارنيه باستعمال نقاطك الموجودة في المحفظة والتمتع بعروض مميزة من المطاعم.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade600,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.shopping_bag),
                          label: const Text(
                            'استعرض العروض',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            // TODO: Navigate to offers or home screen
                            Get.back(); // أو Get.to(YourOffersScreen());
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => WalletLauncher()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Aucun carnet actif trouvé'));
              }

              final carnets = snapshot.data!;
              return ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: carnets.length,
                separatorBuilder: (_, __) => SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final carnet = carnets[index];
                  final remaining = carnet.usageLimit - carnet.usageCount;
                  final percent =
                      carnet.usageLimit > 0 ? remaining / carnet.usageLimit : 0;
                  final gradientColors = _getGradientColors(carnet.type);

                  return Center(
                    child: Stack(
                      children: [
                        Container(
                          width: isWide ? 600 : double.infinity,
                          margin: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              colors: gradientColors,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: gradientColors.last.withOpacity(0.6),
                                blurRadius: 10,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _getTypeIcon(carnet.type),
                                      color: Colors.white70,
                                      size: 28,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      '${carnet.type} Carnet',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      carnet.isActive
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: carnet.isActive
                                          ? Colors.greenAccent
                                          : Colors.redAccent,
                                      size: 20,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24),
                                Text(
                                  'Solde restant',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${5 * remaining} DT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Utilisations restantes :',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Text(
                                      '$remaining / ${carnet.usageLimit}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: percent.toDouble(),
                                  backgroundColor: Colors.white24,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.greenAccent),
                                  minHeight: 8,
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month_outlined,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          carnet.canUseToday
                                              ? "Utiliser aujourd'hui : Non "
                                              : "Utiliser aujourd'hui : Oui",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Transform.translate(
                                      offset: Offset(10, 0),
                                      child: Material(
                                        elevation: 6,
                                        borderRadius: BorderRadius.circular(8),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () => _showQrDialog(carnet),
                                          child: Padding(
                                            padding: const EdgeInsets.all(12),
                                            child:
                                                Icon(Icons.qr_code, size: 28),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: isWide ? 80 : 0,
                          child: Opacity(
                            opacity: 0.6,
                            child: Image.asset(
                              'images/app_logo.png',
                              scale: 0.9,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
