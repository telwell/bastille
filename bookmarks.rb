USERS = 5
INITIAL_URLS = 50

class App

	# Let's give our app some initial data to work with
	def initialize
		@data = init_data
		@user_ids = build_user_ids(@data)
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
	
	
	# NOTE: This function doesn't actually work but provides a basic
	# idea of how it would work if we had an actual relevance graph
	# with working Node objects.
	def get_recommended_urls(user_id, url)
		hop_count = 0
		initial_node = get_node(url)
		nodes = adjacent_nodes(initial_node)
		
		# It's 2 because we start with the nodes
		# ADJACENT to the initial node, not the initial
		# node itself.
		until hop_count == 2
			temp_nodes = []
			nodes.each do |node|
				temp_nodes << adjacent_nodes(node)
			end
			# Flatten turns nested arrays into a single array
			# [1,[2,3]].flatten => [1,2,3]
			nodes = temp_nodes.flatten
			hop_count += 1
		end
		
		# Finally, return a collection of our recommended URLs
		nodes.collect{|node| node.get_url}
	end
	
	
	# Return the nodes adjacent to a given node
	def adjacent_nodes(node)
		adjacent_nodes = []
		adjacent_nodes << node.A if node.A
		adjacent_nodes << node.B if node.B
		adjacent_nodes << node.C if node.C
		adjacent_nodes
	end


private


	def init_data
		# Ensure that data is empty. I could have used unless here
		# but I find it convoluted to read at times.
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
