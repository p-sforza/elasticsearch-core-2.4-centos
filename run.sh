#!/usr/bin/env bash
#

ELASTIC_LOG=/usr/share/elasticsearch/logs/elasticsearch.log
echo "" > $ELASTIC_LOG

ELASTIC_PID=$(ps -aux | grep -m1 elastic | grep -v grep | awk '{ print $2 }');
if [ $ELASTIC_PID ]; then
	echo "ERROR: ELASTIC IS ALREADY UP!" 
	exit 1;
fi

echo "STARTING ELASTIC!";
runuser -l elasticsearch -c '/usr/share/elasticsearch/bin/elasticsearch -d';

until [ STARTED=$(grep started $ELASTIC_LOG) ]; do
	echo '   elastic not up...';
	sleep 1;
done

echo "ELASTIC IS UP!" 
echo "ELASTIC PROCESS: " && ps -aux | grep -m1 elastic;

echo "SHUTTING DOWN ELASTIC";
ELASTIC_PID=$(ps -aux | grep -m1 elastic | grep -v grep | awk '{ print $2 }')
kill $ELASTIC_PID;

until [ STOPPED=$(grep closed $ELASTIC_LOG) ]; do
        echo '   elastic not down...';
        sleep 1;
done
echo "ELASTIC IS DOWN!" 
echo "SCRIPT END... BYE BYE" 

