module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'Whack'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def sortable(column:, coltitle: nil, direction: 'asc')
    # use a specified column title (if given) or else use the name of the database column given
    coltitle ||= column.titleize
    # sort_colum and sort_direction are private methods of the controller
    css_class = column == sort_column ? "current #{sort_direction(direction: direction)}" : 'notcurrent'
    if column == sort_column && sort_direction(direction: direction) == direction
      direction = opp_direction(direction)
    end
    link_to coltitle, { sort: column, direction: direction }, { class: css_class, remote: true }
  end

  def opp_direction(direction)
    return 'desc' if direction == 'asc'

    'asc'
  end

  # Returns a shortened date format for easier reading in list
  def date_reformat(date)
    word_date = '%d/%m/%y'
    date.nil? ? '-' : date.strftime(word_date)
  end
end
