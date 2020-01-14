

####################################
# Author:      Eric Austin
# Create date: January 2020
# Description: This script gets and sets connection strings as environmental variables. It is run interactively.
####################################

#Requires -RunAsAdministrator

#declare namespaces
using namespace System.Environment

$Selection=0
$VariableName=""
$VariableValue=""

Try {

    Clear-Host

    Do {

        #reset variable values on each loop
        $Selection=0
        $VariableName=""
        $VariableValue=""

        Do {
            Write-Host ""
            Write-Host "Options:"
            Write-Host "1. View a list of existing system environmental variables"
            Write-Host "2. Create a new system environmental variable"
            Write-Host "3. Delete an existing system environmental variable (will need variable name)"
            Write-Host ""
            $Selection=Read-Host "Selected option"
        }
        Until (($Selection -eq 1 ) -or ($Selection -eq 2) -or ($Selection -eq 3))
        
        if ($Selection -eq 1)
        {
            Write-Host "View list of existing system environmental variables"
            ([Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine)).GetEnumerator() | Sort-Object -Property Name
        }
        elseif ($Selection -eq 2)
        {
            Write-Host "Create new system environmental variable"
            $Confirm=""
            Do {
                $VariableName=Read-Host "Variable name"
                $VariableValue=Read-Host "Variable value"
                Write-Host "Variable will be:"
                Write-Host "Name: $($VariableName)"
                Write-Host "Value: $($VariableValue)"
                $Confirm=Read-Host "Is that correct? (y/n)"
            }
            until ($Confirm -eq "y")
            
            Write-Host "Adding variable..."

            #set variable
            [Environment]::SetEnvironmentVariable("$($VariableName)", "$($VariableValue)", [EnvironmentVariableTarget]::Machine)

            Write-Host "Variable added successfully"
        }
        elseif ($Selection -eq 3)
        {

            Write-Host "Delete system environmental variable"

            Do {
                $Exists=$false
                $VariableName=Read-Host "Enter variable name"
                if ([Environment]::GetEnvironmentVariables([EnvironmentVariableTarget]::Machine).$VariableName)
                {
                    $Exists=$true
                }
                else 
                {
                    $Exists=$false
                    Write-Host "Variable `"$($VariableName)`" does not exist"
                }
            }
            Until ($Exists)

            $Confirm=""
            Do {
                $Confirm=Read-Host "`"$($VariableName)`" will be deleted. Continue (y/n)?"
            }
            Until ($Confirm -eq "y")

            Write-Host "Deleting variable..."

            #delete variable
            [Environment]::SetEnvironmentVariable("$($VariableName)", $null, [EnvironmentVariableTarget]::Machine)

            Write-Host "Variable deleted successfully"

        }

    }
    Until (0 -eq 1) #loop indefinitely until application is closed

}

Catch {

    Write-Host $Error[0]

}