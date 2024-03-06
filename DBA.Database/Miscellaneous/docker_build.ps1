param(
# Define global variables for the script
[Parameter(Mandatory=$true)] $dockerFilePath, # The Dockerfile file path.
[Parameter(Mandatory=$true)] $targetDatabase, # The database name to be created.
[Parameter(Mandatory=$true)] $dacpacFilePath, # The dacpac file path.
[Parameter(Mandatory=$true)] $saPassword	  # The default sa password for the first creation, it won't replace the password to an existing database
#[Parameter(Mandatory=$true)] $sqlDataPath,    # Change the directory where the new SQL Server database data files (.mdf) are created.
#[Parameter(Mandatory=$true)] $sqlLogPath      # Change the directory where the new SQL Server database log (.ldf) files are created.
)

docker build --file $dockerFilePath `
	--build-arg DBNAME=$targetDatabase `
	--build-arg DACPAC=$dacpacFilePath `
	--build-arg PASSWORD=$saPassword `
	--tag dba:1.0 `
	--progress=plain `
	--no-cache `
	.