# Digital twin Aareon
This project was made by meself and a group student from NHL stenden. in this repo there is a web based application where you have a digital twin of the office in emmen

#preinstall
 - Docker
 - python3

# install
go to the docker folder and use the command `docker compose --profile dev up` to start the docker container
then go to `https://localhost/`

Login with the credentials
administrator@aareon.nl : betoeterd12$!

the 2FA is for this version fixed on `test`. this is because you need an intern mail server of aareon to use the 2FA

# Data
To add data you will need to go to mqtt folder and make a config file from the template fill in your database credentials
Go to the update-database pyton script and install the python libary from the requirements.twt with the command `pip install -r requirements.txt`
Then use the command `python main.py` to add data to the database
