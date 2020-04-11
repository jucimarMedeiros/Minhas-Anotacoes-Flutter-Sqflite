import 'package:anotacoes/controller/Controller.dart';
import 'package:anotacoes/helper/anotacaoHelper.dart';
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {  
  
  List<Anotacao> listaNotas  = new List<Anotacao>();
  var banco = AnotacaoHelper();
  var controller = Controller();
  var _tituloController =  new TextEditingController();
  var _notaController =  new TextEditingController();

  @override
  void initState() {       
    super.initState();
    recuperartAnotacaor();    
  }
  @override
  Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
          title: Text("Minhas Anotações"),
          backgroundColor: Colors.blue,
        ) ,
        body: Column(
              children: <Widget>[
                  Expanded(
                    child:  ListView.builder(
                          itemCount: listaNotas.length,
                          itemBuilder: (context, index){
                              final nota = listaNotas[index];
                              return Slidable(
                                      actionPane: SlidableDrawerActionPane(),
                                      actionExtentRatio: 0.20,
                                      child: Card(                                          
                                          child: ListTile(
                                              title: Text(nota.titulo,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,fontSize: 22
                                              ),  
                                              ),
                                              subtitle: Text("${nota.descricao},${controller.formatarData(nota.data)}"),
                                               
                                          )
                                      ),
                                      actions: <Widget>[
                                          IconSlideAction(
                                          caption: 'Editar',
                                          color: Colors.blue,
                                          icon: Icons.edit,
                                          onTap:(){
                                            _alertaCadastro(anotacao: nota);
                                          }// ,   
                                       ), 
                                       IconSlideAction(
                                         caption: 'Excluir',
                                         color: Colors.red,
                                         icon: Icons.delete,
                                         onTap: () {
                                          _alertaExcluir(nota.id);
                                         },   
                                     ),
                                  ],      
                              );
                          },
                    ),
                  ),
              ],
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
              _alertaCadastro();
          }),
        bottomNavigationBar: BottomAppBar(
          color: Colors.blueAccent,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
                IconButton(icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ), onPressed: () => showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: Text("Acesse: github.com/jucimarMedeiros"),
                  )
                  ))
            ],
          ),
        ),

    );
  }
 
 recuperartAnotacaor() async{
      List anotacoesRecuperar = await banco.getAnotacao();
      List<Anotacao> listaTemporaria = new List<Anotacao>();

      for(var item in anotacoesRecuperar){
          Anotacao anotacao = Anotacao.fromMap(item);
          listaTemporaria.add(anotacao);
      } 
     setState(() {
      listaNotas = listaTemporaria;
    });
        
    
   listaTemporaria = null;         
  }
  

  _alertaExcluir(int id){
    showDialog(context: context,
    builder: (context){
      return AlertDialog(
          title: Text("Confirmar Exclusão"),
          content: Column(
             mainAxisSize: MainAxisSize.min,
             children: <Widget>[
                Text("Deseja realmente excluir?"),                
             ],
          ),
          actions: <Widget>[
             FlatButton(
               onPressed: () => Navigator.pop(context),
                child: Text("NÃO")
            ),
             FlatButton(
               onPressed: (){
                controller.excluirAnotacao(id);
                recuperartAnotacaor();
                 Navigator.pop(context);
               },
                child: Text("SIM"),
            )
          ],
      );
    }
    );
  }

  _alertaCadastro({Anotacao anotacao}){

    String atual = "";
    if(anotacao == null){
        _tituloController.text = "";
        _notaController.text = ""; 
        atual = "Salvar";
    }else{
        _tituloController.text = anotacao.titulo;
        _notaController.text = anotacao.descricao;
        atual = "Atualizar";
    }

    showDialog(
      context: context,
      builder: (context){
          return AlertDialog(
            title: Text("$atual Nota"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                      TextField(
                        controller: _tituloController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: "Título",
                          hintText: "Informe o título" 
                        ), 
                      ),
                      TextField(
                        controller: _notaController,                       
                        decoration: InputDecoration(
                          labelText: "Nota",
                          hintText: "Informe a nota" 
                        ), 
                      )
                ], 
            ),
            actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
                  ),
                  FlatButton(
                  onPressed: (){
                    controller.salvarAnotacaoController(nota: anotacao,titulo: _tituloController,descricao: _notaController);   
                    recuperartAnotacaor();                 
                    Navigator.pop(context);
                  },
                  child: Text(atual)
                  )
            ], 
          );
      }  
      );
  }
  

 

}
