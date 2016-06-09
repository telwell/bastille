# Overview

Solutions by [Trevor Elwell](http://trevorelwell.me)

**Please note** that I changed most of the function names so that they were a bit more 'Ruby-ish'.

The initial data has 50 URLs assigned to 5 random user_ids.

# Usage

Once you download the project you should initialize it by running something like: 
`app = App.new`

From there you can play with the initial data with the following functions: 

`save_url(user_id, url)`
Save a new URL to @data or return false if the user_id doesn't exist.

`get_urls(user_id)`
Return an array of all of the URLs associated with a given user_id. Returns
an empty array if there aren't any.

`delete_url(user_id, url)`
Delete a url from @data based on a user_id and a url. Returns false if a given url
doesn't exist for the given user_id.

`get_users_by_domain(domain)`
Return an array of all of the user_ids which have saved a given domain. Returns
an empty array if none exist.

# Get Recommended urls

This function doesn't work (as there isn't a working relevance graph) but in theory 
if we have a relevancy graph it should work exactly as needed.
