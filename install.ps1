# Set up paths and variables
$projectName = "calcmcp"
$projectTag = "latest"
$catalogName = "custom"
$mcpDir = Join-Path $env:USERPROFILE ".docker\mcp"
$catalogDir = Join-Path $mcpDir "catalogs"
$toolsDir = Join-Path $catalogDir "tools"
$catalogSrcFile = Join-Path $PWD.Path ".mcp\catalog\${catalogName}-catalog.yaml"
$catalogDestFile = Join-Path $catalogDir "${catalogName}.yaml"
$toolsSrcFile = Join-Path $PWD.Path ".mcp\catalog\v3\tools\${projectName}.json"
$toolsDestFile = Join-Path $toolsDir "${projectName}.json"
$claudeDesktopConfigSrcFile = Join-Path $PWD.Path ".claude\claude_desktop_config.json"
$claudeDesktopConfigDestFile = Join-Path $env:APPDATA "Claude\claude_desktop_config.json"

# Ensure-Directories: Create necessary directories if they don't exist
function Ensure-Directories {
	Write-Host "Ensuring directories exist..."
	New-Item -ItemType Directory -Force -Path $catalogDir | Out-Null
	New-Item -ItemType Directory -Force -Path $toolsDir | Out-Null
}

# Copy-Files: Copy catalog and tool definition files to Docker MCP directories
function Copy-Files {
	Ensure-Directories

	Write-Host "Copying ${toolsSrcFile} to ${toolsDestFile}..."
	Copy-Item -Path $toolsSrcFile -Destination $toolsDestFile -Force
	Write-Host "Copying ${catalogSrcFile} to ${catalogDestFile}..."
	Copy-Item -Path $catalogSrcFile -Destination $catalogDestFile -Force

	$inputString = Read-Host -Prompt "Do you want to copy Claude Desktop configuration? (Y/N)"
	if ($inputString -eq "Y" -or $inputString -eq "y") {
		# Copy Claude Desktop configuration file
		Write-Host "Copying ${claudeDesktopConfigSrcFile} to ${claudeDesktopConfigDestFile}..."
		Copy-Item -Path $claudeDesktopConfigSrcFile -Destination $claudeDesktopConfigDestFile -Force
	}
}

# Build-DockerImage: Prompt user to build the Docker image
function Build-DockerImage {
	$inputString = Read-Host -Prompt "Do you want to build the docker image? (Y/N)"
	if ($inputString -eq "Y" -or $inputString -eq "y") {
		# Build the Docker image
		docker build -t "${projectName}:${projectTag}" .
	}
}

# IsAdmin: Check if the script is running with admin privileges
function IsAdmin {
	$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
	return $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)	
}

# Add-MCPServer: Add the MCP server to Docker Desktop
function Add-MCPServer {
	# Add the MCP server (updates the registry)
	Write-Host "Adding MCP server '$projectName'..."
	docker mcp server add $projectName
}

# Restart-DockerDesktop: Restart Docker Desktop to apply MCP changes
# NOTE: This may require admin privileges.
function Restart-DockerDesktop {
	# Stop Docker Desktop so we can add the MCP server
	Write-Host "Restarting Docker Desktop to apply MCP changes..."
	Stop-Service -Name "com.docker.service" -Force

	# Add the MCP server and list servers to verify
	Add-MCPServer

	# Now restart Docker Desktop so the extension reloads catalogs.
	Start-Service -Name "com.docker.service"
}


# Main script execution
Copy-Files
Build-DockerImage

if (-not (IsAdmin)) {
	Add-MCPServer
	Write-Host "This script needs to be run as Administrator to restart Docker Desktop."
	Write-Host "Please either manually restart Docker Desktop, or restart PowerShell as Administrator and re-run this script."
	exit 1
}
Write-Host "Administrator privileges detected."
Restart-DockerDesktop