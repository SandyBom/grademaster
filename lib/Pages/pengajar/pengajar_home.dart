import 'package:flutter/material.dart';
// TODO: add flutter_svg to pubspec.yaml
import 'package:grademaster/datas/demo.dart';
import 'package:grademaster/components/material_3_demo/lib/own_component.dart';

class HomePengajar extends StatelessWidget {
  static const nameRoute = '/homepengajar';

  const HomePengajar({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 90),
          child: SafeArea(
              child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.elliptical(40, 40)),
                  image: DecorationImage(
                    image: AssetImage('ab.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Text('Beranda',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: OwnColor.colors['Putih'])),
              ),
            ],
          ))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            DiscountBanner(),
            GenerateCard(),
          ],
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(),
    );
  }
}

class DiscountBanner extends StatelessWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF4A3298),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text.rich(
        TextSpan(
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(text: "A Summer Surpise\n"),
            TextSpan(
              text: "Cashback 20%",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenerateCard extends StatelessWidget {
  const GenerateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Determine crossAxisCount based on screen width
              int crossAxisCount;
              double screenWidth = constraints.maxWidth;

              if (screenWidth > 920) {
                crossAxisCount = 3; // Large screens
              } else {
                crossAxisCount = 2; // Small screens
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: demoAssesment.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return AssesmentCardP(assesment: demoAssesment[index]);
                },
              );
            },
          ),
        )
      ],
    );
  }
}

class AssesmentCardP extends StatelessWidget {
  const AssesmentCardP({
    Key? key,
    this.width = 220,
    required this.assesment,
  }) : super(key: key);

  final width;
  final Assesment assesment;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.zero),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(OwnColor.colors['BiruMuda']),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/register');
            },
            child: Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: screenSize.width * 0.15,
                          child: Text(
                            assesment.title,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                overflow: TextOverflow.ellipsis),
                            maxLines: 4,
                          )),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.09,
                          height: MediaQuery.of(context).size.width * 0.09,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue,
                          ),
                          child: Container(
                            child: IconDropdown(),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.26,
                        child: Text(
                          assesment.description,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 2,
                        ),
                      )
                    ],
                  ),
                  Container(
                      child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            assesment.date,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.018,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            assesment.time,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.018,
                            ),
                          )
                        ],
                      )
                    ],
                  ))
                ],
              ),
            )));
  }
}
