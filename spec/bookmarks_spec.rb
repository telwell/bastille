require 'rspec'
require_relative '../bookmarks'

RSpec.describe App, "#bookmarks" do
	before(:each) do
		@app = App.new
	end
	
	context "initialize" do
		it "should initialize with the proper amount of data" do
			expect(@app.data.count).to eq(50)
		end
		
		it "should initialize with an array of user_ids" do
			expect(@app.user_ids.count).to eq(5)
		end
	end
	
	context "get_urls" do
		it "should be able to get urls by user_id" do
			expect(@app.get_urls(1)).to be_truthy
		end
		
		it "should fail if given an invalid user_id" do
			expect(@app.get_urls(10)).to be(false)
		end
	end
	
	context "save_url" do
		it "should be able to save a new url" do
			@app.save_url(1, "google.com")
			expect(@app.data.count).to eq(51)
		end
		
		it "should fail when given a URL that's already saved" do
			@app.save_url(1, "google.com")
			expect(@app.save_url(1, "google.com")).to be(false)
		end
	end
	
	context "delete_url" do
		it "should be able to delete a url that exists" do
			@app.save_url(1, "google.com")
			expect {@app.delete_url(1, "google.com")}.to change {@app.data.count}.from(51).to(50)
		end
		
		it "should return false if trying to delete a url that doesn't exist" do
			expect(@app.delete_url(1, "google.com")).to be(false)
		end
	end
	
	context "get_users_by_domain" do
		it "should be able to get a collection of urls based on domain" do
			@app.save_url(1, "google.com")
			expect(@app.get_users_by_domain("google.com").count).to eq(1)
		end
		
		it "should return an empty array if no users have saved the given url" do
			expect(@app.get_users_by_domain("google.com").count).to eq(0)
		end
	end
	
end
