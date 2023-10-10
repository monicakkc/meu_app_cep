import 'package:flutter/material.dart';
import 'package:meuappcep/repositories/viacep_back_repository.dart';
import '../../models/viacepback_model.dart';

class BackCepPage extends StatefulWidget {
  const BackCepPage({Key? key}) : super(key: key);

  @override
  State<BackCepPage> createState() => _BackCepPageState();
}

class _BackCepPageState extends State<BackCepPage> {
  ViacepsBackRepositoy viacepbackRepository = ViacepsBackRepositoy();
  var _cepsBack = ViacepsBackModel();
  var cepContoller = TextEditingController();
  var carregando = false;

  @override
  void initState() {
    super.initState();
    obterCep();
  }

  void obterCep() async {
    setState(() {
      carregando = true;
    });
    _cepsBack =  await viacepbackRepository.obterCep();
    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("CEPs Consultados"),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("",
                      style: TextStyle(fontSize: 18),
                    ),
                   ],
                ),
              ),
              carregando
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: ListView.builder(
                          itemCount: _cepsBack.ceps.length,
                          itemBuilder: (BuildContext bc, int index) {
                            var cep = _cepsBack.ceps[index];
                            return Dismissible(
                              onDismissed:
                                  (DismissDirection dismissDirection) async {
                                await viacepbackRepository.remover(cep.objectId!);
                                obterCep();
                              },
                              key: Key(cep.objectId!),
                              child: Card(
                                child: ListTile(
                           //       isThreeLine: true,
                                  title: Text("${cep.cep!.substring(0,5)}-${cep.cep!.substring(5,8)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600 ),),
                                  subtitle: Text("${cep.logradouro!} - ${cep.localidade!} - ${cep.uf!} "),
                                  
                                ),
                              ),
                              
                            );
                          }),
                    ),
            ],
          ),
        ));
  }
}