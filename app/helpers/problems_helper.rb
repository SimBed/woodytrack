module ProblemsHelper
  def status_icon(status)
  icon_map = { sent: 'sent.png', project: 'project.png' }
  icon_map[status.to_sym]
  end
end
