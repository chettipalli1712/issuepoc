FROM docker.artifactory.platform.manulife.io/mssql-tools

USER root
COPY . .

# Ensure script is executable
RUN chmod +x ./script.sh

ENTRYPOINT ["./script.sh"]
