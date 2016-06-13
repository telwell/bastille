require_relative('node')

USERS = 5
INITIAL_URLS = 50

class App

	# Let's give our app some initial data to work with
	def initialize
		@data = init_data
		@user_ids = build_user_ids(@data)
		@nodes = build_nodes
	end
	
	
	# Getter for data (for testing)
	def data
		return @data
	end
	
	
	# Getter for user_ids (for testing)
	def user_ids
		return @user_ids
	end
	
	
	def save_url(user_id, url)
		if valid_user_id?(user_id)
			urls_for_user = get_urls(user_id)
			if !has_url?(urls_for_user, url)
				@data << {
					# Don't need to +1 this b/c there our 
					# initial loop starts at 0
					:id => @data.length,
					:user_id => user_id,
					:url => url,
					:created_at => Time.now
				}
				return true
			end
		end
		false
	end
	
	
	def get_urls(user_id)
		if !valid_user_id?(user_id)
			puts "Invalid user_id"
			return false
		end
		
		urls = []
		@data.collect do |entry|
			urls << entry if entry[:user_id] == user_id
		end
		urls
	end
	
	
	def delete_url(user_id, url)
		urls_for_user = get_urls(user_id)
		if valid_user_id?(user_id) && has_url?(urls_for_user, url)
			@data.delete_if do |entry|
				entry[:user_id] == user_id && entry[:url] == url
			end
			return true
		end
		false
	end
	
	
	def get_users_by_domain(domain)
		user_ids = []
		@data.each do |entry|
			if entry[:url] == domain && !user_ids.include?(entry[:user_id])
				user_ids << entry[:user_id]
			end
		end
		user_ids
	end
	
	
	def get_deep_nodes(user_id, url, node = nil, hop_count = 0)
		nodes = []
		node = get_node(url) if node.nil?
		if hop_count == 3
			return node
		else
			nodes << get_deep_nodes(user_id, url, node.a, hop_count + 1) if node.a
			nodes << get_deep_nodes(user_id, url, node.b, hop_count + 1) if node.b
			nodes << get_deep_nodes(user_id, url, node.c, hop_count + 1) if node.c
		end
		# TODO: Filter nodes that a user has already saved
		return nodes.flatten
	end
	
	
	def get_node(url)
		@nodes.each do |i, node|
			if node.url == url
				return node
			end
		end
		return false
	end


private


	def init_data
		# Ensure that data is empty.
		data = []
		# Random number generator to be used when creating URLs
		r = Random.new
		INITIAL_URLS.times do |i|
			rand = r.rand(1..10)
			data << {
				:id => i,
				# Random number from 1 to number of USERS
				:user_id => (1..USERS).to_a.sample,
				:url => "random_#{rand}.com",
				:created_at => Time.now
			}
		end
		data
	end
	
	
	# Build an array of our user_ids based on the data
	def build_user_ids(data)
		ids = []
		data.collect do |x|
			ids << x[:user_id] if !ids.include?(x[:user_id])
		end
		ids
	end
	
	
	def build_nodes
		nodes = {}
		nodes[:n1] = Node.new(1, 1)
		nodes[:n2] = Node.new(2, 2)
		nodes[:n3] = Node.new(3, 3)
		nodes[:n4] = Node.new(4, 4)
		nodes[:n5] = Node.new(5, 5)
		nodes[:n6] = Node.new(6, 6)
		nodes[:n7] = Node.new(7, 7)
		nodes[:n8] = Node.new(8, 8)
		nodes[:n9] = Node.new(9, 9)
		nodes[:n10] = Node.new(10, 10)
		nodes[:n11] = Node.new(11, 11)
		nodes[:n12] = Node.new(12, 12)
		nodes[:n13] = Node.new(13, 13)
		nodes[:n14] = Node.new(14, 14)
		nodes[:n15] = Node.new(15, 15)
		nodes[:n16] = Node.new(16, 16)
		nodes[:n17] = Node.new(17, 17)

		nodes[:n1].a = nodes[:n2]
		nodes[:n1].b = nodes[:n3]
		nodes[:n1].c = nodes[:n4]
		nodes[:n4].c = nodes[:n5]
		nodes[:n5].a = nodes[:n6]
		nodes[:n5].b = nodes[:n7]
		nodes[:n6].b = nodes[:n8]
		nodes[:n3].b = nodes[:n9]
		nodes[:n9].a = nodes[:n10]
		nodes[:n9].b = nodes[:n12]
		nodes[:n9].c = nodes[:n13]
		nodes[:n10].a = nodes[:n11]
		nodes[:n13].c = nodes[:n14]
		nodes[:n3].c = nodes[:n15]
		nodes[:n15].b = nodes[:n16]
		nodes[:n16].b = nodes[:n17]
		
		nodes
	end
	
	
	# Return true if user_id is in our data
	def valid_user_id?(user_id)
		@user_ids.include?(user_id)
	end
	
	
	# Return true if a collection has a given URL 
	# as an entry already.
	def has_url?(urls_for_user, url)
		urls_for_user.each do |entry|
			return true if entry[:url] == url
		end
		false
	end
	
	
end
