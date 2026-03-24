#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QDir>
#include <QUrl>

int main(int argc, char **argv)
{
  QGuiApplication app(argc, argv);

  QCoreApplication::setApplicationName("maikyno");
  QCoreApplication::setOrganizationName("maikyno");

  QCommandLineParser parser;
  parser.addPositionalArgument("url", "path of media file to play");
  parser.process(app);

  QQmlApplicationEngine engine;
  QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);

  QUrl source;
  if (!parser.positionalArguments().isEmpty())
    source = QUrl::fromUserInput(parser.positionalArguments().at(0), QDir::currentPath());

  // QVariantMap initial_properties{
  //   {"source", source}
  // };

  // engine.setInitialProperties(initial_properties);

  engine.loadFromModule("pages", "Pages");

  return app.exec();
}
