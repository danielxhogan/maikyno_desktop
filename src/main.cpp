#include "player/Player.h"
#include "network/Server.h"

#include <QQmlApplicationEngine>
#include <QQuickWindow>

int main(int argc, char **argv)
{
  QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);
  QGuiApplication app(argc, argv);
  std::setlocale(LC_NUMERIC, "C");

  QCoreApplication::setApplicationName("maikyno");
  QCoreApplication::setOrganizationName("maikyno");

  QQmlApplicationEngine engine;
  QObject::connect(&engine, &QQmlApplicationEngine::quit,
    &app, &QGuiApplication::quit);

  qmlRegisterType<Player>("Player", 1, 0, "Player");
  qmlRegisterType<Server>("Server", 1, 0, "Server");
  engine.loadFromModule("pages", "Main");

  return app.exec();
}
