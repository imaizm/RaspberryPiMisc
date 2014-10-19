

https://github.com/naoty/chef-repo

knife solo init chef-repo
cd chef-repo

knife cookbook create apt-get -o site-cookbooks
rm site-cookbooks/apt-get/CHANGELOG.md
rm site-cookbooks/apt-get/metadata.rb
rm site-cookbooks/apt-get/README.md

knife cookbook create ruby -o site-cookbooks
rm site-cookbooks/ruby/CHANGELOG.md
rm site-cookbooks/ruby/metadata.rb
rm site-cookbooks/ruby/README.md

knife cookbook create git -o site-cookbooks
rm site-cookbooks/git/CHANGELOG.md
rm site-cookbooks/git/metadata.rb
rm site-cookbooks/git/README.md

