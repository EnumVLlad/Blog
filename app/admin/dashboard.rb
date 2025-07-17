# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  controller do
    layout 'active_admin_dashboard'
    before_action do
      @body_class = 'active_admin_dashboard'
    end
  end

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div do
      raw <<-HTML
        <div class="admin-case">
          <div class="admin-case__menu">
            <form action="/admin" method="get" style="display:inline">
              <button type="submit" class="admin-btn">Dashboard</button>
            </form>
            <form action="/admin/blogs" method="get" style="display:inline">
              <button type="submit" class="admin-btn">Blogs</button>
            </form>
            <form action="/admin/users" method="get" style="display:inline">
              <button type="submit" class="admin-btn">Users</button>
            </form>
            <form action="/admin/logout" method="post" style="display:inline">
              <button type="submit" class="admin-btn admin-btn--logout">Logout</button>
            </form>
          </div>
          <div class="admin-case__admins">
            <div class="admin-case__admins-title">Администраторы</div>
            <ul class="admin-case__admins-list">
              <li>vladpilipenko640@gmail.com</li>
            </ul>
            <form action="/" method="get">
              <button type="submit" class="admin-btn admin-btn--back">Назад</button>
            </form>
          </div>
        </div>
      HTML
    end

    # Стандартный приветственный блок удалён — теперь отображается только ваш кастомный кейс.

  end # content
end
