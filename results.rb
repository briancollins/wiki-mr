#!/usr/bin/env ruby

`hadoop jar ./streaming.jar \
    -input result \
    -output sorted \
    -mapper sort.rb \
	  -file sort.rb`