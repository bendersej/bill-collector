*** Settings ***
Resource    helpers.robot
Resource    ./providers/digitalocean.robot
Resource    ./providers/pipedrive.robot
Resource    ./providers/namecheap.robot

*** Tasks ***

Bill Collector
    ${provider}=    Select Provider
    Run Keyword And Return Status    ${provider}