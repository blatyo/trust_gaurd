# TrustGuard
This is my implementation of the algorithm described in [TrustGaurd: Countering Vulnerabilities in Reputation Management for Decentralized Overlay Networks.][1]. I haven't tested it. I just wanted to write it in code so that I could figure out what each piece meant.

Also, I realize I misspelled guard as gaurd everywhere. Its just one of those words I misspell all the time and its not worth fixing.

[1]: http://www.mathcs.emory.edu/~lxiong/research/pub/srivatsa05trustguard.pdf "TrustGaurd: Countering Vulnerabilities in Reputation Management for Decentralized Overlay Networks."

## Usage

  require 'trust_gaurd'
  
  # current raw trust value gets 2/3rds of the importance
  alpha = 0.66
  
  # previous raw trust values get 1/3rd of the importance
  beta = 0.34
  
  # a positive change in reputation rewards double the change
  pos_gamma = 2
  
  # a negative change in reputation punishes four times the change
  neg_gamma = 4
  
  # the importance of previous raw trust values degrades by a factor of 0.5
  p = 0.5
  
  tv = TrustGaurd::TrustValue.new(alpha, beta, pos_gamma, neg_gamma, p)
  
  # Gets all of raw trust value, nothing from history, and no change
  tv.calculate([100])                   #=> 66.0
  # Gets all of raw trust value, all of history, and no change
  tv.calculate([100, 100])              #=> 100.0
  # Gets 95% of raw trust value, all of history, and -5 * 4 change
  tv.calculate([100, 100, 95])          #=> 76.70000000000006
  # The rest gets a bit complicated...
  tv.calculate([100, 100, 95, 95])      #=> 87.15714285714287
  tv.calculate([100, 100, 95, 95, 77])  #=> 7.460000000000008

## Variables

Some notes about varying these values:
* When alpha > beta, history does not have as much significance as the current value. The opposite is also true.
* When pos_gamma is large, it is easier to obtain a higher trust value over time. The authors that propose this algorithm suggest that it be hard to get a good reputation.
* When pos_gamma is large, there is a large penalty for a bad reputation. The authors that propose this algorithm suggest that reputation be lost quickly if the raw trust history decreases radically.
* When p = 1, all previous raw trust values are treated equally. Generally, more recent ones should have more significance. Therefore, a p value < 1 is preferable.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Allen Madsen. See LICENSE for details.
