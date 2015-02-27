# eventually, you'll have some code here that uses the code in `archive-helpers.js`
# to actually download the urls you want to download.
archive = require '../helpers/archive-helpers.js'

url = 'www.naver.com'
archive.downloadUrls url

