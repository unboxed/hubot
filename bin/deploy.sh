mkdir hubot
cd hubot
git init && git remote add heroku git@heroku.com:ubxd-hubot.git && git pull heroku master
git reset --hard && git pull heroku master && rm script/*
cd ..
make package
cd hubot
git add . && git commit && git push heroku
cd ..
