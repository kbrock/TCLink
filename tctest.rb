#!/usr/bin/ruby
#
# Test script for the TCLink Ruby client.
#

#rails and bundler will typically setup the load path for us
$: << 'ext'

# Attempt to load the TCLink extension

begin
  require 'tclink'
rescue LoadError
  print "Failed to load TCLink extension\n"
  exit
end

print "TCLink version " + TCLink.getVersion() + "\n"
print "Sending transaction..."

# Build a hash containing our parameters
params = {}
params["custid"] = "TestMerchant"
params["password"] = "password"
params["action"] = "sale"
params["media"] = "cc"
params["cc"] = "4111111111111111"
params["exp"] = "0110"
params["amount"] = "100"
params["name"] = "Joe Ruby"

# Send the hash to TrustCommerce for processing
result = TCLink.send(params)

print "done!\n\nTransaction results:\n"

# Print out all parameters returned

for key in result.keys()
  print "\t" + key + "=" + result[key] + "\n"
end
