*** Settings ***
Resource    helpers.robot
Resource    digitalocean.robot

*** Tasks ***

Bill Collector
    ${provider}=    Select Provider
    Run Keyword And Return Status    ${provider}