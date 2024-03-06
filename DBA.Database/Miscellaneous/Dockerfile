# Reference: https://learn.microsoft.com/en-us/sql/linux/sql-server-linux-configure-environment-variables?view=sql-server-ver16
FROM mcr.microsoft.com/mssql/server:2022-latest

# Elevate to root to install required packages
USER root

# Install required package
# libicu66: International Components for Unicode(https://packages.ubuntu.com/focal/libicu66)
# NOTE: On Ubuntu 20.04 or older has a bug, this package needs to be install manually.
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/libicu66_66.1-2ubuntu2.1_amd64.deb
RUN apt update
RUN dpkg -i libicu66_66.1-2ubuntu2.1_amd64.deb

# Install required package
RUN apt-get update \
    && apt-get install unzip libunwind8 libssl-dev -y

# Install SQLPackage for Linux and make it executable
RUN wget -progress=bar:force -q -O sqlpackage.zip https://aka.ms/sqlpackage-linux \
    && unzip -qq sqlpackage.zip -d /opt/sqlpackage \
    && chmod +x /opt/sqlpackage/sqlpackage \
    && chown -R mssql /opt/sqlpackage \
    && mkdir /tmp/db \
    && chown -R mssql /tmp/db

# Configure external build arguments to allow configurability.
ARG DBNAME
ARG DACPAC
# The default sa password for the first creation, it won't replace the password to an existing database
ARG PASSWORD

# Check for mandatory build arguments
RUN \
    : "${DBNAME:?DBNAME argument needs to be set and non-empty.}" \
    : "${DACPAC:?DACPAC argument needs to be set and non-empty.}" \
    : "${PASSWORD:?PASSWORD argument needs to be set and non-empty.}"

# Add the DACPAC to the image
COPY $DACPAC /tmp/db/db.dacpac

# SQL Parameters
ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=$PASSWORD
ENV MSSQL_PID=Developer

# SQL Standard Directories
ENV MSSQL_DATA_DIR=/var/opt/mssql/data/
ENV MSSQL_LOG_DIR=/var/opt/mssql/data/

# Using temporary directory on image build
# NOTE: Should replace on container build
ENV MSSQL_DUMP_DIR=/tmp/mssql/error_log/
ENV MSSQL_ERROR_LOG_FILE=/tmp/mssql/error_log/errorlog

# All system database location
ENV MSSQL_MASTER_DATA_FILE=/var/opt/mssql/systemdb/master.mdf
ENV MSSQL_MASTER_LOG_FILE=/var/opt/mssql/systemdb/mastlog.ldf

# Launch SQL Server, confirm startup is complete, deploy the DACPAC, then terminate SQL Server.
# See https://stackoverflow.com/a/51589787/488695
RUN (/opt/mssql/bin/sqlservr &) | grep -q "Service Broker manager has started" \
    && /opt/sqlpackage/sqlpackage /Action:Publish /TargetServerName:localhost /TargetDatabaseName:${DBNAME} /TargetUser:sa /TargetPassword:$MSSQL_SA_PASSWORD /SourceFile:/tmp/db/db.dacpac /TargetTrustServerCertificate:True \
    && rm -r /tmp/db \
    && pkill sqlservr \
    && rm -r /opt/sqlpackage