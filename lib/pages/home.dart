import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:voting_app/constant.dart';
import 'package:voting_app/pages/elctionInfo.dart';
import 'package:voting_app/services/functions.dart';
import 'package:web3dart/web3dart.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Client httpClient;
  late Web3Client ethClient;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    httpClient = Client();
    ethClient = Web3Client(infura_url, httpClient);
  }

  @override
  void dispose() {
    // Dispose resources here if needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Let's Vote"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter Election",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () async {
                  if (controller.text.isNotEmpty) {
                    await startElection(controller.text, ethClient);
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElectionInfo(
                          ethClient: ethClient,
                          electionName: controller.text,
                        ),
                      ),
                    );
                  }
                },
                child: const Text("Start Election"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
