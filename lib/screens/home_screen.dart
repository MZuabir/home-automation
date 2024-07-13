import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_automation/app/controllers/dashboard_controller.dart';
import 'package:home_automation/app/views/shared/text_widget.dart';
import 'package:home_automation/app/views/shared/wave_loading.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/screens/add_rooms.dart';
import 'package:home_automation/screens/room_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });
  static final dashController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25) +
            const EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.vertical_distribute_outlined,
                    color: Colors.white),
                Obx(
                  () => ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CircleAvatar(
                      radius: 25,
                      child: CachedNetworkImage(
                        imageUrl: dashController.userData?.value?.image ?? "",
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const WaveLoadingWidget(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //
            SizedBox(height: screenSize.height * .05),
            Obx(
              () => Text(
                'Hello ${dashController.userData?.value?.name} 👋',
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const Text(
              'Welcome to Smartify',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),

            //
            SizedBox(height: screenSize.height * .05),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("sensors")
                  .doc("dht11")
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    WeatherInfo weatherInfo =
                        getWeatherInfo(data["temperature"]);
                    return Container(
                      padding: const EdgeInsets.all(14),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(125, 43, 66, 82),
                          borderRadius: BorderRadius.circular(30)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomTextWidget(
                                text: weatherInfo.icon,
                                fontSize: 25,
                              ),
                              SizedBox(width: screenSize.width * .02),
                              CustomTextWidget(
                                text: weatherInfo.condition,
                                color: Colors.white,
                                fontSize: 25,
                              ),
                              const Spacer(),
                              CustomTextWidget(
                                text: '${data["temperature"]}°C',
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ],
                          ),
                          //
                          SizedBox(height: screenSize.height * .03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              PredictColumn(
                                data: weatherInfo.sensibleTemperature,
                                title: 'Sensible',
                              ),
                              PredictColumn(
                                data: " ${data["humidity"]} %",
                                title: 'Humidity',
                              ),
                              const PredictColumn(
                                data: '16km/h ',
                                title: 'Wind',
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                  const CustomTextWidget(
                    text: "Temperature device not connected.",
                    color: Colors.white,
                  );
                }
                return const WaveLoadingWidget();
              },
            ),

            //
            SizedBox(height: screenSize.height * .02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Rooms',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const AddRoom());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.red.withOpacity(0.8),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenSize.height * .02),
            ////////////////////////////Rooms List//////////////////////////////////////
            SizedBox(
              height: screenSize.height * .4,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('rooms')
                      .where("email",
                          isEqualTo: FirebaseAuth.instance.currentUser?.email)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: WaveLoadingWidget());
                    } else {
                      final rooms = snapshot.data!.docs;

                      return GridView.builder(
                          itemCount: rooms.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.8,
                            crossAxisCount: 2,
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 25,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            // int sensors = getSensors(rooms[index].id);
                            return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.grey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    padding: EdgeInsets.zero),
                                onPressed: () {
                                  Get.to(() => RoomScreen(
                                      title: rooms[index].id,
                                      roomName: rooms[index].id));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Container(
                                        padding: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: rooms[index]["image"],
                                          fit: BoxFit.cover,
                                          height: 120,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10), // Add spacing
                                    Text(
                                      rooms[index]["title"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    FutureBuilder<int>(
                                      future: getSensors(rooms[index].id),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox.shrink();
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        } else {
                                          int sensorsCount = snapshot.data!;

                                          return CustomTextWidget(
                                            text: 'Devices $sensorsCount',
                                            color: Colors.white,
                                          );
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ));
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  WeatherInfo getWeatherInfo(double temperatureCelcius) {
    String icon = '';
    String condition = '';
    String sensibleTemperature = '';

    // Determine weather conditions based on temperature
    if (temperatureCelcius < 10) {
      icon = '❄️🥶'; // Replace with your cold weather icon asset name
      condition = 'Cold';
      sensibleTemperature = 'Wear warm clothes';
    } else if (temperatureCelcius >= 10 && temperatureCelcius < 25) {
      icon = '🌤️'; // Replace with your mild weather icon asset name
      condition = 'Mild';
      sensibleTemperature = 'Comfortable';
    } else {
      icon = '🌞🔥'; // Replace with your hot weather icon asset name
      condition = 'Hot';
      sensibleTemperature = 'Stay hydrated';
    }

    return WeatherInfo(
        icon: icon,
        condition: condition,
        sensibleTemperature: sensibleTemperature);
  }

  Future<int> getSensors(String roomId) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('sensors')
        .get();
    return querySnapshot.docs.length;
  }
}

class PredictColumn extends StatelessWidget {
  const PredictColumn({super.key, required this.data, required this.title});
  final String data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextWidget(
          text: data,
          fontSize: 18,
          color: Colors.white,
        ),
        CustomTextWidget(
          text: title,
          fontSize: 18,
          color: Colors.white,
        ),
      ],
    );
  }
}

class WeatherInfo {
  final String icon;
  final String condition;
  final String sensibleTemperature;

  WeatherInfo(
      {required this.icon,
      required this.condition,
      required this.sensibleTemperature});
}
