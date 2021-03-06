import 'package:build/build.dart';
import 'package:f_orm_m8_sqlite/generator/database_helper_generator.dart';
import 'package:f_orm_m8_sqlite/generator/emitted_entity.dart';
import 'package:f_orm_m8_sqlite/generator/orm_m8_generator_for_annotation.dart';
import 'package:source_gen/source_gen.dart';

class M8Builder extends LibraryBuilder {
  static List<EmittedEntity> emittedEntities;
  static DatabaseProviderGenerator databaseProviderGenerator;

  LibraryBuilder annotationBuilder;
  OrmM8GeneratorForAnnotation ormM8GeneratorForAnnotation;

  String generatedAdapterExtension;
  String helpersExtension;
  String databaseFileStamp;

  M8Builder.withWrapper(
      {String generatedAdapterExtension = '.adapter.g.m8.dart',
      String helpersExtension = '.g.m8.dart',
      String databaseFileStamp = '0.2.0',
      String header})
      : super(
            databaseProviderGenerator ??= DatabaseProviderGenerator(
                databaseFileStamp, helpersExtension, header),
            generatedExtension: generatedAdapterExtension,
            header: header,
            additionalOutputExtensions: [helpersExtension]) {
    this.generatedAdapterExtension = generatedAdapterExtension;
    this.helpersExtension = helpersExtension;
    this.databaseFileStamp = databaseFileStamp;
    emittedEntities = List<EmittedEntity>();
    annotationBuilder = LibraryBuilder(
        OrmM8GeneratorForAnnotation.withEmitted(emittedEntities),
        generatedExtension: helpersExtension,
        header: header);
  }
  @override
  Future build(BuildStep buildStep) async {
    await annotationBuilder.build(buildStep);

    //nothing to be emmitted regarding to entities, after annotationBuilder finished build
    databaseProviderGenerator.emittedEntities ??= emittedEntities;

    return super.build(buildStep);
  }
}
