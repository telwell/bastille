class Node
	attr_accessor :a
	attr_accessor :b
	attr_accessor :c
	attr_reader :url
	
	def initialize(id, url, a = nil, b = nil, c = nil)
		@id = id
		@a = a
		@b = b
		@c = c
		@url = url
	end
	
	def get_url(url)
		return @url
	end

end
