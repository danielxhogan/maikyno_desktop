#pragma once

#include "PlayerBackend.h"

#include <QQuickItem>
#include <QSGNode>

#include <memory.h>

class Player : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY(PlayerBackendType backend READ get_backend WRITE set_backend NOTIFY player_backend_changed);

public:
    explicit Player(QQuickItem *parent = nullptr);
    virtual ~Player() = default;

    enum PlayerBackendType {
        PLAYER_BACKEND_TYPE_MPV,
        PLAYER_BACKEND_TYPE_NONE
    };
    Q_ENUM(PlayerBackendType)
    PlayerBackendType get_backend();
    void set_backend(PlayerBackendType pb);

private:
    std::unique_ptr<PlayerBackend> backend;
    PlayerBackendType backend_type = PLAYER_BACKEND_TYPE_NONE;
    static void on_update(void *ctx);

signals:
    void new_frame();
    void player_backend_changed();

public slots:
    void play_file(const QString &params);

protected:
    QSGNode *updatePaintNode(QSGNode             *old_node,
                             UpdatePaintNodeData *update_paint_node_data) override;
};
