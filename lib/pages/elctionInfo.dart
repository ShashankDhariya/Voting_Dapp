import 'package:flutter/material.dart';
import 'package:voting_app/services/functions.dart';
import 'package:web3dart/web3dart.dart';

class ElectionInfo extends StatefulWidget {
  final Web3Client ethClient;
  final String electionName;

  const ElectionInfo({Key? key, required this.ethClient, required this.electionName}) : super(key: key);

  @override
  State<ElectionInfo> createState() => _ElectionInfoState();
}

class _ElectionInfoState extends State<ElectionInfo> {
  TextEditingController addCandidateController = TextEditingController();
  TextEditingController authorizeVoterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.electionName),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<List>(
                      future: getCandidatesNum(widget.ethClient),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: const TextStyle(
                            fontSize: 50,
                          ),
                        );
                      },
                    ),
                    const Text('Total Candidates'),
                  ],
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<List>(
                      future: getTotalVotes(widget.ethClient),
                      builder: (context, AsyncSnapshot<List> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        return Text(
                          snapshot.data![0].toString(),
                          style: const TextStyle(
                            fontSize: 50,
                          ),
                        );
                      },
                    ),
                    const Text('Total Votes'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: addCandidateController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Candidate Name',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    addCandidate(addCandidateController.text, widget.ethClient);
                  },
                  child: const Text('Add Candidate'),
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: authorizeVoterController,
                    decoration: const InputDecoration(
                      hintText: 'Authorize Voter',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    authorizeVoter(authorizeVoterController.text, widget.ethClient);
                  },
                  child: const Text('Authorize Vote'),
                ),
              ],
            ),

            const SizedBox(height: 20,),
            const Divider(),
            const SizedBox(height: 20,),

            FutureBuilder<List>(
              future: getCandidatesNum(widget.ethClient),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  return Column(
                    children: [
                      for(int i = 0; i < snapshot.data![0].toInt(); i++)
                        FutureBuilder<List>(
                          future: candidateInfo(i, widget.ethClient),
                          builder: (context, candidateSnapshot) {
                            if (candidateSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator(),);
                            } else {
                              return ListTile(
                                title: Text('Name: ${candidateSnapshot.data![0][0]}'), 
                                subtitle: Text('Votes: ${candidateSnapshot.data![0][1]}'), // Assuming party is the second attribute
                                trailing: ElevatedButton(
                                  onPressed: () {
                                    vote(i, widget.ethClient);
                                  },
                                  child: const Text('Vote')),
                              );
                            }
                          },
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
