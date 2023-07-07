FROM python:3

WORKDIR /app

# install crontab on docker container 
RUN apt-get update && apt-get -y install cron

# requirements from update-database
COPY update-database/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# requirements from update-json
COPY update-json/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# requirements from update-json
COPY update-facilitor/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt


#################
# start cronjob #
#################

# log files for cron
RUN touch /var/log/cron.log

##### add cronjobs
RUN echo "00 6 * * * root bash -c 'cd /app/update-database-retention; python3 main.py' >> /var/log/cron.log" >> /etc/crontab
RUN echo "1-59/10 * * * * root bash -c 'cd /app/update-facilitor; python3 main.py' >> /var/log/cron.log" >> /etc/crontab
RUN echo "*/10 * * * * root bash -c 'cd /app/update-database; python3 main.py' >> /var/log/cron.log" >> /etc/crontab

# follow the cronjob logs
ENTRYPOINT sleep 20 && cron start && (bash -c "cd /app/update-json && python3 main.py" > /dev/null &) && tail -f /var/log/cron.log
