module PaginationHelper
  def paginator_class(inactive)
    inactive ? 'page-item inactive' : 'page-item'
  end
end
