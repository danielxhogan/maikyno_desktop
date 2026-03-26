#include "Server.h"

void Server::get_libraries(const QString &ip)
{
    if (true) {
        emit get_libraries_response_sucess();
    } else {
        get_libraries_response_error("server " + ip + " error.");
    }
}
