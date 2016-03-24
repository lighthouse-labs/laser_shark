class ActivityPresenter < BasePresenter
  presents :activity

  delegate :name, to: :activity

  def render_sidenav
    if activity.prep?
      content_for :prep_nav do
        render('shared/menus/prep_side_menu')
      end
    else
      unless current_user.prepping? || current_user.prospect? || activity.prep?
        content_for :side_nav do
          render('layouts/side_nav')
        end
      end
    end
  end

  def render_prep_sidenav
    
  end

  def edit_button
    if activity.prep?
      path = edit_prep_activity_path(activity.section, activity)
    else
      path = edit_day_activity_path(@day, activity)
    end

    link_to 'Edit', path, class: 'btn btn-edit'
  end
end
