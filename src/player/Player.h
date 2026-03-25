#pragma once

#include "PlayerBackend.h"

#include <QQuickItem>
#include <QSGNode>

#include <memory.h>

class Player : public QQuickItem {
    Q_OBJECT
    Q_PROPERTY(QString src READ get_src WRITE set_src NOTIFY src_changed);

public:
    explicit Player(QQuickItem *parent = nullptr);
    virtual ~Player() = default;

    enum PlayerBackendType {
        PLAYER_BACKEND_TYPE_MPV,
        PLAYER_BACKEND_TYPE_NONE
    };
    Q_ENUM(PlayerBackendType)

    QString get_src() const;
    void set_src(const QString &src_prop);

private:
    std::unique_ptr<PlayerBackend> backend;
    PlayerBackendType backend_type = PLAYER_BACKEND_TYPE_NONE;
    static void on_update(void *ctx);

signals:
    void new_frame();
    void player_backend_changed();
    void src_changed();

public slots:
    void pause_play();
    void seek(double sec);

protected:
    QSGNode *updatePaintNode(QSGNode             *old_node,
                             UpdatePaintNodeData *update_paint_node_data) override;
};
