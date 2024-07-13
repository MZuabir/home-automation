import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_automation/common/colors.dart';
import 'package:home_automation/screens/add_appliance.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key, required this.title, required this.roomName});
  final String title;
  final String roomName;

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25) +
            const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),
                Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("rooms")
                      .doc(widget.roomName)
                      .collection('sensors')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData) {
                        final appliances = snapshot.data.docs;

                        return GridView.builder(
                            itemCount: appliances.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 25,
                              mainAxisSpacing: 25,
                              childAspectRatio: 1.3,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return SensorButton(
                                isOn: appliances[index]['state'],
                                image: '',
                                title: appliances[index]['title'],
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("rooms")
                                      .doc(widget.roomName)
                                      .collection('sensors')
                                      .doc(appliances[index].id)
                                      .update({
                                    "state": !(appliances[index]['state'])
                                  });
                                },
                              );
                            });
                      }
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.grey,
        foregroundColor: Colors.white,
        onPressed: () {
          Get.to(() => AddAppliancePage(docPath: widget.roomName));
        },
        label: const Text("Add Appliance"),
      ),
    );
  }
}

class SensorButton extends StatelessWidget {
  const SensorButton({
    super.key,
    required bool isOn,
    required this.image,
    required this.onTap,
    required this.title,
  }) : _isOn = isOn;

  final bool _isOn;
  final String image;
  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isOn ? const Color(0xff00ff00) : Colors.black,
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/png/appliance.png',
            height: 30,
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _isOn ? 'On' : 'Off',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
