module ApplicationHelper
  def show_error_messages_for(model)
    render 'shared/error_messages', :model => model unless model.errors.empty?
  end

  def show_button_dropdown(main_action, extra_actions = [], options = {})
    if extra_actions.blank?
      main_action
    else
      out = ''.html_safe

      out << render(
        :partial => 'shared/button_dropdown', :locals => {
          :main_action => main_action, :extra_actions => extra_actions
        }
      )
    end
  end

  def pagination_links(objects, params = nil)
    result = will_paginate objects,
      :inner_window => 1, :outer_window => 1, :params => params,
      :renderer => BootstrapPaginationHelper::LinkRenderer,
      :class => 'pagination pagination-right'
    page_entries = content_tag(
      :blockquote,
      content_tag(
        :small,
        page_entries_info(objects),
        :class => 'page-entries hidden-desktop pull-right'
      )
    )

    unless result
      previous_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.previous_label').html_safe),
        :class => 'previous_page disabled'
      )
      next_tag = content_tag(
        :li,
        content_tag(:a, t('will_paginate.next_label').html_safe),
        :class => 'next disabled'
      )

      result = content_tag(
        :div,
        content_tag(:ul, previous_tag + next_tag),
        :class => 'pagination pagination-right'
      )
    end

    result + page_entries
  end

  def link_to_show(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.show')
    options['data-show-tooltip'] ||= true

    args << options

    link_to '&#xe074;'.html_safe, *args
  end

  def link_to_edit(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.edit')
    options['data-show-tooltip'] ||= true

    args << options

    link_to '&#x270e;'.html_safe, *args
  end

  def link_to_destroy(*args)
    options = args.extract_options!

    options['class'] ||= 'iconic'
    options['title'] ||= t('label.delete')
    options['method'] ||= :delete
    options['data-confirm'] ||= t('messages.confirmation')
    options['data-show-tooltip'] ||= true

    args << options

    link_to '&#xe05a;'.html_safe, *args
  end

  def dynamic_object_id(prefix, form_builder)
    "#{prefix}_#{form_builder.object_name.to_s.gsub(/[_\]\[]+/, '_')}"
  end
end
