import 'package:flutter/services.dart';
import 'package:voting_app/constant.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async{
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contract_address;

  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'), EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String functionname, List<dynamic> args, Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(functionname);
  final result = await ethClient.sendTransaction(credentials, Transaction.callContract(contract: contract, function: ethFunction, parameters: args), chainId: null, fetchChainIdFromNetworkId: true);

  return result;
}

Future<String> startElection(String name, Web3Client ethClient) async {
  var response = await callFunction('startElection', [name], ethClient, owner_private_key);
  print("Election Started Successfully\n");
  return response;
}

Future<String> addCandidate(String name, Web3Client ethClient) async {
  var response = await callFunction('addCandidate', [name], ethClient, owner_private_key);
  print("Candidate Added Successfully\n");
  return response;
}

Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  var response = await callFunction('authorizeVoter', [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  print("Voter Authorized Successfully\n");
  return response;
}

Future<List> getCandidatesNum(Web3Client ethClient) async{
  List<dynamic> result = await ask('getNumCandidates', [], ethClient);
  return result;
}

Future<List> getTotalVotes(Web3Client ethClient) async{
  List<dynamic> result = await ask('getTotalVotes', [], ethClient);
  return result;
}

Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result = await ask('candidateInfo', [BigInt.from(index)], ethClient); 
  return result;
}

Future<List<dynamic>> ask(String functionname, List<dynamic> args, Web3Client ethClient) async{
  final contract = await loadContract();
  final ethFunction = contract.function(functionname);
  final result = ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> vote(int candidateIndex, Web3Client ethClient) async{
  var response = await callFunction('vote', [BigInt.from(candidateIndex)], ethClient, voter_private_key);
  print('Voted Successfully');
  return response;
}