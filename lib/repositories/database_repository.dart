import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

Map<int, String> scripts = {
  1: ''' CREATE TABLE IF NOT EXISTS cinema(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT,
    bairro TEXT,
    cidade TEXT,
    estado TEXT,
    foto_do_cinema TEXT,
    nota INTEGER,
    comentario TEXT
  )
  ''',
  2: ''' CREATE TABLE IF NOT EXISTS filme(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    id_cinema INTEGER,
    poster TEXT,
    capa TEXT,
    titulo TEXT,
    genero TEXT,
    data TEXT,
    ingresso REAL,
    sinopse TEXT,
    comentario TEXT,
    nota INTEGER,
    FOREIGN KEY (id_cinema) REFERENCES cinema (id)
  )
  ''',
  3: ''' CREATE TABLE IF NOT EXISTS emBreve(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT,
    poster TEXT,
    capa TEXT,
    sinopse TEXT,
    assistido INTEGER,
    data_lancamento TEXT
  )
  '''
};

class DatabaseRepository{
  static Database? db;

  Future<Database> obterDatabase() async{
    if(db == null){
      return await iniciarDatabase();
    } else{
      return db!;
    }
  }

  static Future<Database> iniciarDatabase() async{
    var db = await openDatabase(
      path.join(await getDatabasesPath(), 'database1.db'),
      version: scripts.length,
      onCreate: (Database db, int version) async {
        for(var i = 1; i <= scripts.length; i++){
          await db.execute(scripts[i]!);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for(var i = oldVersion; i <= scripts.length; i++){
          await db.execute(scripts[i]!);
        }
      },      
    );
    return db;
  }
}