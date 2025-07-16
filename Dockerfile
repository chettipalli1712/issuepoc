FROM docker.artifactory.platform.manulife.io/mssql-tools
ARG SERVER
ARG DB_NAME
ARG PORT
ARG USERNAME
ARG PASSWORD
ARG SCRIPT_FILE
ARG LOG_FILE
COPY . .

USER root
RUN chmod -R u=rwx,go=rwx ./script.sh
RUN echo "Executing the shell script to run SQL script.."
RUN ./script.sh $SERVER $DB_NAME $PORT $USERNAME $PASSWORD $SCRIPT_FILE $LOG_FILE
