
import 'package:flutter/material.dart';
import 'package:meuappcep/models/viacep_model.dart';
import 'package:meuappcep/models/viacepback_model.dart';
import 'package:meuappcep/pages/back_cep_page.dart';
import 'package:meuappcep/repositories/viacep_back_repository.dart';
import 'package:meuappcep/repositories/viacep_repository.dart';


class CepPage extends StatefulWidget {
  const CepPage({super.key});

  @override
  State<CepPage> createState() => _CepPageState();
}

class _CepPageState extends State<CepPage> {
  var cepController = TextEditingController(text: "");
  var viacepModel = ViacepModel();
  var _cepsBack = ViacepsBackModel();
  var viaCepRepository = ViacepRepository();
  var printlogradouro = "";
  var printdados = "";
  var achou = false;
  var carregando = false;
  var buscaViacep = false; 
  var cep = "";
  ViacepsBackRepositoy viacepsbackRepository = ViacepsBackRepositoy();

void carregandoDados() {
    setState(() {
      printlogradouro = "";
      printdados = "";
      carregando = true;
    });
}

void limpandoDados() {
      setState(() {
        carregando = false;
      });      
}


  @override
  Widget build(BuildContext context) {
return SafeArea(child: Scaffold(
 //     appBar: AppBar(title: const Text("Consulta CEP", style: TextStyle(fontWeight: FontWeight.w700),),),
      body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Image.asset(
                    "lib/images/cep.png",
                    height: 125,
                    ),
                ),
            Card(
              elevation: 10,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                child: Text("Consulta CEP", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),))),                      
          ]),
            const SizedBox(height: 20,),
            Center(
              child: 
              carregando
              ? const CircularProgressIndicator()
              :
              SizedBox(
                  height: 300,
                  child: Card(
                    elevation: 20,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(controller: cepController,
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            onChanged: (String value) async {
                              achou = false;
                              cep = value.replaceAll(RegExp(r'[^0-9]'),''); // troca qualquer caracter q não for num por vazio
                              if (cep.length == 8) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                carregandoDados();
                                _cepsBack =  await viacepsbackRepository.obterCep();
                                limpandoDados();
                                for (var i = 0; i < _cepsBack.ceps.length; i++) {
                                  var cepback = _cepsBack.ceps[i];
                                  if (cepback.cep == cep ) {
                                    achou = true;
                                    printlogradouro = "${cepback.logradouro}";
                                    printdados = "${cepback.localidade ?? ""} - ${cepback.uf ?? ""}";
                                  }
                                }
                                if (achou == false) {
                                  carregandoDados();
                                     viacepModel = await viaCepRepository.consultarCep(cep);
                                     if (viacepModel.cep == null) {
                                        printlogradouro = "CEP não encontrado";
                                        printdados = "";
                                     } else {
                                          await viacepsbackRepository.criar(ViacepBackModel.criar(
                                            cep, viacepModel.logradouro, viacepModel.complemento, viacepModel.bairro, viacepModel.localidade, viacepModel.uf));
                                    printlogradouro = "${viacepModel.logradouro}";
                                    printdados = "${viacepModel.localidade ?? ""} - ${viacepModel.uf ?? ""}";                                        
                                  }
                                }
                              }
                              limpandoDados();
                              // setState(() {                
                              // });
                            },
                            style: const TextStyle(color: Colors.black, fontSize: 18),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(top: 10),                    
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color:Color.fromARGB(255, 179, 77, 198))),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 158, 48, 23)),             
                                ),
                                hintText: "Digite o Cep",
                                hintStyle: TextStyle(color: Colors.black),
                                prefixIcon: Icon(Icons.mail,
                                color: Color.fromARGB(255, 158, 48, 23))),
                                ),
                          const SizedBox(height: 50,),
                          Text(printlogradouro, style: const TextStyle(fontSize: 20),),
                          Text(printdados, style: const TextStyle(fontSize: 20),),                   
                          const SizedBox(height: 20,),
                          Expanded(
                              child: Card(
                              child: TextButton(onPressed: () {
                                setState(() { 
                                  printlogradouro = "";
                                  printdados = "";  
                                  cepController.clear();
                                });
                                }, child: Text("LIMPAR", style: TextStyle(fontSize: 16),),),
                            )), 
                        ],
                      ),                      
                    ), 
               
                  ),
                ),
                
            ),
    
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Ceps Consultados",
        child: const Icon(Icons.list),
        onPressed: ()  {
           Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const BackCepPage()));
        },
      ),
     ));
  }
}