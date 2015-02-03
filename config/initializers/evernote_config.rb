# Load libraries required by the Evernote OAuth
require 'oauth'
require 'oauth/consumer'
 
# Load Thrift & Evernote Ruby libraries
require 'evernote_oauth'
 
# Client credentials
OAUTH_CONSUMER_TOKEN = 'S=s144:U=f25360:E=152a5dc441e:C=14b4e2b17f0:P=1cd:A=en-devtoken:V=2:H=6a9fd25bdbb82ae3c56c2487fc73f977'
 
# Connect to Sandbox server?
SANDBOX = false