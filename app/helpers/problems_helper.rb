module ProblemsHelper
  def status_icon(status)
  icon_map = { sent: 'checked.png', project: 'climber.png', untried: 'unchecked.png' }
  icon_map[status.to_sym]
  end
end
