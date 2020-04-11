import 'package:anotacoes/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AnotacaoHelper {

  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database _banco;

  factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal();

  get banco async {
    if(_banco != null){
        return _banco;
    }else{
      return _banco = await inicializarBanco(); 
    }
  }

_onCreate(Database db, int version) async {
      String sql = "CREATE TABLE anotacao (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo VARCHAR, descricao TEXT, data DATETIME)";
      await db.execute(sql);
}


  inicializarBanco() async{
      final pathBanco = await getDatabasesPath();
      final localBanco = join(pathBanco,"banco.db");
      var db = await openDatabase(localBanco, version:1, onCreate: _onCreate); 
      return db;
  }

  Future<int> salvarAnotacao(Anotacao anotacao) async{

      var bd = await banco;
      int id = await bd.insert("anotacao",anotacao.toMap());
      return id;
  }

  getAnotacao() async{
       var bd = await banco;
       String sql = "SELECT * FROM anotacao ORDER BY data DESC";
       List anotacoes = await bd.rawQuery(sql);
       return anotacoes;
  }

  Future<int> atualizarNota(Anotacao anotacao)async{
    var bd = await banco;
    return await bd.update(
    "anotacao",anotacao.toMap(),
    where: "id = ?",
    whereArgs: [anotacao.id]
    );

  }

  Future<int> excluirNota( int id)async{
    var bd = await banco;
    return await bd.delete(
    "anotacao",
    where: "id = ?",
    whereArgs: [id]
    );
  }

}