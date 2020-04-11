import 'package:anotacoes/helper/anotacaoHelper.dart';
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Controller {
    
  static final  Controller _controller = Controller._internal();
  var banco = AnotacaoHelper();
  List<Anotacao> listaNotas  = new List<Anotacao>();
  

  factory Controller(){
    return _controller;
  } 

  Controller._internal();

  formatarData(String data){
      initializeDateFormatting("pt_BR");
      var formatador = DateFormat("dd/MM/yyyy");
      DateTime dataConvertida = DateTime.parse(data);
      String dataFormatada = formatador.format(dataConvertida);
      return dataFormatada;
  }



   excluirAnotacao( int id)async{
    await banco.excluirNota(id);    
  }

   salvarAnotacaoController({Anotacao nota,TextEditingController titulo,TextEditingController descricao}) async{
    

    if (nota == null) {
       Anotacao anotacao = new Anotacao(titulo.text,descricao.text, DateTime.now().toString());
       int id = await banco.salvarAnotacao(anotacao);
    } else {     
      nota.titulo = titulo.text;
      nota.descricao = descricao.text;
      nota.data =   DateTime.now().toString();     
      int id = await banco.atualizarNota(nota);
    }       
  }
  

}