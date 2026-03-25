#pragma once

#include "PlayerBackend.h"

#include <QtQuick/QSGRenderNode>
#include <QOpenGLFunctions>

class PlayerRenderNode : public QSGRenderNode {
public:
    PlayerRenderNode(PlayerBackend *be) : backend(be) {}

    void set_rect(const QRectF &rect)
    {
        m_rect = rect;
    }

    QRectF rect() const override
    {
        return m_rect;
    }

    void render(const RenderState *state) override
    {
        if (!backend)
            return;
        GLint fbo;
        glGetIntegerv(GL_FRAMEBUFFER_BINDING, &fbo);
        backend->render(static_cast<int>(fbo), m_rect.width(), m_rect.height());
    }

private:
    PlayerBackend *backend;
    QRectF m_rect;
};
