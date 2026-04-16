#include "player/Player.h"
#include "network/Server.h"

#include <QQmlApplicationEngine>
#include <QQuickWindow>

int main(int argc, char **argv)
{
  QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGL);

  QGuiApplication app(argc, argv);
  std::setlocale(LC_NUMERIC, "C");

  QCoreApplication::setApplicationName("maikyno_desktop");
  QCoreApplication::setOrganizationName("maikyno_desktop");

  QQmlApplicationEngine engine;
  QObject::connect(&engine, &QQmlApplicationEngine::quit,
    &app, &QGuiApplication::quit);

  Server *server = new Server(&app);
  qmlRegisterSingletonInstance("Server", 1, 0, "Server", server);
  qmlRegisterType<Player>("Player", 1, 0, "Player");

  engine.loadFromModule("pages", "Main");
  return app.exec();
}
