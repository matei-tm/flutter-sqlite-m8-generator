library orm_m8_generator.wrapper;

import 'dart:async';

import 'package:build/build.dart';
import 'package:f_orm_m8_sqlite/generator/emitted_entity.dart';
import 'package:f_orm_m8_sqlite/generator/writers/database_helper_writer.dart';
import 'package:source_gen/source_gen.dart';

class DatabaseProviderGenerator extends Generator {
  List<EmittedEntity> emittedEntities;

  final String databaseFileStamp;
  final String helpersExtension;
  final String header;

  DatabaseProviderGenerator(
      this.databaseFileStamp, this.helpersExtension, this.header);

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    var name = library.element.name;
    if (name.isEmpty) {
      name = library.element.source.uri.pathSegments.last;
    }

    //if not main.dart then generate nothing
    if (name != 'main.dart') return '';
    print('Generating Database Helper Adapter...');
    //sort emittedEntities by modelName
    emittedEntities.sort((l, r) => l.modelName.compareTo(r.modelName));

    StringBuffer sb = StringBuffer();

    String databaseProviderBody = DatabaseProviderWriter(
            emittedEntities, databaseFileStamp, helpersExtension)
        .toString();

    sb.write(databaseProviderBody);

    return sb.toString();
  }
}
