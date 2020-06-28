# escape=`

# Use the latest Windows Server Core image with .NET Framework 4.8.
FROM mcr.microsoft.com/windows/servercore:ltsc2019

# Restore the default Windows shell for correct batch processing.
SHELL ["cmd", "/S", "/C"]

# Download the Build Tools bootstrapper.
ADD https://aka.ms/vs/16/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe

# Install Build Tools with the Microsoft.VisualStudio.Workload.AzureBuildTools workload, excluding workloads and components with known issues.
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --installPath C:\BuildTools `
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    --add Microsoft.VisualStudio.Component.VC.CMake.Project `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0

ADD https://www.python.org/ftp/python/3.8.3/python-3.8.3-amd64.exe C:\TEMP\python-3.8.3-amd64.exe

RUN C:\TEMP\python-3.8.3-amd64.exe /passive InstallAllUsers=1 PrependPath=1 Shortcuts=0 Include_doc=0

RUN pip install aqtinstall

RUN aqt install 5.12.9 windows desktop win64_msvc2017_64

# Define the entry point for the docker container.
# This entry point starts the developer command prompt and launches the PowerShell shell.
ENTRYPOINT ["C:\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
