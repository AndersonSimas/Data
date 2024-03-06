param(
# Define global variables for the script
[Parameter(Mandatory=$true)] $containerName # The container name to be created.
)

docker run -d `
	--publish 1433:1433 `
	--name $containerName `
	--hostname $containerName `
	dba:1.0

	#--volume C:/Temp/docker_SQL/$containerName/system_files:/var/opt/mssql/systemdb `
	#--volume C:/Temp/docker_SQL/$containerName/data_files:/var/opt/mssql/data `
	#--volume C:/Temp/docker_SQL/$containerName/error_log:/var/opt/mssql/error_log `
	#--volume sqlvolume:/var/opt/mssql `
	#--env MSSQL_AGENT_ENABLED='true' `
	#--env MSSQL_DUMP_DIR='/var/opt/mssql/error_log/' `
	#--env MSSQL_ERROR_LOG_FILE='/var/opt/mssql/error_log/errorlog' `
	#--env MSSQL_MASTER_DATA_FILE='/var/opt/mssql/systemdb/master.mdf' `
	#--env MSSQL_MASTER_LOG_FILE='/var/opt/mssql/systemdb/mastlog.ldf' `
	#--env MSSQL_DATA_DIR='/var/opt/mssql/data/' `
	#--env MSSQL_LOG_DIR='/var/opt/mssql/data/' `