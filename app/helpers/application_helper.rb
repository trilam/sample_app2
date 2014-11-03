module ApplicationHelper

	# Setup full title
	def full_title(page_title = '') 
		return "Ruby on Rails Tutorial Sample App" if page_title.empty?
		return "#{page_title} | Ruby on Rails Tutorial Sample App"
	end

end
