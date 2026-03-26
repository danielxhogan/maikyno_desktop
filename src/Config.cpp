#include "Config.h"

#include <QSettings>

Config::Config()
{
    QSettings settings("maikyno", "maikyno");
    ip = settings.value("ip").toString();
}

void Config::set_ip(const QString &ip_prop)
{
    if (ip_prop == ip)
        return;
    ip = ip_prop;
    QSettings settings("maikyno", "maikyno");
    settings.setValue("ip", ip);
    emit ip_changed();
}

QString Config::get_ip() const
{
    return ip;
}
